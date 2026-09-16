#!/usr/bin/env python3
import http.server, json, os

PORT = 8000
URL_FILE = os.path.expanduser("~/JDEQ_CLONE/bridge/ngrok_url.txt")

class RelayHandler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/health":
            self.send_response(200)
            self.end_headers()
            self.wfile.write(b'{"status":"ok","device":"infinix"}')
        else:
            self.send_response(404)
            self.end_headers()

    def do_POST(self):
        length = int(self.headers.get('Content-Length', 0))
        body = self.rfile.read(length) if length else b'{}'
        try:
            data = json.loads(body)
            msg = data.get("messages", [{}])[-1].get("content", "")
            print(f"[Infinix Relay] Menerima: {msg[:100]}...")
            self.send_response(200)
            self.end_headers()
            self.wfile.write(json.dumps({"status":"relayed","msg_len":len(msg)}).encode())
        except:
            self.send_response(500)
            self.end_headers()

if __name__ == "__main__":
    os.makedirs(os.path.dirname(URL_FILE), exist_ok=True)
    with open(URL_FILE, 'w') as f:
        f.write("http://localhost:8000/v1/chat/completions")
    print(f"Ghost Relay Infinix aktif di port {PORT}")
    http.server.HTTPServer(("0.0.0.0", PORT), RelayHandler).serve_forever()
