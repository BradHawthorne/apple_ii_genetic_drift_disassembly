#!/usr/bin/env python3
"""
DOS 3.3 Disk Image File Extractor
Extracts binary files from Apple II DOS 3.3 .dsk images

Cowritten by Claude Code Opus 4.5
"""

import struct
import sys
from pathlib import Path

# DOS 3.3 constants
TRACK_SIZE = 16 * 256  # 16 sectors per track, 256 bytes per sector
SECTOR_SIZE = 256
VTOC_TRACK = 17
VTOC_SECTOR = 0
CATALOG_TRACK = 17
CATALOG_SECTOR_START = 15

# File type codes
FILE_TYPES = {
    0x00: 'T',   # Text
    0x01: 'I',   # Integer BASIC
    0x02: 'A',   # Applesoft BASIC
    0x04: 'B',   # Binary
    0x08: 'S',   # Type S
    0x10: 'R',   # Relocatable
    0x20: 'a',   # Type a
    0x40: 'b',   # Type b
}

def read_sector(data: bytes, track: int, sector: int) -> bytes:
    """Read a sector from the disk image (raw .dsk format, no interleave)."""
    offset = track * TRACK_SIZE + sector * SECTOR_SIZE
    return data[offset:offset + SECTOR_SIZE]

def decode_filename(raw: bytes) -> str:
    """Decode Apple II high-bit ASCII filename."""
    return ''.join(chr(b & 0x7F) for b in raw).strip()

def list_catalog(data: bytes) -> list:
    """List all files in the catalog."""
    files = []

    # Read VTOC to get catalog location
    vtoc = read_sector(data, VTOC_TRACK, VTOC_SECTOR)
    cat_track = vtoc[1]
    cat_sector = vtoc[2]

    while cat_track != 0:
        sector_data = read_sector(data, cat_track, cat_sector)

        # Next catalog sector
        cat_track = sector_data[1]
        cat_sector = sector_data[2]

        # Process file entries (7 per sector, 35 bytes each, starting at offset 11)
        for i in range(7):
            entry_offset = 11 + i * 35
            entry = sector_data[entry_offset:entry_offset + 35]

            if entry[0] == 0x00:  # Empty entry
                continue
            if entry[0] == 0xFF:  # Deleted
                continue

            ts_list_track = entry[0]
            ts_list_sector = entry[1]
            file_type_byte = entry[2]
            filename = decode_filename(entry[3:33])
            sector_count = entry[33] | (entry[34] << 8)

            locked = bool(file_type_byte & 0x80)
            file_type = file_type_byte & 0x7F
            type_char = FILE_TYPES.get(file_type, '?')

            files.append({
                'name': filename,
                'type': type_char,
                'type_byte': file_type,
                'locked': locked,
                'sectors': sector_count,
                'ts_track': ts_list_track,
                'ts_sector': ts_list_sector,
            })

    return files

def extract_file(data: bytes, file_info: dict) -> tuple:
    """Extract a file from the disk image. Returns (load_address, length, binary_data)."""
    ts_track = file_info['ts_track']
    ts_sector = file_info['ts_sector']

    file_data = bytearray()
    load_addr = None
    length = None
    first_data_sector = True

    while ts_track != 0:
        ts_list = read_sector(data, ts_track, ts_sector)

        # Next T/S list sector
        ts_track = ts_list[1]
        ts_sector = ts_list[2]

        # Data sector pairs start at offset 12
        for i in range(122):  # Up to 122 sector pairs per T/S list
            pair_offset = 12 + i * 2
            data_track = ts_list[pair_offset]
            data_sector = ts_list[pair_offset + 1]

            if data_track == 0:
                break

            sector = read_sector(data, data_track, data_sector)

            # For binary files, first sector contains load address and length
            if first_data_sector and file_info['type'] == 'B':
                load_addr = sector[0] | (sector[1] << 8)
                length = sector[2] | (sector[3] << 8)
                file_data.extend(sector[4:])
                first_data_sector = False
            else:
                file_data.extend(sector)

    # Trim to actual length for binary files
    if length is not None and len(file_data) > length:
        file_data = file_data[:length]

    return load_addr, length, bytes(file_data)

def main():
    if len(sys.argv) < 2:
        print("Usage: python extract_dos33.py <disk.dsk> [filename]")
        print("  Without filename: lists all files")
        print("  With filename: extracts that file")
        sys.exit(1)

    disk_path = Path(sys.argv[1])
    with open(disk_path, 'rb') as f:
        disk_data = f.read()

    files = list_catalog(disk_data)

    if len(sys.argv) < 3:
        # List catalog
        print(f"\nCatalog of {disk_path.name}:")
        print("-" * 50)
        for f in files:
            lock = '*' if f['locked'] else ' '
            print(f" {lock}{f['type']} {f['sectors']:3d} {f['name']}")
        print()
    else:
        # Extract file
        target_name = sys.argv[2].upper()
        file_info = None
        for f in files:
            if f['name'] == target_name:
                file_info = f
                break

        if file_info is None:
            print(f"File '{target_name}' not found")
            sys.exit(1)

        load_addr, length, binary = extract_file(disk_data, file_info)

        # Save to .bin file
        out_name = target_name.replace(' ', '_').lower() + '.bin'
        with open(disk_path.parent / out_name, 'wb') as f:
            f.write(binary)

        print(f"Extracted: {target_name}")
        print(f"  Type: Binary")
        print(f"  Load Address: ${load_addr:04X}")
        print(f"  Length: {length} bytes (${length:04X})")
        print(f"  Saved to: {out_name}")

if __name__ == '__main__':
    main()
