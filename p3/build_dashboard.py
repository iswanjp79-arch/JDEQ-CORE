import json

with open('/var/log/mico-jdeq/OBSERVABILITY.json') as f:
    d = json.load(f)

print(f"- CPU Load: {d['cpu_load']}")
print(f"- Mem Free: {d['mem_free_gb']} GB")
print(f"- Disk Free: {d['disk_free_gb']} GB")
print(f"- Verifier: {d['verifier_status']}")
print(f"- Task Contracts: {d['task_contract_count']}")
print(f"- Evidence Chain: {d['evidence_chain_length']}")
print(f"- Alerts: {d['alerts'] or 'none'}")
