#!/usr/bin/env python3
import os, sys, json, subprocess
DECISION = os.path.expanduser("~/mico_jdeq/modules/decision_engine.py")

def route(task_type, prompt):
    """Pilih agen, kirim prompt, kembalikan hasil."""
    result = subprocess.run(["python3", DECISION, task_type], capture_output=True, text=True)
    agent = json.loads(result.stdout)["agent"]
    print(f"🤖 Merutekan ke: {agent}")
    # Kirim ke Groq sebagai default executor
    cmd = ["python3", os.path.expanduser("~/mico_jdeq/scripts/groq_controller_v3.py"), prompt]
    output = subprocess.run(cmd, capture_output=True, text=True)
    return output.stdout

if __name__ == "__main__":
    if len(sys.argv) > 2:
        print(route(sys.argv[1], " ".join(sys.argv[2:])))
    else:
        print("Usage: python3 auto_router.py <task_type> <prompt>")
        print("Task types: code, audit, research, multimodal, planning, security")
