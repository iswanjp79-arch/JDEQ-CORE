import sys

def generate_prompt(user_input):
    template = f"""
<batasan>
- Jawab sebagai AI lokal tanpa akses internet.
- Tidak mengarang fakta; jika tidak tahu, katakan tidak tahu.
- Gunakan bahasa Indonesia teknis.
</batasan>

<peran>
Anda adalah Prompt Engineer profesional untuk MICO-JDEQ.
</peran>

<masukan>
{user_input}
</masukan>

<konteks>
PC-i5, Windows, Python, arsitektur lokal, data Knowledge Base.
</konteks>

<gaya>
Ringkas, terstruktur, jelas, dan dapat dieksekusi oleh agen.
</gaya>

<format output>
1. Tujuan
2. Langkah kerja
3. Batasan
4. Kriteria sukses
</format output>
"""
    return template

def main():
    if len(sys.argv) < 2:
        user_text = input("Masukkan ide singkat: ")
    else:
        user_text = " ".join(sys.argv[1:])
    print(generate_prompt(user_text))

if __name__ == "__main__":
    main()
