# pile_distribution_calc.py
# Kalkulator distribusi beban tiang pancang sederhana
# Untuk PC-i5, Python ringan, tanpa software struktur komersial

import math
import json
import datetime
import os

def hitung_reaksi_tiang(P, Mx, My, koordinat):
    n = len(koordinat)
    x = [p[0] for p in koordinat]
    y = [p[1] for p in koordinat]

    sum_x2 = sum(i*i for i in x)
    sum_y2 = sum(i*i for i in y)

    x_bar = sum(x) / n
    y_bar = sum(y) / n

    hasil = []
    for i, (xi, yi) in enumerate(koordinat, start=1):
        dx = xi - x_bar
        dy = yi - y_bar
        P_i = (P / n) - (My * dx / sum_x2) - (Mx * dy / sum_y2)
        hasil.append({
            "tiang_ke": i,
            "koordinat": [xi, yi],
            "reaksi_aksial": round(P_i, 3)
        })

    return {
        "jumlah_tiang": n,
        "P_total": P,
        "Mx": Mx,
        "My": My,
        "titik_berat": [round(x_bar, 3), round(y_bar, 3)],
        "reaksi_tiang": hasil
    }

def main():
    # Contoh data dummy, nanti bisa diganti file JSON dari 02_DATA
    P = 1000  # kN
    Mx = 50   # kNm
    My = -30  # kNm
    koordinat = [
        (-1.5, 1.5),
        (1.5, 1.5),
        (-1.5, -1.5),
        (1.5, -1.5),
        (0.0, 0.0),
        (-1.5, 0.0),
        (1.5, 0.0)
    ]

    result = hitung_reaksi_tiang(P, Mx, My, koordinat)

    out_dir = r"D:\MICO_SSOT\TREE_L\02_DATA\CURATED"
    os.makedirs(out_dir, exist_ok=True)
    ts = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    out_file = os.path.join(out_dir, f"hasil_reaksi_tiang_{ts}.json")

    with open(out_file, "w", encoding="utf-8") as f:
        json.dump(result, f, indent=2)

    print(f"Hasil perhitungan disimpan di: {out_file}")
    print(json.dumps(result, indent=2))

if __name__ == "__main__":
    main()
