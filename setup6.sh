#!/bin/bash
clear
rm -rf setup.sh
rm -rf /etc/xray/domain
rm -rf /etc/v2ray/domain
rm -rf /etc/xray/scdomain
rm -rf /etc/v2ray/scdomain
rm -rf /var/lib/ipvps.conf
red='\e[1;31m'
green='\e[0;32m'
yell='\e[1;33m'
tyblue='\e[1;36m'
BRed='\e[1;31m'
BGreen='\e[1;32m'
BYellow='\e[1;35m'
BBlue='\e[1;32m'
NC='\e[0m'
purple() { echo -e "\\033[35;1m${*}\\033[0m"; }
tyblue() { echo -e "\\033[36;1m${*}\\033[0m"; }
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }


clear
# domain random
CDN="https://raw.githubusercontent.com/Arya-Blitar22/auto/main/ssh"
cd /root
#System version number
if [ "${EUID}" -ne 0 ]; then
		echo "You need to run this script as root"
		exit 1
fi
if [ "$(systemd-detect-virt)" == "openvz" ]; then
		echo "OpenVZ is not supported"
		exit 1
fi

localip=$(hostname -I | cut -d\  -f1)
hst=( `hostname` )
dart=$(cat /etc/hosts | grep -w `hostname` | awk '{print $2}')
if [[ "$hst" != "$dart" ]]; then
echo "$localip $(hostname)" >> /etc/hosts
fi

mkdir -p /etc/xray
mkdir -p /etc/v2ray
touch /etc/xray/domain
touch /etc/v2ray/domain
touch /etc/xray/scdomain
touch /etc/v2ray/scdomain


echo -e "[ ${BBlue}NOTES${NC} ] Sebelum kita pergi.. "
sleep 0.5
echo -e "[ ${BBlue}NOTES${NC} ] Saya perlu memeriksa header Anda terlebih dahulu..."
sleep 0.5
echo -e "[ ${BGreen}INFO${NC} ] Memeriksa header"
sleep 0.5
totet=`uname -r`
REQUIRED_PKG="linux-headers-$totet"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
echo Checking for $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
  sleep 0.5
  echo -e "[ ${BRed}WARNING${NC} ] Cobalah untuk menginstal ...."
  echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
  apt-get --yes install $REQUIRED_PKG
  sleep 0.5
  echo ""
  sleep 0.5
  echo -e "[ ${BBlue}NOTES${NC} ] If error you need.. to do this"
  sleep 0.5
  echo ""
  sleep 0.5
  echo -e "[ ${BBlue}NOTES${NC} ] apt update && upgrade"
  sleep 0.5
  echo ""
  sleep 0.5
  echo -e "[ ${BBlue}NOTES${NC} ] Setelah ini"
  sleep 0.5
  echo -e "[ ${BBlue}NOTES${NC} ] Kemudian jalankan skrip ini lagi"
  echo -e "[ ${BBlue}NOTES${NC} ] enter now"
  read
else
  echo -e "[ ${BGreen}INFO${NC} ] Oke terpasang"
fi

ttet=`uname -r`
ReqPKG="linux-headers-$ttet"
if ! dpkg -s $ReqPKG  >/dev/null 2>&1; then
  rm /root/setup.sh >/dev/null 2>&1 
  exit
else
  clear
fi


secs_to_human() {
    echo "Installation time : $(( ${1} / 3600 )) hours $(( (${1} / 60) % 60 )) minute's $(( ${1} % 60 )) seconds"
}
start=$(date +%s)
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
sysctl -w net.ipv6.conf.all.disable_ipv6=1 >/dev/null 2>&1
sysctl -w net.ipv6.conf.default.disable_ipv6=1 >/dev/null 2>&1

echo -e "[ ${BGreen}INFO${NC} ] Mempersiapkan file instalasi"
apt install git curl -y >/dev/null 2>&1
apt install python -y >/dev/null 2>&1
echo -e "[ ${BGreen}INFO${NC} ] Oke bagus... file instalasi sudah siap"
sleep 0.5
echo -ne "[ ${BGreen}INFO${NC} ] Periksa izin : "

echo -e "$BGreen Izin Diterima!$NC"
sleep 2

mkdir -p /var/lib/ >/dev/null 2>&1
echo "IP=" >> /var/lib/ipvps.conf

echo ""
clear
    echo -e "$NC                 PENYIAPAN DOMAIN VPS     $NC"
    echo -e "$BYellow----------------------------------------------------------$NC"
    echo -e "$NC 1. Gunakan Domain Acak $NC"
    echo -e "$NC 2. Gunakan Domain Sendiri $NC"
    echo -e "$BYellow----------------------------------------------------------$NC"
    read -rp " Pilih domain yang akan kamu pakai : " dns
	if test $dns -eq 1; then
    clear
    apt install jq curl -y
    wget -q -O /root/cf "${CDN}/cf" >/dev/null 2>&1
    chmod +x /root/cf
    bash /root/cf | tee /root/install.log
    print_success "Domain Acak Done"
	elif test $dns -eq 2; then
    read -rp "Enter Your Domain : " dom
    echo "$dom" > /root/scdomain
	echo "$dom" > /etc/xray/scdomain
	echo "$dom" > /etc/xray/domain
	echo "$dom" > /etc/v2ray/domain
	echo "$dom" > /root/domain
    echo "IP=$dom" > /var/lib/ipvps.conf
    else 
    echo "Argumen Tidak Ditemukan"
    exit 1
    fi
	echo -e "${BGreen}Selesai!${NC}"
    sleep 2
    clear
    
