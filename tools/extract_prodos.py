#!/usr/bin/env python3
"""
ProDOS Disk Image File Extractor
Extracts files from Apple II ProDOS .po and .dsk disk images

Supports seedling, sapling, tree, and subdirectory storage types.

Cowritten by Claude Code Opus 4.6
"""

import struct
import sys
from pathlib import Path

# ProDOS constants
BLOCK_SIZE = 512
VOLUME_DIR_BLOCK = 2
ENTRY_SIZE = 39
ENTRIES_PER_BLOCK = 13  # (512 - 4) // 39 = 13

# Storage types (high nibble of storage_type_and_name_length)
STORAGE_DELETED = 0x0
STORAGE_SEEDLING = 0x1
STORAGE_SAPLING = 0x2
STORAGE_TREE = 0x3
STORAGE_SUBDIR = 0xD
STORAGE_SUBDIR_HEADER = 0xE
STORAGE_VOLUME_HEADER = 0xF

# File type codes
FILE_TYPES = {
    0x00: 'UNK',
    0x01: 'BAD',
    0x04: 'TXT',
    0x06: 'BIN',
    0x0F: 'DIR',
    0x19: 'ADB',
    0x1A: 'AWP',
    0x1B: 'ASP',
    0xFC: 'BAS',
    0xFD: 'VAR',
    0xFE: 'REL',
    0xFF: 'SYS',
}

# DOS 3.3 / ProDOS sector interleave table for .dsk images
# Maps logical ProDOS sector to physical DOS sector
DSK_INTERLEAVE = [0, 2, 4, 6, 8, 10, 12, 14, 1, 3, 5, 7, 9, 11, 13, 15]


def read_block_po(data: bytes, block: int) -> bytes:
    """Read a 512-byte block from a .po image (blocks stored sequentially)."""
    offset = block * BLOCK_SIZE
    if offset + BLOCK_SIZE > len(data):
        return b'\x00' * BLOCK_SIZE
    return data[offset:offset + BLOCK_SIZE]


def read_block_dsk(data: bytes, block: int) -> bytes:
    """Read a 512-byte block from a .dsk image (DOS sector interleave)."""
    # Each ProDOS block spans two 256-byte DOS sectors.
    # Block N -> track = (N * 2) // 16, sector pair from interleave table.
    sectors_per_track = 16
    sector_size = 256
    track_size = sectors_per_track * sector_size

    # Two sectors per block
    raw_sector = block * 2
    track0 = raw_sector // sectors_per_track
    sec0 = DSK_INTERLEAVE[raw_sector % sectors_per_track]

    raw_sector1 = block * 2 + 1
    track1 = raw_sector1 // sectors_per_track
    sec1 = DSK_INTERLEAVE[raw_sector1 % sectors_per_track]

    off0 = track0 * track_size + sec0 * sector_size
    off1 = track1 * track_size + sec1 * sector_size

    if off0 + sector_size > len(data) or off1 + sector_size > len(data):
        return b'\x00' * BLOCK_SIZE
    return data[off0:off0 + sector_size] + data[off1:off1 + sector_size]


def make_block_reader(disk_path: Path, data: bytes):
    """Return the appropriate block reader for the image format."""
    suffix = disk_path.suffix.lower()
    if suffix == '.dsk':
        return lambda block: read_block_dsk(data, block)
    else:
        # .po and everything else treated as ProDOS-order
        return lambda block: read_block_po(data, block)


def decode_prodos_date(date_word: int, time_word: int) -> str:
    """Decode ProDOS date/time into a readable string."""
    if date_word == 0:
        return '<No Date>'
    day = date_word & 0x1F
    month = (date_word >> 5) & 0x0F
    year = (date_word >> 9) & 0x7F
    # ProDOS years: 0-39 = 2000-2039, 40-99 = 1940-1999
    if year < 40:
        year += 2000
    else:
        year += 1900
    hour = (time_word >> 8) & 0x1F
    minute = time_word & 0x3F
    return f'{year:04d}-{month:02d}-{day:02d} {hour:02d}:{minute:02d}'


def parse_entry(entry_data: bytes) -> dict:
    """Parse a 39-byte ProDOS directory entry."""
    storage_type_name_len = entry_data[0]
    storage_type = (storage_type_name_len >> 4) & 0x0F
    name_length = storage_type_name_len & 0x0F

    if storage_type == STORAGE_DELETED or storage_type_name_len == 0:
        return None

    name = entry_data[1:1 + name_length].decode('ascii', errors='replace')
    file_type = entry_data[16]
    key_pointer = struct.unpack_from('<H', entry_data, 17)[0]
    blocks_used = struct.unpack_from('<H', entry_data, 19)[0]
    eof = entry_data[21] | (entry_data[22] << 8) | (entry_data[23] << 16)

    creation_date = struct.unpack_from('<H', entry_data, 24)[0]
    creation_time = struct.unpack_from('<H', entry_data, 26)[0]
    version = entry_data[28]
    min_version = entry_data[29]
    access = entry_data[30]
    aux_type = struct.unpack_from('<H', entry_data, 31)[0]
    last_mod_date = struct.unpack_from('<H', entry_data, 33)[0]
    last_mod_time = struct.unpack_from('<H', entry_data, 35)[0]
    header_pointer = struct.unpack_from('<H', entry_data, 37)[0]

    return {
        'storage_type': storage_type,
        'name': name,
        'file_type': file_type,
        'key_pointer': key_pointer,
        'blocks_used': blocks_used,
        'eof': eof,
        'creation': decode_prodos_date(creation_date, creation_time),
        'version': version,
        'min_version': min_version,
        'access': access,
        'aux_type': aux_type,
        'last_mod': decode_prodos_date(last_mod_date, last_mod_time),
        'header_pointer': header_pointer,
    }


