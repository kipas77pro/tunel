#!/bin/bash

NC='\033[0;37m'
green='\033[0;32m' 

clear
source /var/lib/scrz-prem/ipvps.conf
if [[ "$IP" = "" ]]; then
domain=$(cat /etc/xray/domain)
else
domain=$IP
fi

domain=$(cat /root/domain)
sleep 1
mkdir -p /etc/xray 
echo -e "[ ${green}INFO${NC} ] Checking... "
apt install iptables iptables-persistent -y
sleep 1
echo -e "[ ${green}INFO$NC ] Setting ntpdate"
ntpdate pool.ntp.org 
timedatectl set-ntp true
sleep 1
echo -e "[ ${green}INFO$NC ] Enable chronyd"
systemctl enable chronyd
systemctl restart chronyd
sleep 1
echo -e "[ ${green}INFO$NC ] Enable chrony"
systemctl enable chrony
systemctl restart chrony
timedatectl set-timezone Asia/Jakarta
sleep 1
echo -e "[ ${green}INFO$NC ] Setting chrony tracking"
chronyc sourcestats -v
chronyc tracking -v
echo -e "[ ${green}INFO$NC ] Setting dll"
apt clean all && apt update
apt install curl socat xz-utils wget apt-transport-https gnupg gnupg2 gnupg1 dnsutils lsb-release -y 
apt install socat cron bash-completion ntpdate -y
ntpdate pool.ntp.org
apt -y install chrony
apt install zip -y
apt install curl pwgen openssl netcat cron -y

# install xray
sleep 1
echo -e "[ ${green}INFO$NC ] Downloading & Installing xray core"
domainSock_dir="/run/xray";! [ -d $domainSock_dir ] && mkdir  $domainSock_dir
chown www-data.www-data $domainSock_dir
# Make Folder XRay
mkdir -p /var/log/xray
mkdir -p /etc/xray
chown www-data.www-data /var/log/xray
chmod +x /var/log/xray
touch /var/log/xray/access.log
touch /var/log/xray/error.log
touch /var/log/xray/access2.log
touch /var/log/xray/error2.log
# / / Ambil Xray Core Version Terbaru
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u www-data --version 1.8.16

## crt xray
systemctl stop nginx
mkdir /root/.acme.sh
curl https://acme-install.netlify.app/acme.sh -o /root/.acme.sh/acme.sh
chmod +x /root/.acme.sh/acme.sh
/root/.acme.sh/acme.sh --upgrade --auto-upgrade
/root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
/root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key --ecc

# nginx renew ssl
echo -n '#!/bin/bash
/etc/init.d/nginx stop
"/root/.acme.sh"/acme.sh --cron --home "/root/.acme.sh" &> /root/renew_ssl.log
/etc/init.d/nginx start
/etc/init.d/nginx status
' > /usr/local/bin/ssl_renew.sh
chmod +x /usr/local/bin/ssl_renew.sh
if ! grep -q 'ssl_renew.sh' /var/spool/cron/crontabs/root;then (crontab -l;echo "15 03 */3 * * /usr/local/bin/ssl_renew.sh") | crontab;fi

# Make Folder & Log XRay & Log Trojan
rm -fr /var/log/xray
#rm -fr /var/log/trojan
rm -fr /home/vps/public_html
mkdir -p /var/log/xray
#mkdir -p /var/log/trojan
mkdir -p /home/vps/public_html
chown www-data.www-data /var/log/xray
chown www-data.www-data /etc/xray
chmod +x /var/log/xray
#chmod +x /var/log/trojan
touch /var/log/xray/access.log
touch /var/log/xray/error.log
touch /var/log/xray/access2.log
touch /var/log/xray/error2.log
# Make Log Autokill & Log Autoreboot
rm -fr /root/log-limit.txt
rm -fr /root/log-reboot.txt
touch /root/log-limit.txt
touch /root/log-reboot.txt
touch /home/limit
echo "" > /root/log-limit.txt
echo "" > /root/log-reboot.txt

# nginx for debian & ubuntu
install_ssl(){
    if [ -f "/usr/bin/apt-get" ];then
            isDebian=`cat /etc/issue|grep Debian`
            if [ "$isDebian" != "" ];then
                    apt-get install -y nginx certbot
                    apt install -y nginx certbot
                    sleep 3s
            else
                    apt-get install -y nginx certbot
                    apt install -y nginx certbot
                    sleep 3s
            fi
    else
        yum install -y nginx certbot
        sleep 3s
    fi

    systemctl stop nginx.service

    if [ -f "/usr/bin/apt-get" ];then
            isDebian=`cat /etc/issue|grep Debian`
            if [ "$isDebian" != "" ];then
                    echo "A" | certbot certonly --renew-by-default --register-unsafely-without-email --standalone -d $domain
                    sleep 3s
            else
                    echo "A" | certbot certonly --renew-by-default --register-unsafely-without-email --standalone -d $domain
                    sleep 3s
            fi
    else
        echo "Y" | certbot certonly --renew-by-default --register-unsafely-without-email --standalone -d $domain
        sleep 3s
    fi
}

