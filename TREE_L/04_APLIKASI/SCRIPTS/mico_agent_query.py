import os
import sys

TARGET_DIR = r"D:\MICO_SSOT\KNOWLEDGE_BASE\03_FOTO_PROYEK"

def list_md_files():
    files = []
    for f in os.listdir(TARGET_DIR):
        if f.endswith(".jpg.md"):
            files.append(f)
    return sorted(files)

def count_indexed():
    total = 0
    indexed = 0
    for f in os.listdir(TARGET_DIR):
        if f.endswith(".jpg.md"):
            total += 1
            with open(os.path.join(TARGET_DIR, f), "r", encoding="utf-8") as fh:
                content = fh.read()
            if "Status_RAG: INDEXED" in content:
                indexed += 1
    return total, indexed

def search_files(keyword):
    results = []
    for f in os.listdir(TARGET_DIR):
        if f.endswith(".jpg.md"):
            if keyword.lower() in f.lower():
                results.append(f)
    return results

def main():
    if len(sys.argv) < 2:
        print("Gunakan: -List, -Count, atau -Search <kata_kunci>")
        return

    mode = sys.argv[1]
    if mode == "-List":
        for f in list_md_files():
            print(f)
    elif mode == "-Count":
        total, indexed = count_indexed()
        print(f"Total .jpg.md: {total}")
        print(f"Status INDEXED: {indexed}")
    elif mode == "-Search" and len(sys.argv) >= 3:
        keyword = sys.argv[2]
        for f in search_files(keyword):
            print(f)
    else:
        print("Argumen tidak dikenal.")

if __name__ == "__main__":
    main()