def read_directory(read_block, key_block: int) -> list:
    """Read all entries from a directory starting at key_block.

    The first block of a directory contains the volume/subdirectory header
    at the first entry slot. Subsequent entries are file/subdir entries.
    Blocks are chained via prev/next pointers at bytes 0-3.
    """
    entries = []
    block_num = key_block
    first_block = True

    while block_num != 0:
        block = read_block(block_num)
        next_block = struct.unpack_from('<H', block, 2)[0]

        # Entries start after the 4-byte prev/next pointers
        # First entry in the first block is the directory header (skip it)
        start_entry = 1 if first_block else 0

        for i in range(ENTRIES_PER_BLOCK):
            offset = 4 + i * ENTRY_SIZE
            entry_data = block[offset:offset + ENTRY_SIZE]
            if len(entry_data) < ENTRY_SIZE:
                break

            if first_block and i == 0:
                # This is the volume/subdirectory header; skip it
                continue

            entry = parse_entry(entry_data)
            if entry is not None:
                entries.append(entry)

        first_block = False
        block_num = next_block

    return entries


def get_volume_name(read_block) -> str:
    """Read the volume name from the volume directory header."""
    block = read_block(VOLUME_DIR_BLOCK)
    header_byte = block[4]
    name_length = header_byte & 0x0F
    return block[5:5 + name_length].decode('ascii', errors='replace')


def read_seedling(read_block, key_pointer: int, eof: int) -> bytes:
    """Read a seedling file (single data block)."""
    if key_pointer == 0:
        return b''
    block = read_block(key_pointer)
    return block[:eof]


def read_sapling(read_block, key_pointer: int, eof: int) -> bytes:
    """Read a sapling file (one index block pointing to data blocks)."""
    if key_pointer == 0:
        return b''
    index_block = read_block(key_pointer)
    file_data = bytearray()
    remaining = eof

    # Index block: low bytes at 0-255, high bytes at 256-511
    for i in range(256):
        if remaining <= 0:
            break
        data_block_num = index_block[i] | (index_block[256 + i] << 8)
        if data_block_num == 0:
            # Sparse file: zero-filled block
            chunk_size = min(BLOCK_SIZE, remaining)
            file_data.extend(b'\x00' * chunk_size)
        else:
            data_block = read_block(data_block_num)
            chunk_size = min(BLOCK_SIZE, remaining)
            file_data.extend(data_block[:chunk_size])
        remaining -= chunk_size

    return bytes(file_data)


def read_tree(read_block, key_pointer: int, eof: int) -> bytes:
    """Read a tree file (master index -> index blocks -> data blocks)."""
    if key_pointer == 0:
        return b''
    master_block = read_block(key_pointer)
    file_data = bytearray()
    remaining = eof

    # Master index: low bytes at 0-255, high bytes at 256-511
    for mi in range(128):
        if remaining <= 0:
            break
        index_block_num = master_block[mi] | (master_block[256 + mi] << 8)
        if index_block_num == 0:
            # Sparse: entire index block worth of zeros (up to 256 * 512)
            chunk = min(256 * BLOCK_SIZE, remaining)
            file_data.extend(b'\x00' * chunk)
            remaining -= chunk
            continue

        index_block = read_block(index_block_num)

        for di in range(256):
            if remaining <= 0:
                break
            data_block_num = index_block[di] | (index_block[256 + di] << 8)
            if data_block_num == 0:
                chunk_size = min(BLOCK_SIZE, remaining)
                file_data.extend(b'\x00' * chunk_size)
            else:
                data_block = read_block(data_block_num)
                chunk_size = min(BLOCK_SIZE, remaining)
                file_data.extend(data_block[:chunk_size])
            remaining -= chunk_size

    return bytes(file_data)


def extract_file_data(read_block, entry: dict) -> bytes:
    """Extract file data based on storage type."""
    storage = entry['storage_type']
    key = entry['key_pointer']
    eof = entry['eof']

    if storage == STORAGE_SEEDLING:
        return read_seedling(read_block, key, eof)
    elif storage == STORAGE_SAPLING:
        return read_sapling(read_block, key, eof)
    elif storage == STORAGE_TREE:
        return read_tree(read_block, key, eof)
    else:
        print(f"  Warning: unsupported storage type ${storage:X}")
        return b''


