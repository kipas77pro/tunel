#!/bin/bash

# ULOAD BY ARYA BLITAR WA 081931615811
# YG DENCRIPT JANGAN DI PERJUAL BELIKAN YA PAK !!

if [ "${EUID}" -ne 0 ]; then
echo -e "${EROR} Please Run This Script As Root User !"
exit 1
fi
clear
export LANG='en_US.UTF-8'
export LANGUAGE='en_US.UTF-8'
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export BLUE='\033[0;34m'
export PURPLE='\033[0;35m'
export CYAN='\033[0;36m'
export LIGHT='\033[0;37m'
export NC='\033[0m'
BIRed='\033[1;91m'
red='\e[1;31m'
bo='\e[1m'
red='\e[1;31m'
green='\e[0;32m'
yell='\e[1;33m'
tyblue='\e[1;36m'
GRAY='\e[1;34m'
purple() { echo -e "\\033[35;1m${*}\\033[0m"; }
tyblue() { echo -e "\\033[36;1m${*}\\033[0m"; }
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }
export EROR="[${RED} ERROR ${NC}]"
export INFO="[${YELLOW} INFO ${NC}]"
export OKEY="[${GREEN} OKEY ${NC}]"
export PENDING="[${YELLOW} PENDING ${NC}]"
export SEND="[${YELLOW} SEND ${NC}]"
export RECEIVE="[${YELLOW} RECEIVE ${NC}]"
export BOLD="\e[1m"
export WARNING="${RED}\e[5m"
export UNDERLINE="\e[4m"
clear

echo -e " <<<<< UPLOAD ARYA BLITAR >>>>>>"
echo -e "\033[0;37m Script Ini Version LifeTime "
echo -e " Tuk Infonya Silahkan Hubungi Admin"
echo -e " Version MultiPort Edision Stable "
echo -e " Sc All Os Mase... !!"
echo -e "\033[0;36m By Arya Blitar 081931615811 "
echo -e "\033[0;32m"
kunci="KANGEN521";
read -s -p "Masukkan Password : " pass
if [ $pass == $kunci ]
then cat login.sh
clear
else
echo -e "\033[0;31m Password Salah Sayank...!!"
echo -e "\033[0;32m Segera Hub. Admin 081931615811 "
exit
fi
echo -e "\033[0;32m SELAMAT ANDA BERHASIL MASUK & INSTALL"
sleep 3
clear
clear
# // Exporint IP AddressInformation
export IP=$( curl -sS icanhazip.com )

# // Clear Data
clear
clear && clear && clear
clear;clear;clear

# // Banner
echo -e "${YELLOW}----------------------------------------------------------${NC}"
echo -e " Dev > Script ${YELLOW}(${NC}${green} Stable Edition 2025 ${NC}${YELLOW})${NC}"
echo -e " Version All Os Multiport "
echo -e " Auther : ${green}Arya Blitar ${NC}"
echo -e " © Udanawu Blitar Jatim ${YELLOW}(${NC}2025 ${YELLOW})${NC}"
echo -e "${YELLOW}----------------------------------------------------------${NC}"
echo ""
sleep 2 

# // Checking Os Architecture
if [[ $( uname -m | awk '{print $1}' ) == "x86_64" ]]; then
    echo -e "${OK} Arsitektur Anda Didukung ( ${green}$( uname -m )${NC} )"
else
    echo -e "${EROR} Arsitektur Anda Tidak Didukung ( ${YELLOW}$( uname -m )${NC} )"
    exit 1
fi

