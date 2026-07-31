#!/usr/bin/env python3
import os, sys, json, subprocess
REPO_DIR = os.path.expanduser("~/mico_jdeq")
def ls_repo():
    return subprocess.run(["find", REPO_DIR, "-maxdepth", "2", "-type", "d"], capture_output=True, text=True).stdout
if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == "struktur":
        print(ls_repo())
    else:
        print("Usage: python3 groq_github_auditor.py struktur")