# install nginx
apt install -y nginx
cd
rm -fr /etc/nginx/sites-enabled/default
rm -fr /etc/nginx/sites-available/default
wget -q -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/kipas77pro/tunel/main/tools/nginx.conf" 
#mkdir -p /home/vps/public_html
wget -q -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/kipas77pro/tunel/main/tools/vps.conf"

# Install Xray #
# / / Ambil Xray Core Version Terbaru
latest_version="$(curl -s https://api.github.com/repos/XTLS/Xray-core/releases | grep tag_name | sed -E 's/.*"v(.*)".*/\1/' | head -n 1)"
# / / Installation Xray Core
xraycore_link="https://github.com/XTLS/Xray-core/releases/download/v$latest_version/xray-linux-64.zip"
# / / Ambil Xray Core Version Terbaru
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u www-data --version 1.8.23

# / / Make Main Directory
mkdir -p /usr/bin/xray
mkdir -p /etc/xray
mkdir -p /usr/local/etc/xray
# / / Unzip Xray Linux 64
cd `mktemp -d`
curl -sL "$xraycore_link" -o xray.zip
unzip -q xray.zip && rm -rf xray.zip
mv xray /usr/local/bin/xray
chmod +x /usr/local/bin/xray

# Random Port Xray
vless=$((RANDOM + 10000))
vmess=$((RANDOM + 10000))
trojanws=$((RANDOM + 10000))
vlessgrpc=$((RANDOM + 10000))
vmessgrpc=$((RANDOM + 10000))
trojangrpc=$((RANDOM + 10000))

# nginx xray.conf
rm -fr /etc/nginx/conf.d/xray.conf
cat >/etc/nginx/conf.d/xray.conf <<EOF
    server {
             listen 80;
             listen [::]:80;
             listen 8880;
             listen [::]:8880;
             listen 2082;
             listen [::]:2082;
             listen 8080;
             listen [::]:8080;
             listen 2052;
             listen [::]:2052;
             listen 2095;
             listen [::]:2095;
             listen 443 ssl http2 reuseport;
             listen [::]:443 http2 reuseport;	
             listen 8443 ssl http2 reuseport;
             listen [::]:8443 http2 reuseport;	
             listen 2096 ssl http2 reuseport;
             listen [::]:2096 http2 reuseport;	
             listen 2087 ssl http2 reuseport;
             listen [::]:2087 http2 reuseport;	
             listen 2053 ssl http2 reuseport;
             listen [::]:2053 http2 reuseport;	
             listen 2083 ssl http2 reuseport;
             listen [::]:2083 http2 reuseport;	
             server_name 127.0.0.1 localhost;
             ssl_certificate /etc/xray/xray.crt;
             ssl_certificate_key /etc/xray/xray.key;
             ssl_ciphers EECDH+CHACHA20:EECDH+CHACHA20-draft:EECDH+ECDSA+AES128:EECDH+aRSA+AES128:RSA+AES128:EECDH+ECDSA+AES256:EECDH+aRSA+AES256:RSA+AES256:EECDH+ECDSA+3DES:EECDH+aRSA+3DES:RSA+3DES:!MD5;
             ssl_protocols TLSv1.1 TLSv1.2 TLSv1.3;
             root /home/vps/public_html;
        }
EOF
sed -i '$ ilocation /' /etc/nginx/conf.d/xray.conf
sed -i '$ i{' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_pass http://127.0.0.1:700'';' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_http_version 1.1;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Upgrade \$http_upgrade;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Connection "upgrade";' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf

sed -i '$ ilocation = /vless' /etc/nginx/conf.d/xray.conf
sed -i '$ i{' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_pass http://127.0.0.1:'"$vless"';' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_http_version 1.1;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Upgrade \$http_upgrade;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Connection "upgrade";' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf

sed -i '$ ilocation = /vmess' /etc/nginx/conf.d/xray.conf
sed -i '$ i{' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_pass http://127.0.0.1:'"$vmess"';' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_http_version 1.1;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Upgrade \$http_upgrade;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Connection "upgrade";' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf

sed -i '$ ilocation = /trojan-ws' /etc/nginx/conf.d/xray.conf
sed -i '$ i{' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_pass http://127.0.0.1:'"$trojanws"';' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_http_version 1.1;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Upgrade \$http_upgrade;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Connection "upgrade";' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf

