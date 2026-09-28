import os, json, hashlib, datetime, urllib.request
from pathlib import Path

key   = os.environ['GROQ_API_KEY']
jt    = os.environ.get('JOB_TYPE', 'translate')
lang  = os.environ.get('TARGET_LANG', 'id')
text  = os.environ['JOB_TEXT']
runid = os.environ.get('GITHUB_RUN_ID', 'local')

body = json.dumps({
    'model': 'llama-3.3-70b-versatile',
    'messages': [
        {'role': 'system', 'content': f'Terjemahkan ke bahasa {lang}. Pertahankan istilah teknis. Tanpa opini.'},
        {'role': 'user', 'content': text}
    ],
    'temperature': 0.2
}).encode()

req = urllib.request.Request(
    'https://api.groq.com/openai/v1/chat/completions',
    data=body, method='POST',
    headers={'Authorization': f'Bearer {key}', 'Content-Type': 'application/json'}
)
with urllib.request.urlopen(req, timeout=120) as r:
    result = json.loads(r.read().decode())['choices'][0]['message']['content']

out = {
    'status': 'OK',
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