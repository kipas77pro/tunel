#!/bin/bash
NC='\033[0;37m'
DEFBOLD='\e[39;0m'
RB='\033[0;36m'
GB='\033[0;37m'
YB='\e[33;1m'
BB='\033[0;34m'
MB='\033[0;33m'
CB='\e[35;1m'
WB='\e[37;0m'
RED='\033[0;31m'
GREEN='\033[0;32m'

clear
clear
echo -n >/tmp/other.txt
data=( `cat /etc/xray/config.json | grep '###' | cut -d ' ' -f 2 | sort | uniq`);
echo -e "\033[\033[0;34m┌──────────────────────────────────────────┐\033[0m"
echo -e "           VMESS USER LOGIN            $NC"
echo -e "\033[\033[0;34m└──────────────────────────────────────────┘\033[0m"
echo -e "\033[1;91m┌──────────────────────────────────────────┐\033[0m"
for akun in "${data[@]}"
do
if [[ -z "$akun" ]]; then
akun="tidakada"
fi

echo -n > /tmp/ipvmess.txt
data2=( `cat /var/log/xray/access.log | tail -n 500 | cut -d " " -f 3 | sed 's/tcp://g' | cut -d ":" -f 1 | sort | uniq`);
for ip in "${data2[@]}"
do

jum=$(cat /var/log/xray/access.log | grep -w "$akun" | tail -n 500 | cut -d " " -f 3 | sed 's/tcp://g' | cut -d ":" -f 1 | grep -w "$ip" | sort | uniq)
if [[ "$jum" = "$ip" ]]; then
echo "$jum" >> /tmp/ipvmess.txt
else
echo "$ip" >> /tmp/other.txt
fi
jum2=$(cat /tmp/ipvmess.txt)
lastlogin=$(cat /var/log/xray/access.log | grep -w "$akun" | tail -n 500 | cut -d " " -f 2 | tail -1)
sed -i "/$jum2/d" /tmp/other.txt > /dev/null 2>&1
done

jum=$(cat /tmp/ipvmess.txt)
if [[ -z "$jum" ]]; then
echo > /dev/null
else
jum2=$(cat /tmp/ipvmess.txt | nl)
echo -e ""
echo -e "${NC}user :${GREEN} ${akun} ${NC}
${MB}Online Jam ${NC}: ${lastlogin} wib";
echo -e "$jum2";
fi
rm -rf /tmp/ipvmess.txt
done
rm -rf /tmp/other.txt
echo -e "\033[1;91m└──────────────────────────────────────────┘\033[0m"
echo -e "${GREEN} "
echo -e " Sc Arya Blitar ${NC} "
echo -e " "
read -n 1 -s -r -p " Klik Enter Balik Ke menu"
menu