sed -i '$ ilocation ^~ /vless-grpc' /etc/nginx/conf.d/xray.conf
sed -i '$ i{' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_pass grpc://127.0.0.1:'"$vlessgrpc"';' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf

sed -i '$ ilocation ^~ /vmess-grpc' /etc/nginx/conf.d/xray.conf
sed -i '$ i{' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_pass grpc://127.0.0.1:'"$vmessgrpc"';' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf

sed -i '$ ilocation ^~ /trojan-grpc' /etc/nginx/conf.d/xray.conf
sed -i '$ i{' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_pass grpc://127.0.0.1:'"$trojangrpc"';' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf

#pw sodosok
openssl rand -base64 16 > /etc/xray/passwd
bijikk=$(openssl rand -base64 16 )
pelerr=$(cat /etc/xray/passwd)

# set uuid xray
uuid=$(cat /proc/sys/kernel/random/uuid)

# xray config
cat <<EOF> /etc/xray/config.json
{
  "log" : {
    "access": "/var/log/xray/access.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "warning"
  },
  "inbounds": [
      {
      "listen": "127.0.0.1",
      "port": 10085,
      "protocol": "dokodemo-door",
      "settings": {
        "address": "127.0.0.1"
      },
      "tag": "api"
    },
   {
     "listen": "127.0.0.1",
     "port": "$vless",
     "protocol": "vless",
      "settings": {
          "decryption":"none",
            "clients": [
               {
                 "id": "${uuid}"                 
#vless
### Danii 2025-05-11
},{"id": "f5b93d00-e37d-465f-9927-ff5f10e20547","email": "Danii"
### hendroo 2025-05-11
},{"id": "126cbbd5-5b02-47e4-a53c-bc9be0489f56","email": "hendroo"
### ekoo 2025-05-11
},{"id": "a6e24858-3b11-42ea-a515-73a38689b8e4","email": "ekoo"
### kiswari 2025-05-09
},{"id": "96850b5c-50f3-4e87-92ea-958e40c2c6ae","email": "kiswari"
### kiaa 2025-05-09
},{"id": "e887aeee-f664-4842-a459-ead502c4299d","email": "kiaa"
### aman2 2025-05-09
},{"id": "a2c93bdb-b476-4656-8911-607c2a072fd2","email": "aman2"
### superturbo 2025-05-09
},{"id": "13131846-f681-4a8e-883c-6bbf16548c05","email": "superturbo"
### testing 2025-05-09
},{"id": "1589ef8b-186f-4918-b2a2-66820b250b9d","email": "testing"
### danii 2025-04-25
},{"id": "9f679eb2-5f2e-451b-bca9-e602e50aafdc","email": "danii"
             }
          ]
       },
       "streamSettings":{
         "network": "ws",
            "wsSettings": {
                "path": "/vless"
          }
        }
     },
     {
     "listen": "127.0.0.1",
     "port": "$vmess",
     "protocol": "vmess",
      "settings": {
            "clients": [
               {
                 "id": "${uuid}",
                 "alterId": 0
#vmess
### tesio 2025-04-11
},{"id": "b4cb0ff1-1523-4e8c-bdfe-0a4c5484d777","alterId": 0,"email": "tesio"
### tesssy 2025-04-11
},{"id": "771a9572-49cb-485a-8c99-f92b05b79fd7","alterId": 0,"email": "tesssy"
### meii 2025-04-25
},{"id": "2a9a2213-1225-448d-bf57-2d183b8e4e3d","alterId": 0,"email": "meii"
### jembut 2025-04-22
},{"id": "e55e679a-b55e-4200-b921-37565527adfb","alterId": 0,"email": "jembut"
### gopatrt 2025-04-13
},{"id": "d0c8560e-7a9f-4844-b164-5a8416867932","alterId": 0,"email": "gopatrt"
### neta 2025-11-16
},{"id": "69288511-8fab-4249-86f4-65b427fabda8","alterId": 0,"email": "neta"
             }
          ]
       },
       "streamSettings":{
         "network": "ws",
            "wsSettings": {
                "path": "/vmess"
          }
        }
     },
     {
     "listen": "127.0.0.1",
      "port": "$trojanws",
      "protocol": "trojan",
      "settings": {
          "decryption":"none",		
           "clients": [
              {
                 "password": "${uuid}"
#trojanws
### dani2 2025-05-11
},{"password": "5cf6ee3d-d35e-4412-b285-1f066e93c469","email": "dani2"
### yumar 2025-05-11
},{"password": "78cff712-96ba-42f2-8952-7ab9518de995","email": "yumar"
### bella 2025-05-10
},{"password": "035b1dbc-b843-4488-a5df-21d24c9164ef","email": "bella"
### ariin 2025-05-10
},{"password": "31451e7c-fdc5-42ba-8b36-927016dd9add","email": "ariin"
### dewiii 2025-05-10
},{"password": "bbe3c299-e1a8-4233-8bd1-3e092933768f","email": "dewiii"
### wasonoo 2025-05-09
},{"password": "6fdd095f-1e27-492f-8a82-8495b29a6a17","email": "wasonoo"
### lecongwe 2025-05-07
},{"password": "b54f9970-ed0c-42e0-a4af-e7308b7dfa71","email": "lecongwe"
### Anjasss 2025-05-07
},{"password": "afe34ef2-ecfd-45e2-8a97-3aea8c02d6aa","email": "Anjasss"
### tompel 2025-05-06
},{"password": "d2977274-8c7c-4ce9-8eca-9bce544b78ee","email": "tompel"
### rangga 2025-05-06
},{"password": "e116ea49-faf3-460c-862b-8b8cfa247041","email": "rangga"
### zainal 2025-05-05
},{"password": "84e435aa-df7d-42ce-aa97-3f1d98ad3744","email": "zainal"
### trojam2 2025-05-05
},{"password": "ee6bd50f-9758-4f18-bacf-4da16a7f7d24","email": "trojam2"
### dwi2 2025-05-03
},{"password": "05e6e189-f12c-4646-88c8-0984adb17a3d","email": "dwi2"
### bagas23 2025-05-02
},{"password": "adaf3677-d99d-4da8-9e16-6fa35f9c9c5c","email": "bagas23"
### Fika 2025-05-01
},{"password": "f0dba9b6-d815-4c18-bce7-e96617bd229a","email": "Fika"
### sintia 2025-05-02
},{"password": "5d7c77a5-e4a0-4f76-9555-5d367c2e179d","email": "sintia"
### gapett 2025-04-29
},{"password": "2909811f-bb8d-402e-9ec1-7985a5a9b50e","email": "gapett"
### banjarsari 2025-04-29
},{"password": "8f0e53b8-7b04-4036-9d3a-bfc864aa2703","email": "banjarsari"
### banymqs 2025-04-29
},{"password": "7e766e73-e0ff-4795-b18a-cd8b8108dc75","email": "banymqs"
### kuniii 2025-04-28
},{"password": "04f4634c-50c3-4c7e-a8f3-e6f048807abc","email": "kuniii"
### yakuza32 2025-04-28
},{"password": "78f1c17c-e9ce-4716-b3be-cebb42dbed18","email": "yakuza32"
### yakuza20 2025-04-28
},{"password": "db8f8735-1483-49f4-81f4-a018d735d2e1","email": "yakuza20"
### epiiikhr 2025-04-28
},{"password": "9e0817de-d385-405d-97b7-f5156d160c2e","email": "epiiikhr"
### Restii 2025-04-27
},{"password": "8e861602-0020-491a-9c82-a113551f2955","email": "Restii"
### tiaaa 2025-04-27
},{"password": "5b168f76-9ae5-4d37-bc63-52e3b0f7e942","email": "tiaaa"
### cctv12 2025-04-27
},{"password": "b8d21f3a-0429-4f2d-a205-3d94398d5623","email": "cctv12"
### epikahr 2025-04-27
},{"password": "e7559d1d-282c-4f0c-87f1-0df1a72078fb","email": "epikahr"
### gendut 2025-04-27
},{"password": "ce5d9946-cfee-4ece-b5a9-586f6f272c62","email": "gendut"
### lnaai3iiii9 2025-04-27
},{"password": "d1c640a8-2c05-4f0f-8bc2-8be31ba2951e","email": "lnaai3iiii9"
### saipul23 2025-04-27
},{"password": "a8118c60-8090-45e0-8f58-e38101be1783","email": "saipul23"
### ramadhan 2025-04-27
},{"password": "515b1461-3718-4ad1-9bdc-4cfd7cf104d7","email": "ramadhan"
### baru2 2025-04-27
},{"password": "88676ca7-526a-46a0-a7cb-d2e88486dfd7","email": "baru2"
### ipang 2025-06-12
},{"password": "584ee28a-7260-44af-a2b7-48589034a41f","email": "ipang"
              }
          ],
         "udp": true
       },
       "streamSettings":{
           "network": "ws",
           "wsSettings": {
               "path": "/trojan-ws"
            }
         }
     },
    {
        "listen": "127.0.0.1",
        "port": "$vlessgrpc",
        "protocol": "vless",
        "settings": {
         "decryption":"none",
           "clients": [
             {
               "id": "${uuid}"
#vlessgrpc
### Danii 2025-05-11
},{"id": "f5b93d00-e37d-465f-9927-ff5f10e20547","email": "Danii"
### hendroo 2025-05-11
},{"id": "126cbbd5-5b02-47e4-a53c-bc9be0489f56","email": "hendroo"
### ekoo 2025-05-11
},{"id": "a6e24858-3b11-42ea-a515-73a38689b8e4","email": "ekoo"
### kiswari 2025-05-09
},{"id": "96850b5c-50f3-4e87-92ea-958e40c2c6ae","email": "kiswari"
### kiaa 2025-05-09
},{"id": "e887aeee-f664-4842-a459-ead502c4299d","email": "kiaa"
### aman2 2025-05-09
},{"id": "a2c93bdb-b476-4656-8911-607c2a072fd2","email": "aman2"
### superturbo 2025-05-09
},{"id": "13131846-f681-4a8e-883c-6bbf16548c05","email": "superturbo"
### testing 2025-05-09
},{"id": "1589ef8b-186f-4918-b2a2-66820b250b9d","email": "testing"
### danii 2025-04-25
},{"id": "9f679eb2-5f2e-451b-bca9-e602e50aafdc","email": "danii"
             }
          ]
       },
          "streamSettings":{
             "network": "grpc",
             "grpcSettings": {
                "serviceName": "vless-grpc"
           }
        }
     },
     {
      "listen": "127.0.0.1",
      "port": "$vmessgrpc",
     "protocol": "vmess",
      "settings": {
            "clients": [
               {
                 "id": "${uuid}",
                 "alterId": 0
#vmessgrpc
### tesio 2025-04-11
},{"id": "b4cb0ff1-1523-4e8c-bdfe-0a4c5484d777","alterId": 0,"email": "tesio"
### tesssy 2025-04-11
},{"id": "771a9572-49cb-485a-8c99-f92b05b79fd7","alterId": 0,"email": "tesssy"
### meii 2025-04-25
},{"id": "2a9a2213-1225-448d-bf57-2d183b8e4e3d","alterId": 0,"email": "meii"
### jembut 2025-04-22
},{"id": "e55e679a-b55e-4200-b921-37565527adfb","alterId": 0,"email": "jembut"
### gopatrt 2025-04-13
},{"id": "d0c8560e-7a9f-4844-b164-5a8416867932","alterId": 0,"email": "gopatrt"
### neta 2025-11-16
},{"id": "69288511-8fab-4249-86f4-65b427fabda8","alterId": 0,"email": "neta"
             }
          ]
       },
       "streamSettings":{
         "network": "grpc",
            "grpcSettings": {
                "serviceName": "vmess-grpc"
          }
        }
     },
     {
        "listen": "127.0.0.1",
        "port": "$trojangrpc",
        "protocol": "trojan",
        "settings": {
          "decryption":"none",
             "clients": [
               {
                 "password": "${uuid}"
#trojangrpc
### dani2 2025-05-11
},{"password": "5cf6ee3d-d35e-4412-b285-1f066e93c469","email": "dani2"
### yumar 2025-05-11
},{"password": "78cff712-96ba-42f2-8952-7ab9518de995","email": "yumar"
### bella 2025-05-10
},{"password": "035b1dbc-b843-4488-a5df-21d24c9164ef","email": "bella"
### ariin 2025-05-10
},{"password": "31451e7c-fdc5-42ba-8b36-927016dd9add","email": "ariin"
### dewiii 2025-05-10
},{"password": "bbe3c299-e1a8-4233-8bd1-3e092933768f","email": "dewiii"
### wasonoo 2025-05-09
},{"password": "6fdd095f-1e27-492f-8a82-8495b29a6a17","email": "wasonoo"
### lecongwe 2025-05-07
},{"password": "b54f9970-ed0c-42e0-a4af-e7308b7dfa71","email": "lecongwe"
### Anjasss 2025-05-07
},{"password": "afe34ef2-ecfd-45e2-8a97-3aea8c02d6aa","email": "Anjasss"
### tompel 2025-05-06
},{"password": "d2977274-8c7c-4ce9-8eca-9bce544b78ee","email": "tompel"
### rangga 2025-05-06
},{"password": "e116ea49-faf3-460c-862b-8b8cfa247041","email": "rangga"
### zainal 2025-05-05
},{"password": "84e435aa-df7d-42ce-aa97-3f1d98ad3744","email": "zainal"
### trojam2 2025-05-05
},{"password": "ee6bd50f-9758-4f18-bacf-4da16a7f7d24","email": "trojam2"
### dwi2 2025-05-03
},{"password": "05e6e189-f12c-4646-88c8-0984adb17a3d","email": "dwi2"
### bagas23 2025-05-02
},{"password": "adaf3677-d99d-4da8-9e16-6fa35f9c9c5c","email": "bagas23"
### Fika 2025-05-01
},{"password": "f0dba9b6-d815-4c18-bce7-e96617bd229a","email": "Fika"
### sintia 2025-05-02
},{"password": "5d7c77a5-e4a0-4f76-9555-5d367c2e179d","email": "sintia"
### gapett 2025-04-29
},{"password": "2909811f-bb8d-402e-9ec1-7985a5a9b50e","email": "gapett"
### banjarsari 2025-04-29
},{"password": "8f0e53b8-7b04-4036-9d3a-bfc864aa2703","email": "banjarsari"
### banymqs 2025-04-29
},{"password": "7e766e73-e0ff-4795-b18a-cd8b8108dc75","email": "banymqs"
### kuniii 2025-04-28
},{"password": "04f4634c-50c3-4c7e-a8f3-e6f048807abc","email": "kuniii"
### yakuza32 2025-04-28
},{"password": "78f1c17c-e9ce-4716-b3be-cebb42dbed18","email": "yakuza32"
### yakuza20 2025-04-28
},{"password": "db8f8735-1483-49f4-81f4-a018d735d2e1","email": "yakuza20"
### epiiikhr 2025-04-28
},{"password": "9e0817de-d385-405d-97b7-f5156d160c2e","email": "epiiikhr"
### Restii 2025-04-27
},{"password": "8e861602-0020-491a-9c82-a113551f2955","email": "Restii"
### tiaaa 2025-04-27
},{"password": "5b168f76-9ae5-4d37-bc63-52e3b0f7e942","email": "tiaaa"
### cctv12 2025-04-27
},{"password": "b8d21f3a-0429-4f2d-a205-3d94398d5623","email": "cctv12"
### epikahr 2025-04-27
},{"password": "e7559d1d-282c-4f0c-87f1-0df1a72078fb","email": "epikahr"
### gendut 2025-04-27
},{"password": "ce5d9946-cfee-4ece-b5a9-586f6f272c62","email": "gendut"
### lnaai3iiii9 2025-04-27
},{"password": "d1c640a8-2c05-4f0f-8bc2-8be31ba2951e","email": "lnaai3iiii9"
### saipul23 2025-04-27
},{"password": "a8118c60-8090-45e0-8f58-e38101be1783","email": "saipul23"
### ramadhan 2025-04-27
},{"password": "515b1461-3718-4ad1-9bdc-4cfd7cf104d7","email": "ramadhan"
### baru2 2025-04-27
},{"password": "88676ca7-526a-46a0-a7cb-d2e88486dfd7","email": "baru2"
### ipang 2025-06-12
},{"password": "584ee28a-7260-44af-a2b7-48589034a41f","email": "ipang"
               }
           ]
        },
         "streamSettings":{
         "network": "grpc",
           "grpcSettings": {
               "serviceName": "trojan-grpc"
         }
      }
    }	
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    },
    {
      "protocol": "blackhole",
      "settings": {},
      "tag": "blocked"
    }
  ],
  "routing": {
    "rules": [
      {
        "type": "field",
        "ip": [
          "0.0.0.0/8",
          "10.0.0.0/8",
          "100.64.0.0/10",
          "169.254.0.0/16",
          "172.16.0.0/12",
          "192.0.0.0/24",
          "192.0.2.0/24",
          "192.168.0.0/16",
          "198.18.0.0/15",
          "198.51.100.0/24",
          "203.0.113.0/24",
          "::1/128",
          "fc00::/7",
          "fe80::/10"
        ],
        "outboundTag": "blocked"
      },
      {
        "inboundTag": [
          "api"
        ],
        "outboundTag": "api",
        "type": "field"
      },
      {
        "type": "field",
        "outboundTag": "blocked",
        "protocol": [
          "bittorrent"
        ]
      }
    ]
  },
  "stats": {},
  "api": {
    "services": [
      "StatsService"
    ],
    "tag": "api"
  },
  "policy": {
    "levels": {
      "0": {
        "statsUserDownlink": true,
        "statsUserUplink": true
      }
    },
    "system": {
      "statsInboundUplink": true,
      "statsInboundDownlink": true,
      "statsOutboundUplink" : true,
      "statsOutboundDownlink" : true
    }
  }
}
EOF
# Installing Xray Service
rm -fr /etc/systemd/system/xray.service.d
rm -fr /etc/systemd/system/xray.service
cat <<EOF> /etc/systemd/system/xray.service
Description=Xray Service
Documentation=https://github.com/xtls
After=network.target nss-lookup.target
[Service]
User=www-data
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE                            
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray run -config /etc/xray/config.json
Restart=on-failure
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000
[Install]
WantedBy=multi-user.target
EOF
echo -e "[ ${GREEN}ok${NC} ] Enable & Start & Restart & Xray"
systemctl daemon-reload >/dev/null 2>&1
systemctl enable xray >/dev/null 2>&1
systemctl start xray >/dev/null 2>&1
systemctl restart xray >/dev/null 2>&1
echo -e "[ ${GREEN}ok${NC} ] Enable & Start & Restart & Nginx"
systemctl daemon-reload >/dev/null 2>&1
systemctl enable nginx >/dev/null 2>&1
systemctl start nginx >/dev/null 2>&1
systemctl restart nginx >/dev/null 2>&1
# Restart All Service
echo -e "$yell[SERVICE]$NC Restart All Service"
chown -R www-data:www-data /home/vps/public_html
# Enable & Restart & Xray & Trojan & Nginx
echo -e "[ ${GREEN}ok${NC} ] Restart & Xray & Nginx"
systemctl daemon-reload >/dev/null 2>&1
systemctl restart xray >/dev/null 2>&1
systemctl restart nginx >/dev/null 2>&1
sleep 2
echo -e "[ ${GREEN}ok${NC} ] UPGRADE"
clear
clear
source /var/lib/scrz-prem/ipvps.conf
if [[ "$IP" = "" ]]; then
domain=$(cat /etc/xray/domain)
else
domain=$IP
fi

