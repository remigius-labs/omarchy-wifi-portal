#!/bin/bash
# omarchy-wifi-portal — simulate a café captive portal on your own laptop.
#   ./fake-portal.sh on    → any http request to ping.archlinux.org is hijacked
#                            and redirected to a fake "Café Wi-Fi" login page
#   ./fake-portal.sh off   → back to normal
set -euo pipefail

HOST=ping.archlinux.org
MARK="# omarchy-wifi-portal fake"
PID=/tmp/fake-portal.pid

on() {
  grep -q "$MARK" /etc/hosts || echo "127.0.0.1 $HOST $MARK" | sudo tee -a /etc/hosts >/dev/null
  sudo python3 - <<'PY' &
import http.server, socketserver
LOGIN = """<html><body style="font-family:sans-serif;text-align:center;padding:4em">
<h1>Café Wi-Fi</h1><p>Please sign in to continue.</p>
<form><input placeholder="email"><br><br><button>Sign in</button></form></body></html>""".encode("utf-8")
class H(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path.startswith("/login"):
            self.send_response(200); self.send_header("Content-Type","text/html; charset=utf-8")
            self.end_headers(); self.wfile.write(LOGIN)
        else:  # hijack everything else, like a real portal
            self.send_response(302); self.send_header("Location","http://127.0.0.1/login")
            self.end_headers()
    def log_message(self,*a): pass
socketserver.TCPServer.allow_reuse_address = True
with socketserver.TCPServer(("127.0.0.1", 80), H) as s: s.serve_forever()
PY
  echo $! > "$PID"
  echo "Fake portal ON. Open the Wi-Fi panel — you should see the lock + red row."
  echo "Run '$0 off' when done."
}

off() {
  [ -f "$PID" ] && sudo kill "$(cat "$PID")" 2>/dev/null; rm -f "$PID"
  sudo pkill -f 'TCPServer(("127.0.0.1", 80)' 2>/dev/null || true
  sudo sed -i "/$MARK/d" /etc/hosts
  echo "Fake portal OFF."
}

case "${1:-}" in
  on) on ;;
  off) off ;;
  *) echo "usage: $0 on|off"; exit 1 ;;
esac
