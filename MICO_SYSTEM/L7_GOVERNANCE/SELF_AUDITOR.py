import json, os
from datetime import datetime

class SelfAuditor:
    def __init__(self):
        self.evidence_log = "MICO_SYSTEM/L6_EVIDENCE_AUDIT/AGENT_LOOP.jsonl"
        self.audit_report = "MICO_SYSTEM/L6_EVIDENCE_AUDIT/AUDIT_REPORT.md"
        # Daftar status yang sah (SUCCESS dan VERIFIED dianggap benar)
        self.VALID_STATUSES = ["SUCCESS", "VERIFIED", "DONE"] 

    def verify_integrity(self):
        print("[AUDITOR] Memulai koreksi diri (PDCA Check)...")
        
        if not os.path.exists(self.evidence_log):
            return "FAILED: Evidence log tidak ditemukan."

        lines = 0
        errors = 0
        with open(self.evidence_log, 'r') as f:
            for line in f:
                lines += 1
                try:
                    data = json.loads(line)
                    if data.get("status") not in self.VALID_STATUSES:
                        errors += 1
                except:
                    errors += 1

        with open(self.audit_report, "w") as f:
            f.write(f"# SELF-AUDIT REPORT\n")
            f.write(f"Timestamp: {datetime.now().isoformat()}\n")
            f.write(f"Total Events: {lines}\n")
            f.write(f"Errors Found: {errors}\n")
            f.write(f"Verdict: {'PASS' if errors == 0 else 'NEEDS_CORRECTION'}\n")
            
        print(f"[AUDITOR] Audit Selesai. {lines} events diperiksa, {errors} error ditemukan.")
        return "PASS" if errors == 0 else "NEEDS_CORRECTION"

if __name__ == "__main__":
    auditor = SelfAuditor()
    result = auditor.verify_integrity()
    print(f"[VERDICT] {result}")