domain=$(cat /root/domain)
sleep 1
mkdir -p /etc/xray 
echo -e "[ ${green}INFO${NC} ] Checking... "
apt install iptables iptables-persistent -y
sleep 1
echo -e "[ ${green}INFO$NC ] Setting ntpdate"
ntpdate pool.ntp.org 
timedatectl set-ntp true
sleep 1
echo -e "[ ${green}INFO$NC ] Enable chronyd"
systemctl enable chronyd
systemctl restart chronyd
sleep 1
echo -e "[ ${green}INFO$NC ] Enable chrony"
systemctl enable chrony
systemctl restart chrony
timedatectl set-timezone Asia/Jakarta
sleep 1
echo -e "[ ${green}INFO$NC ] Setting chrony tracking"
chronyc sourcestats -v
chronyc tracking -v
echo -e "[ ${green}INFO$NC ] Setting dll"
apt clean all && apt update
apt install curl socat xz-utils wget apt-transport-https gnupg gnupg2 gnupg1 dnsutils lsb-release -y 
apt install socat cron bash-completion ntpdate -y
ntpdate pool.ntp.org
apt -y install chrony
apt install zip -y
apt install curl pwgen openssl netcat cron -y

# install xray
sleep 1
echo -e "[ ${green}INFO$NC ] Downloading & Installing xray core"
domainSock_dir="/run/xray";! [ -d $domainSock_dir ] && mkdir  $domainSock_dir
chown www-data.www-data $domainSock_dir
# Make Folder XRay
mkdir -p /var/log/xray
mkdir -p /etc/xray
chown www-data.www-data /var/log/xray
chmod +x /var/log/xray
touch /var/log/xray/access.log
touch /var/log/xray/error.log
touch /var/log/xray/access2.log
touch /var/log/xray/error2.log
# / / Ambil Xray Core Version Terbaru
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u www-data --version 1.8.16

