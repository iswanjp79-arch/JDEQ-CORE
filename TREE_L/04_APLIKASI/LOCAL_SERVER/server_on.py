import http.server
import socketserver
import os

PORT = 8080
TANDON_DIR = r"D:\MICO_SSOT\TREE_L\02_DATA\TANDON_UPDATE"
BIND_IP = "127.0.0.1"

os.chdir(TANDON_DIR)

Handler = http.server.SimpleHTTPRequestHandler
Handler.extensions_map.update({
    ".md": "text/markdown",
    ".json": "application/json",
    ".txt": "text/plain",
})

with socketserver.TCPServer((BIND_IP, PORT), Handler) as httpd:
    httpd.allow_reuse_address = True
    print(f"Tandon Server aktif di http://{BIND_IP}:{PORT}")
    httpd.serve_forever()
