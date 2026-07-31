#!/usr/bin/env python3
import json, os, sys
REGISTRY = os.path.expanduser("~/mico_jdeq/registry/ai_workers.json")
TIER_POLICY = "/srv/jdeq/authority/uniforms/tier_policy.json"

def load_json(path):
    with open(path) as f: return json.load(f)

def decide(task_type):
    """Pilih agen terbaik berdasarkan task."""
    registry = load_json(REGISTRY)
    # Mapping task ke role
    task_map = {
        "code": ["groq", "github_copilot", "deepseek_agent"],
        "audit": ["claude", "dola"],
        "research": ["perplexity", "chatgpt"],
        "multimodal": ["gemini_3", "chatgpt"],
        "planning": ["deepseek_agent", "groq"],
        "security": ["dola", "claude"],
        "orchestration": ["jarvis", "deepseek_agent"]
    }
    candidates = task_map.get(task_type, ["deepseek_agent"])
    for agent_id in candidates:
        if agent_id in registry:
            return {"agent": agent_id, "status": registry[agent_id].get("status","unknown")}
    return {"agent": "deepseek_agent", "status": "fallback"}

if __name__ == "__main__":
    task = sys.argv[1] if len(sys.argv) > 1 else "code"
    result = decide(task)
    print(json.dumps(result, ensure_ascii=False))