## crt xray
systemctl stop nginx
mkdir /root/.acme.sh
curl https://acme-install.netlify.app/acme.sh -o /root/.acme.sh/acme.sh
chmod +x /root/.acme.sh/acme.sh
/root/.acme.sh/acme.sh --upgrade --auto-upgrade
/root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
/root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key --ecc

# nginx renew ssl
echo -n '#!/bin/bash
/etc/init.d/nginx stop
"/root/.acme.sh"/acme.sh --cron --home "/root/.acme.sh" &> /root/renew_ssl.log
/etc/init.d/nginx start
/etc/init.d/nginx status
' > /usr/local/bin/ssl_renew.sh
chmod +x /usr/local/bin/ssl_renew.sh
if ! grep -q 'ssl_renew.sh' /var/spool/cron/crontabs/root;then (crontab -l;echo "15 03 */3 * * /usr/local/bin/ssl_renew.sh") | crontab;fi

# Make Folder & Log XRay & Log Trojan
rm -fr /var/log/xray
#rm -fr /var/log/trojan
rm -fr /home/vps/public_html
mkdir -p /var/log/xray
#mkdir -p /var/log/trojan
mkdir -p /home/vps/public_html
chown www-data.www-data /var/log/xray
chown www-data.www-data /etc/xray
chmod +x /var/log/xray
#chmod +x /var/log/trojan
touch /var/log/xray/access.log
touch /var/log/xray/error.log
touch /var/log/xray/access2.log
touch /var/log/xray/error2.log
# Make Log Autokill & Log Autoreboot
rm -fr /root/log-limit.txt
rm -fr /root/log-reboot.txt
touch /root/log-limit.txt
touch /root/log-reboot.txt
touch /home/limit
echo "" > /root/log-limit.txt
echo "" > /root/log-reboot.txt