def resolve_path(read_block, path_str: str) -> tuple:
    """Resolve a path like /VOLUME/SUBDIR/FILE to (directory_entries, target_name).

    Returns (entry, parent_entries) where entry is the matching file entry,
    or (None, []) if not found.
    """
    # Normalize: strip leading slash, split into components
    path_str = path_str.strip('/')
    components = [c.upper() for c in path_str.split('/') if c]

    if not components:
        return None, []

    # Start from volume directory
    volume_name = get_volume_name(read_block)
    entries = read_directory(read_block, VOLUME_DIR_BLOCK)

    # If first component matches volume name, skip it
    if components[0] == volume_name.upper():
        components = components[1:]

    if not components:
        return None, entries

    # Walk through subdirectories
    for i, component in enumerate(components):
        target = None
        for entry in entries:
            if entry['name'].upper() == component:
                target = entry
                break

        if target is None:
            return None, entries

        # Last component: return the entry
        if i == len(components) - 1:
            return target, entries

        # Intermediate component: must be a directory
        if target['storage_type'] != STORAGE_SUBDIR:
            print(f"  Error: '{target['name']}' is not a directory")
            return None, []

        entries = read_directory(read_block, target['key_pointer'])

    return None, entries


def list_directory_recursive(read_block, key_block: int, prefix: str, depth: int):
    """List all files in a directory and its subdirectories."""
    entries = read_directory(read_block, key_block)

    for entry in entries:
        ft = entry['file_type']
        type_name = FILE_TYPES.get(ft, f'${ft:02X}')
        storage = entry['storage_type']

        if storage == STORAGE_SUBDIR:
            # Directory entry
            full_path = f'{prefix}{entry["name"]}/'
            print(f'  DIR          {full_path}')
            list_directory_recursive(
                read_block, entry['key_pointer'], full_path, depth + 1
            )
        else:
            # File entry
            eof = entry['eof']
            aux = entry['aux_type']
            full_path = f'{prefix}{entry["name"]}'
            aux_str = f'${aux:04X}' if aux != 0 else '     '
            print(f'  {type_name:3s}  {eof:7d}  {aux_str}  {full_path}')


def main():
    if len(sys.argv) < 2:
        print('Usage: python extract_prodos.py <disk.po|disk.dsk> [path]')
        print('  Without path: lists all files')
        print('  With path:    extracts that file')
        print()
        print('Examples:')
        print('  python extract_prodos.py disk.po')
        print('  python extract_prodos.py disk.po FILENAME')
        print('  python extract_prodos.py disk.po /SUBDIR/FILE')
        sys.exit(1)

    disk_path = Path(sys.argv[1])
    if not disk_path.exists():
        print(f'Error: {disk_path} not found')
        sys.exit(1)

    with open(disk_path, 'rb') as f:
        disk_data = f.read()

    read_block = make_block_reader(disk_path, disk_data)

    # Read volume name
    volume_name = get_volume_name(read_block)

    if len(sys.argv) < 3:
        # List all files
        print(f'\nVolume: /{volume_name}')
        print(f'{"":2s}{"Type":4s} {"Size":>7s}  {"Aux":5s}  Path')
        print('-' * 60)
        list_directory_recursive(read_block, VOLUME_DIR_BLOCK, '/', 0)
        print()
    else:
        # Extract a specific file
        target_path = sys.argv[2]
        entry, _ = resolve_path(read_block, target_path)

        if entry is None:
            print(f"File '{target_path}' not found")
            sys.exit(1)

        if entry['storage_type'] == STORAGE_SUBDIR:
            print(f"'{entry['name']}' is a directory, cannot extract")
            sys.exit(1)

        binary = extract_file_data(read_block, entry)

        ft = entry['file_type']
        type_name = FILE_TYPES.get(ft, f'${ft:02X}')
        aux = entry['aux_type']
        eof = entry['eof']

        # Choose output extension based on file type
        ext_map = {
            0x04: '.txt',
            0x06: '.bin',
            0xFC: '.bas',
            0xFF: '.sys',
        }
        ext = ext_map.get(ft, '.bin')
        out_name = entry['name'].replace(' ', '_').lower() + ext
        out_path = disk_path.parent / out_name

        with open(out_path, 'wb') as f:
            f.write(binary)

        print(f'Extracted: {entry["name"]}')
        print(f'  Type:         {type_name} (${ft:02X})')
        print(f'  Storage:      {entry["storage_type"]}')
        print(f'  Size:         {eof} bytes (${eof:04X})')
        print(f'  Aux Type:     ${aux:04X}', end='')
        if ft == 0x06:
            print(f'  (load address)')
        elif ft == 0xFF:
            print(f'  (load address)')
        else:
            print()
        print(f'  Blocks Used:  {entry["blocks_used"]}')
        print(f'  Created:      {entry["creation"]}')
        print(f'  Modified:     {entry["last_mod"]}')
        print(f'  Saved to:     {out_name}')


if __name__ == '__main__':
    main()
