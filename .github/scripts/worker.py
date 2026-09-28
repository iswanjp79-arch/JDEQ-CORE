import os, json, hashlib, datetime, requests
from pathlib import Path

key   = os.environ['GROQ_API_KEY']
jt    = os.environ.get('JOB_TYPE', 'translate')
lang  = os.environ.get('TARGET_LANG', 'id')
text  = os.environ['JOB_TEXT']
runid = os.environ.get('GITHUB_RUN_ID', 'local')
model = os.environ.get('GROQ_MODEL', 'openai/gpt-oss-120b')

r = requests.post(
    'https://api.groq.com/openai/v1/chat/completions',
    headers={
        'Authorization': f'Bearer {key}',
        'Content-Type': 'application/json',
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0 Safari/537.36',
        'Accept': 'application/json',
    },
    json={
        'model': model,
        'messages': [
            {'role': 'system', 'content': f'Terjemahkan ke bahasa {lang}. Pertahankan istilah teknis. Tanpa opini.'},
            {'role': 'user', 'content': text}
        ],
        'temperature': 0.2
    },
    timeout=120
)
r.raise_for_status()
result = r.json()['choices'][0]['message']['content']

out = {
    'status': 'OK',
    'model_used': model,
    'job_type': jt,
    'run_id': runid,
    'processed_at': datetime.datetime.now(datetime.timezone.utc).isoformat(),
    'source_sha256': hashlib.sha256(text.encode()).hexdigest(),
    'input': text,
    'result': result
}
p = Path('results') / f'result_{runid}.json'
p.parent.mkdir(exist_ok=True)
p.write_text(json.dumps(out, ensure_ascii=False, indent=2), encoding='utf-8')
print(f'WROTE {p}')
print(f'MODEL {model}')