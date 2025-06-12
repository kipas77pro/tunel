#!/bin/bash
curl -sS ipv4.icanhazip.com > /usr/bin/.ipvps
REPO="https://raw.githubusercontent.com/kipas77pro/tunel/main/wsoket/main/"
wget -O /usr/bin/ws "${REPO}ws"
wget -O /usr/bin/config.conf "${REPO}config.conf"
wget -O /etc/systemd/system "${REPO}ws.service"
chmod +x /usr/bin
systemctl daemon-reload
systemctl enable ws.service
systemctl start ws.service
systemctl restart ws.service