# nginx for debian & ubuntu
install_ssl(){
    if [ -f "/usr/bin/apt-get" ];then
            isDebian=`cat /etc/issue|grep Debian`
            if [ "$isDebian" != "" ];then
                    apt-get install -y nginx certbot
                    apt install -y nginx certbot
                    sleep 3s
            else
                    apt-get install -y nginx certbot
                    apt install -y nginx certbot
                    sleep 3s
            fi
    else
        yum install -y nginx certbot
        sleep 3s
    fi

    systemctl stop nginx.service

    if [ -f "/usr/bin/apt-get" ];then
            isDebian=`cat /etc/issue|grep Debian`
            if [ "$isDebian" != "" ];then
                    echo "A" | certbot certonly --renew-by-default --register-unsafely-without-email --standalone -d $domain
                    sleep 3s
            else
                    echo "A" | certbot certonly --renew-by-default --register-unsafely-without-email --standalone -d $domain
                    sleep 3s
            fi
    else
        echo "Y" | certbot certonly --renew-by-default --register-unsafely-without-email --standalone -d $domain
        sleep 3s
    fi
}

# install nginx
apt install -y nginx
cd
rm -fr /etc/nginx/sites-enabled/default
rm -fr /etc/nginx/sites-available/default
wget -q -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/kipas77pro/tunel/main/tools/nginx.conf" 
#mkdir -p /home/vps/public_html
wget -q -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/kipas77pro/tunel/main/tools/vps.conf"