#install
/etc/init.d/vnstat restart >/dev/null 2>&1
wget -q https://humdi.net/vnstat/vnstat-2.6.tar.gz
tar zxvf vnstat-2.6.tar.gz
cd vnstat-2.6
./configure --prefix=/usr --sysconfdir=/etc >/dev/null 2>&1 && make >/dev/null 2>&1 && make install >/dev/null 2>&1
cd
vnstat -u -i $NET
sed -i 's/Interface "'""eth0""'"/Interface "'""$NET""'"/g' /etc/vnstat.conf
chown vnstat:vnstat /var/lib/vnstat -R
systemctl enable vnstat >/dev/null 2>&1
/etc/init.d/vnstat restart >/dev/null 2>&1
rm -f /root/vnstat-2.6.tar.gz >/dev/null 2>&1
rm -rf /root/vnstat-2.6 >/dev/null 2>&1

yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
yellow "Utama berhasil diinstal..."
sleep 3
clear
echo -e "┌─────────────────────────────────────────┐"
echo -e " \E[42;1;37m           >>> Install Ssh Vpn <<<          \E[0m$NC"
echo -e "└─────────────────────────────────────────┘"
sleep 1
wget https://raw.githubusercontent.com/kipas77pro/tulel/main/bot/ssh-vpn.sh && chmod +x ssh-vpn.sh && ./ssh-vpn.sh
echo -e "┌─────────────────────────────────────────┐"
echo -e " \E[42;1;37m           >>> Install Vray <<<          \E[0m$NC"
echo -e "└─────────────────────────────────────────┘"
sleep 1
wget https://raw.githubusercontent.com/kipas77pro/tunel/main/tools/ins-xray.sh && chmod +x ins-xray.sh && ./ins-xray.sh
echo -e "┌─────────────────────────────────────────┐"
echo -e " \E[42;1;37m           >>> Install Backup <<<          \E[0m$NC"
echo -e "└─────────────────────────────────────────┘"
sleep 1
wget https://raw.githubusercontent.com/Arya-Blitar22/bokep/main/backup/set-br.sh && chmod +x set-br.sh && ./set-br.sh
echo -e "┌─────────────────────────────────────────┐"
echo -e " \E[42;1;37m           >>> Install Wsoket <<<          \E[0m$NC"
echo -e "└─────────────────────────────────────────┘"
#sleep 1
#wget https://raw.githubusercontent.com/Arya-Blitar22/mainan/main/sshws/insshws.sh && chmod +x insshws.sh && ./insshws.sh
clear
cat> /root/.profile << END
# ~/.profile: executed by Bourne-compatible login shells.

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
rm /root/log-install.txt > /dev/null 2>&1
fi
if [ -f "/etc/afak.conf" ]; then
rm /etc/afak.conf > /dev/null 2>&1
fi
if [ ! -f "/etc/log-create-ssh.log" ]; then
echo "Log SSH Account " > /etc/log-create-ssh.log
fi
if [ ! -f "/etc/log-create-vmess.log" ]; then
echo "Log Vmess Account " > /etc/log-create-vmess.log
fi
history -c
serverV=$( curl -sS https://raw.githubusercontent.com/Arya-Blitar22/auto/main/menu/versi  )
echo $serverV > /opt/.ver
aureb=$(cat /home/re_otm)
b=11
if [ $aureb -gt $b ]
then
gg="PM"
else
gg="AM"
fi
curl -sS ipv4.icanhazip.com > /etc/myipvps

#install gotop
gotop_latest="$(curl -s https://api.github.com/repos/xxxserxxx/gotop/releases | grep tag_name | sed -E 's/.*"v(.*)".*/\1/' | head -n 1)"
    gotop_link="https://github.com/xxxserxxx/gotop/releases/download/v$gotop_latest/gotop_v"$gotop_latest"_linux_amd64.deb"
    curl -sL "$gotop_link" -o /tmp/gotop.deb
    dpkg -i /tmp/gotop.deb >/dev/null 2>&1
    
clear
echo "==================================================================" | tee -a log-install.txt
echo " "
echo "   >>> Service & Port"  | tee -a log-install.txt
echo "   - OpenSSH                  : 22"  | tee -a log-install.txt
echo "   - SSH Websocket            : 80, 8880" | tee -a log-install.txt
echo "   - SSH SSL Websocket        : 443, 8443" | tee -a log-install.txt
echo "   - Stunnel4                 : 445, 447, 777" | tee -a log-install.txt
echo "   - Dropbear                 : 109, 143" | tee -a log-install.txt
echo "   - Badvpn                   : 7100-7900" | tee -a log-install.txt
echo "   - Nginx                    : 81" | tee -a log-install.txt
echo "   - Vmess WS TLS             : 443, 8443" | tee -a log-install.txt
echo "   - Vmess WS none TLS        : 80, 8880" | tee -a log-install.txt
echo "   - Vless WS none TLS        : 80, 8880" | tee -a log-install.txt
echo "   - Vmess gRPC               : 443, 8443" | tee -a log-install.txt
echo ""
echo "==================================================================" | tee -a log-install.txt
echo -e ""
echo ""
echo "" | tee -a log-install.txt
rm /root/setup.sh >/dev/null 2>&1
rm /root/ins-xray.sh >/dev/null 2>&1
rm /root/ssh-vpn.sh >/dev/null 2>&1
rm /root/insshws.sh >/dev/null 2>&1
secs_to_human "$(($(date +%s) - ${start}))" | tee -a log-install.txt
echo -e "
"
echo -ne "[ ${yell}PERINGATAN${NC} ] reboot sekarang ? (y/n)? "
read answer
if [ "$answer" == "${answer#[Yy]}" ] ;then
exit 0
else
reboot
fi