# // Checking System
if [[ $( cat /etc/os-release | grep -w ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/ID//g' ) == "ubuntu" ]]; then
    echo -e "${OK} OS Anda Didukung ( ${green}$( cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g' )${NC} )"
elif [[ $( cat /etc/os-release | grep -w ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/ID//g' ) == "debian" ]]; then
    echo -e "${OK} OS Anda Didukung ( ${green}$( cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g' )${NC} )"
else
    echo -e "${EROR} OS Anda Tidak Didukung ( ${YELLOW}$( cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g' )${NC} )"
    exit 1
fi

# // IP Address Validating
if [[ $IP == "" ]]; then
    echo -e "${EROR} IP Address ( ${YELLOW}Not Detected${NC} )"
else
    echo -e "${OK} IP Address ( ${green}$IP${NC} )"
fi

# // Validate Successfull
echo ""
read -p "$( echo -e "Press ${GRAY}[ ${NC}${green}Enter${NC} ${GRAY}]${NC} Untuk Memulai Instalasi") "
echo ""
clear
if [ "${EUID}" -ne 0 ]; then
		echo "Anda perlu menjalankan skrip ini sebagai root"
		exit 1
fi
if [ "$(systemd-detect-virt)" == "openvz" ]; then
		echo "OpenVZ tidak didukung"
		exit 1
fi

TIMES="10"
CHATID="6430177985"
KEY="7567594287:AAGVeDwRq9QrNg6jSce30eOm9WiVtAWKxjA"
URL="https://api.telegram.org/bot$KEY/sendMessage"
    TIMEZONE=$(printf '%(%H:%M:%S)T')
    TEXT="
<code>────────────────────</code>
<b> AUTOSCRIPT PREMIUM </b>
<code>────────────────────</code>
<code>Domain   :</code><code>$domain</code>
<code>IPVPS    :</code><code>$MYIP</code>
<code>Time     :</code><code>$TIMEZONE</code>
<code>────────────────────</code>
<b> SCRIPT ALL OS ARYA BLITAR 2025 </b>
<code>────────────────────</code>
<i>Automatic Notifications From Github</i>
"'&reply_markup={"inline_keyboard":[[{"text":"ᴏʀᴅᴇʀ","url":"https://wa.me/+6281931615811"}]]}' 

    curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
}
clear
if [[ "$IP" = "" ]]; then
domain=$(cat /etc/xray/domain)
else
domain=$IP
fi

localip=$(hostname -I | cut -d\  -f1)
hst=( `hostname` )
dart=$(cat /etc/hosts | grep -w `hostname` | awk '{print $2}')
if [[ "$hst" != "$dart" ]]; then
echo "$localip $(hostname)" >> /etc/hosts
fi
mkdir -p /etc/xray
echo -e "${green} Welcome To Script Blitar Jatim......${NC} "
sleep 2
echo -e "[ ${green}INFO${NC} ] Mempersiapkan file instalasi"
apt install git curl -y >/dev/null 2>&1
echo -e "[ ${green}INFO${NC} ] file instalasi sudah siap"

sleep 3
if [[ -r /etc/xray/domain ]]; then
clear
echo -e "${INFO} Memiliki Skrip Terdeteksi !"
echo -e "${INFO} Jika Anda Mengganti Script, Semua Data Klien Di VPS Ini Akan Dibersihkan !"
read -p "Apakah Anda Yakin Ingin Mengganti Skrip? (Y/N) " josdong
if [[ $josdong == "Y" ]]; then
clear
echo -e "${INFO} Memulai Mengganti Skrip !"
elif [[ $josdong == "y" ]]; then
clear
echo -e "${INFO} Memulai Mengganti Skrip !"
rm -rf /var/lib/aryapro
elif [[ $josdong == "N" ]]; then
echo -e "${INFO} Tindakan Dibatalkan !"
exit 1
elif [[ $josdong == "n" ]]; then
echo -e "${INFO} Tindakan Dibatalkan !"
exit 1
else
echo -e "${EROR} Masukan Anda Salah !"
exit 1
fi
clear
fi
echo -e "${GREEN} Mulai Install...........${NC}"
sleep 2
systemctl disable --now apparmor >/dev/null 2>&1
systemctl stop apparmor >/dev/null 2>&1
update-rc.d -f apparmor remove >/dev/null 2>&1
apt-get purge apparmor apparmor-utils -y >/dev/null 2>&1

clear
sleep 2
start=$(date +%s)
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

apt update -y && apt upgrade -y
apt install git curl python3 apt  figlet python3-pip apt-transport-https ca-certificates software-properties-common ntpdate wget netcat-openbsd ncurses-bin chrony jq -y
-y
wget https://github.com/fullstorydev/grpcurl/releases/download/v1.9.1/grpcurl_1.9.1_linux_x86_64.tar.gz -O /tmp/grpcurl.tar.gz && tar -xzf /tmp/grpcurl.tar.gz -C /tmp/ && sudo mv /tmp/grpcurl /usr/local/bin/ && sudo chmod +x /usr/local/bin/grpcurl
wget https://raw.githubusercontent.com/XTLS/Xray-core/main/app/stats/command/command.proto -O stats.proto

clear
clear && clear && clear
clear;clear;clear
echo -e "${YELLOW}-----------------------------------------------------${NC}"
echo -e "PILIH 1 TUK LANJUT ISI DOMAIN ANDA ?"
echo -e "${YELLOW}-----------------------------------------------------${NC}"
echo ""
read -p "$( echo -e "${GREEN}Input Your Choose ? ${NC}(${YELLOW}1/2${NC})${NC} " )" choose_domain
if [[ $choose_domain == "2" ]]; then # // Using Automatic Domain
sleep 2
elif [[ $choose_domain == "1" ]]; then
clear
clear && clear && clear
clear;clear;clear
echo -e "${GREEN}Indonesian Language${NC}"
echo -e "${YELLOW}-----------------------------------------------------${NC}"
echo -e "Silakan Pointing Domain Anda Ke IP VPS"
echo -e "Untuk Caranya Arahkan NS Domain Ke Cloudflare"
echo -e "Kemudian Tambahkan A Record Dengan IP VPS"
echo -e "${YELLOW}-----------------------------------------------------${NC}"
echo ""
echo ""
read -p "Input Your Domain : " domain
if [[ $domain == "" ]]; then
clear
echo -e "${EROR} No Input Detected !"
exit 1
fi
mkdir -p /usr/bin
rm -fr /usr/local/bin/xray
rm -fr /etc/nginx
rm -fr /usr/local/bin/stunnel
rm -fr /usr/local/bin/stunnel4
rm -fr /var/lib/aryapro/
rm -fr /usr/bin/xray
rm -fr /etc/xray
rm -fr /usr/local/etc/xray
mkdir -p /etc/nginx
mkdir -p /var/lib/aryapro/
mkdir -p /usr/bin/xray
mkdir -p /etc/xray
mkdir -p /usr/local/etc/xray
echo "$domain" > /etc/${Auther}/domain.txt
echo "IP=$domain" > /var/lib/aryapro/ipvps.conf
echo "$domain" > /root/domain
domain=$(cat /root/domain)
cp -r /root/domain /etc/xray/domain
clear
else
echo -e "${EROR} Silakan Pilih 1 Saja !"
exit 1
fi
echo -e "┌─────────────────────────────────────────┐"
echo -e " \E[42;1;37m          >>> Install Tools <<<        \E[0m$NC"
echo -e "└─────────────────────────────────────────┘"
sleep 1
wget -q https://raw.githubusercontent.com/Arya-Blitar22/header/main/anjing/tools.sh && chmod +x tools.sh && ./tools.sh
clear
echo -e "┌─────────────────────────────────────────┐"
echo -e " \E[42;1;37m            >>> Install  WSOKET <<<         \E[0m$NC"
echo -e "└─────────────────────────────────────────┘"
wget -q https://raw.githubusercontent.com/Arya-Blitar22/bangunan/main/semen/install-ws.sh && chmod +x install-ws.sh && ./install-ws.sh
clear
sleep 1
cho -e "┌─────────────────────────────────────────┐"
echo -e " \E[42;1;37m            >>> Install  SSH-VPN <<<         \E[0m$NC"
echo -e "└─────────────────────────────────────────┘"
wget -q https://raw.githubusercontent.com/Arya-Blitar22/luwak/main/kirek/ssh-vpn.sh && chmod +x ssh-vpn.sh && ./ssh-vpn.sh
sudo systemctl enable --now chrony.service >/dev/null 2>&1
sudo systemctl restart chrony.service >/dev/null 2>&1
echo -e "┌─────────────────────────────────────────┐"
echo -e " \E[42;1;37m           >>> Install XRAY <<<           \E[0m$NC"
echo -e "└─────────────────────────────────────────┘"
wget -q https://raw.githubusercontent.com/Arya-Blitar22/obat/main/panu/ins-xray.sh && chmod +x ins-xray.sh && ./ins-xray.sh
sleep 1
echo -e "┌─────────────────────────────────────────┐"
echo -e " \E[42;1;37m           >>> Install UDP <<<           \E[0m$NC"
echo -e "└─────────────────────────────────────────┘"
sleep 1
wget -q https://raw.githubusercontent.com/Arya-Blitar22/obat/main/asu/udepe && chmod +x udepe && ./udepe
echo -e "┌─────────────────────────────────────────┐"
echo -e " \E[42;1;37m           >>> Install Backup <<<           \E[0m$NC"
echo -e "└─────────────────────────────────────────┘"
sleep 1
wget -q https://raw.githubusercontent.com/Arya-Blitar22/obat/main/sate/set-br.sh && chmod +x set-br.sh && ./set-br.sh
sleep 1
echo -e "${green} Mengkonfigurasi Dropbear...${NC}"
sleep 2
sudo sed -i '/^DROPBEAR_PORT=/d' /etc/default/dropbear
sudo sed -i '/^DROPBEAR_EXTRA_ARGS=/d' /etc/default/dropbear
echo 'DROPBEAR_PORT=149' | sudo tee -a /etc/default/dropbear
echo 'DROPBEAR_EXTRA_ARGS="-p 50000 -p 109 -p 110 -p 69 -b /etc/issue.net"' | sudo tee -a /etc/default/dropbear
sudo mkdir -p /etc/dropbear/
sudo dropbearkey -t dss -f /etc/dropbear/dropbear_dss_host_key
sudo dropbearkey -t rsa -f /etc/dropbear/dropbear_rsa_host_key
sudo chmod 600 /etc/dropbear/dropbear_dss_host_key
sudo chmod 600 /etc/dropbear/dropbear_rsa_host_key
sudo chown root:root /etc/dropbear/dropbear_dss_host_key
sudo chown root:root /etc/dropbear/dropbear_rsa_host_key
sudo systemctl daemon-reload >/dev/null 2>&1
sudo systemctl restart dropbear >/dev/null 2>&1
sudo systemctl enable nginx >/dev/null 2>&1

echo -e "${GREEN}Download Data Menu${NC}"

wget -q -O /usr/bin/menu-vless "https://raw.githubusercontent.com/Arya-Blitar22/bokep/main/dora/menu-vless.sh"
wget -q -O /usr/bin/menu-vmess "https://raw.githubusercontent.com/Arya-Blitar22/bokep/main/dora/menu-vmess.sh"
wget -q -O /usr/bin/menu-trojan "https://raw.githubusercontent.com/Arya-Blitar22/bokep/main/dora/menu-trojan.sh"
wget -q -O /usr/bin/menu-ssh "https://raw.githubusercontent.com/Arya-Blitar22/bokep/main/dora/menu-ssh.sh"
wget -q -O /usr/bin/menu "https://raw.githubusercontent.com/Arya-Blitar22/bokep/main/dora/menu.sh"
wget -q -O /usr/bin/menu-set "https://raw.githubusercontent.com/Arya-Blitar22/bokep/main/dora/menu-set.sh"
wget -q -O /usr/bin/babi "https://raw.githubusercontent.com/Arya-Blitar22/bokep/main/dora/babi.sh"
wget -q -O /usr/bin/info "https://raw.githubusercontent.com/Arya-Blitar22/bokep/main/dora/info.sh"
wget -q -O /usr/bin/add-tr "https://raw.githubusercontent.com/Arya-Blitar22/bokep/main/dora/add-tr.sh"
wget -q -O /usr/bin/add-vless "https://raw.githubusercontent.com/Arya-Blitar22/bokep/main/dora/add-vless.sh"
wget -q -O /usr/bin/add-ws "https://raw.githubusercontent.com/Arya-Blitar22/bokep/main/dora/add-ws.sh"
wget -q -O /usr/bin/trialssh "https://raw.githubusercontent.com/Arya-Blitar22/bokep/main/dora/trialssh.sh"
wget -q -O /usr/bin/trialtrojan "https://raw.githubusercontent.com/Arya-Blitar22/bokep/main/dora/trialtrojan.sh"
wget -q -O /usr/bin/trialvless "https://raw.githubusercontent.com/Arya-Blitar22/bokep/main/dora/trialvless.sh"
wget -q -O /usr/bin/trialvmess "https://raw.githubusercontent.com/Arya-Blitar22/bokep/main/dora/trialvmess.sh"
wget -q -O /usr/bin/usernew "https://raw.githubusercontent.com/Arya-Blitar22/bokep/main/dora/usernew.sh"
wget -q -O /usr/bin/addhost "https://raw.githubusercontent.com/Arya-Blitar22/bokep/main/dora/addhost.sh"
wget -q -O /usr/bin/autoreboot "https://raw.githubusercontent.com/Arya-Blitar22/bokep/main/dora/autoreboot.sh"
wget -q -O /usr/bin/cek-bandwidth "https://raw.githubusercontent.com/Arya-Blitar22/bokep/main/dora/cek-bandwidth.sh"
wget -q -O /usr/bin/cek-tr "https://raw.githubusercontent.com/Arya-Blitar22/bokep/main/dora/cek-tr.sh"
wget -q -O /usr/bin/cek-v "https://raw.githubusercontent.com/Arya-Blitar22/bokep/main/dora/cek-v.sh"
wget -q -O /usr/bin/clearlog "https://raw.githubusercontent.com/Arya-Blitar22/bokep/main/dora/clearlog.sh"
wget -q -O /usr/bin/info "https://raw.githubusercontent.com/Arya-Blitar22/bokep/main/dora/info.sh"
wget -q -O /usr/bin/jam "https://raw.githubusercontent.com/Arya-Blitar22/bokep/main/dora/jam.sh"
wget -q -O /usr/bin/px "https://raw.githubusercontent.com/Arya-Blitar22/bokep/main/dora/px.sh"
wget -q -O /usr/bin/restart "https://raw.githubusercontent.com/Arya-Blitar22/bokep/main/dora/restart.sh"
wget -q -O /usr/bin/running "https://raw.githubusercontent.com/Arya-Blitar22/bokep/main/dora/running.sh"
wget -q -O /usr/bin/cek-bandwidth "https://raw.githubusercontent.com/Arya-Blitar22/bokep/main/dora/set-bw.sh"
wget -q -O /usr/bin/speedtest "https://raw.githubusercontent.com/Arya-Blitar22/bokep/main/dora/speedtest_cli.py"
wget -q -O /usr/bin/tendang "https://raw.githubusercontent.com/Arya-Blitar22/bokep/main/dora/tendang.sh"
wget -q -O /usr/bin/xp "https://raw.githubusercontent.com/Arya-Blitar22/bokep/main/dora/xp.sh"
wget -q -O /usr/bin/update-xray "https://raw.githubusercontent.com/Arya-Blitar22/bokep/main/dora/update-xray.sh"
wget -q -O /usr/bin/update "https://raw.githubusercontent.com/Arya-Blitar22/bokep/main/dora/update.sh"
wget -q -O /usr/bin/certxray "https://raw.githubusercontent.com/Arya-Blitar22/bokep/main/dora/cf.sh"
wget -q -O /usr/bin/menu-backup "https://raw.githubusercontent.com/Arya-Blitar22/bokep/main/dora/menu-backup.sh"

chmod +x /usr/bin/menu-vless
chmod +x /usr/bin/menu-vmess
chmod +x /usr/bin/menu-trojan
chmod +x /usr/bin/menu-ssh
chmod +x /usr/bin/menu
chmod +x /usr/bin/babi
chmod +x /usr/bin/menu-set
chmod +x /usr/bin/info
chmod +x /usr/bin/add-tr
chmod +x /usr/bin/add-vless
chmod +x /usr/bin/add-ws
chmod +x /usr/bin/trialssh
chmod +x /usr/bin/trialtrojan
chmod +x /usr/bin/trialvless
chmod +x /usr/bin/trialvmess
chmod +x /usr/bin/usernew
chmod +x /usr/bin/addhost
chmod +x /usr/bin/autoreboot
chmod +x /usr/bin/cek-bandwidth
chmod +x /usr/bin/cek-tr
chmod +x /usr/bin/cek-v
chmod +x /usr/bin/clearlog
chmod +x /usr/bin/info
chmod +x /usr/bin/jam
chmod +x /usr/bin/px
chmod +x /usr/bin/restart
chmod +x /usr/bin/running
chmod +x /usr/bin/cek-bandwidth
chmod +x /usr/bin/speedtest
chmod +x /usr/bin/tendang
chmod +x /usr/bin/xp
chmod +x /usr/bin/update-xray
chmod +x /usr/bin/update
chmod +x /usr/bin/certxray
chmod +x /usr/bin/menu-backup

clear
cat> /root/.profile << END
if [ "$BASH" ]; then
if [ -f ~/.bashrc ]; then
. ~/.bashrc
fi
fi
mesg n || true
clear
menu
END
chmod 644 /root/.profile
if [ -f "/root/log-install.txt" ]; then
rm -fr /root/log-install.txt
fi
if [ -f "/etc/afak.conf" ]; then
rm -fr /etc/afak.conf
fi
if [ ! -f "/etc/log-create-user.log" ]; then
echo "Log All Account " > /etc/log-create-user.log
fi

curl -sS ifconfig.me > /etc/myipvps

#install gotop
gotop_latest="$(curl -s https://api.github.com/repos/xxxserxxx/gotop/releases | grep tag_name | sed -E 's/.*"v(.*)".*/\1/' | head -n 1)"
    gotop_link="https://github.com/xxxserxxx/gotop/releases/download/v$gotop_latest/gotop_v"$gotop_latest"_linux_amd64.deb"
    curl -sL "$gotop_link" -o /tmp/gotop.deb
    dpkg -i /tmp/gotop.deb >/dev/null 2>&1

clear
echo  ""
echo  "Sukses Sayank..!!"
echo  "------------------------------------------------------------"
echo ""
echo "===============-[ Script By Arya Blitar ]-==============="
echo "     <<<<< SUPPORT ALL OS >>>>> "
echo  "   >>> Service & Port"  | tee -a log-install.txt
echo  "   - OpenSSH                 : 22"  | tee -a log-install.txt
echo  "   - SSH Websocket           : 80" | tee -a log-install.txt
echo  "   - SSH SSL Websocket       : 443" | tee -a log-install.txt
echo  "   - Stunnel4                : 444, 445, 447, 777" | tee -a log-install.txt
echo  "   - Dropbear                : 109, 143" | tee -a log-install.txt
echo  "   - Badvpn                  : 7100-7300" | tee -a log-install.txt
echo  "   - Nginx                   : 81" | tee -a log-install.txt
echo  "   - XRAY  Vmess TLS         : 443" | tee -a log-install.txt
echo  "   - XRAY  Vmess None TLS    : 80" | tee -a log-install.txt
echo  "   - XRAY  Vless TLS         : 443" | tee -a log-install.txt
echo  "   - XRAY  Vless None TLS    : 80" | tee -a log-install.txt
echo  "   - Trojan GRPC             : 443" | tee -a log-install.txt
echo  "   - Trojan WS               : 443" | tee -a log-install.txt
echo  ""  | tee -a log-install.txt
echo  "   >>> Server Information & Other Features"  | tee -a log-install.txt
echo  "   - Timezone                : Asia/Jakarta (GMT +7)"  | tee -a log-install.txt
echo  "   - Fail2Ban                : [ON]"  | tee -a log-install.txt
echo  "   - Dflate                  : [ON]"  | tee -a log-install.txt
echo  "   - IPtables                : [ON]"  | tee -a log-install.txt
echo  "   - Auto-Reboot             : [ON]"  | tee -a log-install.txt
echo  "   - Autoreboot              : 05.00 GMT +7" | tee -a log-install.txt
echo  "   - AutoBackup              : 01.00 GMT +7" | tee -a log-install.txt
echo  "   - Auto Delete Expired Account" | tee -a log-install.txt
echo  "   - Fully automatic script" | tee -a log-install.txt
echo  "   - VPS settings" | tee -a log-install.txt
echo  "   - Restore Data" | tee -a log-install.txt
echo  "   - Full Orders For Various Services" | tee -a log-install.txt
echo ""
echo "===============-[ Script By Arya Blitar ]-==============="
echo ""
echo  "------------------------------------------------------------"
echo -e "Wa Me +6281931615811"
echo  ""
echo  "" | tee -a log-install.txt
rm -fr /root/tools.sh
rm -fr /root/install-ws.sh
rm -fr /root/ssh-vpn.sh
rm -fr /root/ins-xray.sh
rm -fr /root/setup7.sh
rm -fr /root/set-br.sh
rm -fr /root/domain

echo -ne "[ ${GREEN}INFO${NC} ] Apakah Anda Ingin Reboot Sekarang ? (y/n)? "
read answer
if [ "$answer" == "${answer#[Yy]}" ] ;then
exit 0
else
reboot
fi