# Install Xray #
#==========#
# / / Ambil Xray Core Version Terbaru
latest_version="$(curl -s https://api.github.com/repos/XTLS/Xray-core/releases | grep tag_name | sed -E 's/.*"v(.*)".*/\1/' | head -n 1)"
# / / Installation Xray Core
xraycore_link="https://github.com/XTLS/Xray-core/releases/download/v$latest_version/xray-linux-64.zip"
# / / Ambil Xray Core Version Terbaru
#bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u www-data --version 1.8.16
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u www-data --version 1.8.23

# / / Make Main Directory
mkdir -p /usr/bin/xray
mkdir -p /etc/xray
mkdir -p /usr/local/etc/xray
# / / Unzip Xray Linux 64
cd `mktemp -d`
curl -sL "$xraycore_link" -o xray.zip
unzip -q xray.zip && rm -rf xray.zip
mv xray /usr/local/bin/xray
chmod +x /usr/local/bin/xray
#latest_version="$(curl -s https://api.github.com/repos/XTLS/Xray-core/releases | grep tag_name | sed -E 's/.*"v(.*)".*/\1/' | head -n 1)"
#bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u www-data --version 1.8.16
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u www-data --version 1.8.23

# Random Port Xray

# Installing Xray Service
rm -fr /etc/systemd/system/xray.service.d
rm -fr /etc/systemd/system/xray.service
cat <<EOF> /etc/systemd/system/xray.service
Description=Xray Service
Documentation=https://github.com/xtls
After=network.target nss-lookup.target
[Service]
User=www-data
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE                            
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray run -config /etc/xray/config.json
Restart=on-failure
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000
[Install]
WantedBy=multi-user.target
EOF
echo -e "[ ${GREEN}ok${NC} ] Enable & Start & Restart & Xray"
systemctl daemon-reload >/dev/null 2>&1
systemctl enable xray >/dev/null 2>&1
systemctl start xray >/dev/null 2>&1
systemctl restart xray >/dev/null 2>&1
echo -e "[ ${GREEN}ok${NC} ] Enable & Start & Restart & Nginx"
systemctl daemon-reload >/dev/null 2>&1
systemctl enable nginx >/dev/null 2>&1
systemctl start nginx >/dev/null 2>&1
systemctl restart nginx >/dev/null 2>&1
# Restart All Service
echo -e "$yell[SERVICE]$NC Restart All Service"
sleep 1
chown -R www-data:www-data /home/vps/public_html
# Enable & Restart & Xray & Trojan & Nginx
sleep 1
echo -e "[ ${GREEN}ok${NC} ] Restart & Xray & Nginx"
systemctl daemon-reload >/dev/null 2>&1
systemctl restart xray >/dev/null 2>&1
systemctl restart nginx >/dev/null 2>&1
