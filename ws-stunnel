#!/bin/bash

# WebSocket (Python Mod) Installer - Ringan untuk Injek

echo "Installing WebSocket Python service..."

apt update -y && apt install -y python3 python3-pip

cat > /usr/local/bin/ws-ssh << END
#!/usr/bin/env python3
import asyncio, websockets, subprocess, os

async def handler(websocket, path):
    os.environ['SSH_CONNECTION'] = 'websocket'
    proc = await asyncio.create_subprocess_exec(
        '/bin/login',
        stdin=asyncio.subprocess.PIPE,
        stdout=asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.STDOUT
    )
    async def read_ws():
        async for msg in websocket:
            proc.stdin.write(msg.encode())
            await proc.stdin.drain()
    async def write_ws():
        while True:
            data = await proc.stdout.read(1024)
            if not data:
                break
            await websocket.send(data.decode(errors='ignore'))
    await asyncio.wait([read_ws(), write_ws()])

start_server = websockets.serve(handler, "0.0.0.0", 80)

asyncio.get_event_loop().run_until_complete(start_server)
asyncio.get_event_loop().run_forever()
END

chmod +x /usr/local/bin/ws-ssh

cat > /etc/systemd/system/ws-ssh.service << EOF
[Unit]
Description=SSH WebSocket
After=network.target

[Service]
ExecStart=/usr/local/bin/ws-ssh
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reexec
systemctl daemon-reload
systemctl enable ws-ssh
systemctl start ws-ssh

echo "WebSocket SSH running on port 80"
