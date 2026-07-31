import os, sys, requests
HF_TOKEN = os.environ.get("HF_TOKEN", "")
HF_USER = "iswanjp79"
def upload(file_path, repo_name):
    headers = {"Authorization": f"Bearer {HF_TOKEN}"}
    url = f"https://huggingface.co/api/datasets/{HF_USER}/{repo_name}/upload"
    with open(file_path, "rb") as f:
        r = requests.put(url, headers=headers, data=f)
    return r.json()
if __name__ == "__main__":
    print("Hugging Face Storage siap.")
