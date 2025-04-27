#!/bin/bash


BIBlack='\033[1;90m'      # Black
BIRed='\033[1;91m'        # Red
BIGreen='\033[1;92m'      # Green
BIYellow='\033[1;93m'     # Yellow
BIBlue='\033[1;94m'       # Blue
BIPurple='\033[1;95m'     # Purple
BICyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White
UWhite='\033[4;37m'       # White
On_IPurple='\033[0;105m'  #
On_IRed='\033[0;101m'
IBlack='\033[0;90m'       # Black
IRed='\033[0;91m'         # Red
IGreen='\033[0;92m'       # Green
IYellow='\033[0;93m'      # Yellow
IBlue='\033[0;94m'        # Blue
IPurple='\033[0;95m'      # Purple
ICyan='\033[0;96m'        # Cyan
IWhite='\033[0;97m'       # White
NC='\033[0;37m'
PURPLE='\033[0;34m'
RED='\033[0;31m'
GREEN='\033[0;32m'
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }

# // Export Align
export BOLD="\e[1m"
export WARNING="${RED}\e[5m"
export UNDERLINE="\e[4m"
clear
clear
function add-tr(){
clear
source /var/lib/scrz-prem/ipvps.conf
if [[ "$IP" = "" ]]; then
domain=$(cat /etc/xray/domain)
else
domain=$IP
fi
tr="$(cat ~/log-install.txt | grep -w "Trojan" | cut -d: -f2|sed 's/ //g')"
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${user_EXISTS} == '0' ]]; do
		read -rp "Password : " -e user
		user_EXISTS=$(grep -w $user /etc/xray/config.json | wc -l)

		if [[ ${user_EXISTS} == '1' ]]; then
			echo ""
			echo -e "Username ${RED}${user}${NC} Already On VPS Please Choose Another"
			exit 1
		fi
	done
read -p "Expired (Days) : " masaaktif
hariini=`date -d "0 days" +"%Y-%m-%d"`
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#xray-trojan$/a\#&# '"$user $exp"'\
},{"password": "'""$user""'","email": "'""$user""'"' /etc/xray/config.json
systemctl restart xray.service
trojanlink="trojan://${user}@${domain}:${tr}"
service cron restart
clear
echo -e ""
echo -e "======-XRAYS/TROJAN-GFW-======"
echo -e "Remarks  : ${user}"
echo -e "Address    : ${domain}"
echo -e "Port     : 2083"
echo -e "Key      : ${user}"
echo -e "Created  : $hariini"
echo -e "Expired  : $exp"
echo -e "=========================="
echo -e "Link TR  : ${trojanlink}"
echo -e "=========================="
echo -e ""
echo -e " \033[0;32mSc By Arya Blitar${NC}" 
echo "" 
read -n 1 -s -r -p "Press any key to back on menu"
    menu-trgfw

}

function renewws(){
clear
NUMBER_OF_CLIENTS=$(grep -c -E "^#&# " "/etc/xray/config.json")
	if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
		clear
		echo ""
		echo "You have no existing clients!"
		exit 1
	fi

	clear
	echo ""
	echo "Select the existing client you want to renew"
	echo " Press CTRL+C to return"
	echo -e "==============================="
	grep -E "^#&# " "/etc/xray/config.json" | cut -d ' ' -f 2-3 | nl -s ') '
	until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
		if [[ ${CLIENT_NUMBER} == '1' ]]; then
			read -rp "Select one client [1]: " CLIENT_NUMBER
		else
			read -rp "Select one client [1-${NUMBER_OF_CLIENTS}]: " CLIENT_NUMBER
		fi
	done
read -p "Expired (Days) : " masaaktif
user=$(grep -E "^#&# " "/etc/xray/config.json" | cut -d ' ' -f 2 | sed -n "${CLIENT_NUMBER}"p)
exp=$(grep -E "^#&# " "/etc/xray/config.json" | cut -d ' ' -f 3 | sed -n "${CLIENT_NUMBER}"p)
now=$(date +%Y-%m-%d)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
exp3=$(($exp2 + $masaaktif))
exp4=`date -d "$exp3 days" +"%Y-%m-%d"`
sed -i "s/#&# $user $exp/#&# $user $exp4/g" /etc/xray/config.json
clear
echo ""
echo "================================"
echo "  XRAYS/Trojan Account Renewed  "
echo "================================"
echo "Username  : $user"
echo "Expired  : $exp4"
echo "================================"
    echo ""
    read -n 1 -s -r -p "Press any key to back on menu"
    menu-trgfw
    #fi
}

function cektrf(){
clear
echo -n > /tmp/other.txt
data=( `cat /etc/xray/config.json | grep '^#&#' | cut -d ' ' -f 2`);
echo "-----------------------------------------";
echo "---------=[ Trojan User Login ]=---------";
echo "-----------------------------------------";
for akun in "${data[@]}"
do
if [[ -z "$akun" ]]; then
akun="tidakada"
fi
echo -n > /tmp/iptrojan.txt
data2=( `netstat -anp | grep ESTABLISHED | grep tcp6 | grep xray | awk '{print $5}' | cut -d: -f1 | sort | uniq`);
for ip in "${data2[@]}"
do
jum=$(cat /var/log/xray/access.log | grep -w $akun | awk '{print $3}' | cut -d: -f1 | grep -w $ip | sort | uniq)
if [[ "$jum" = "$ip" ]]; then
echo "$jum" >> /tmp/iptrojan.txt
else
echo "$ip" >> /tmp/other.txt
fi
jum2=$(cat /tmp/iptrojan.txt)
sed -i "/$jum2/d" /tmp/other.txt > /dev/null 2>&1
done
jum=$(cat /tmp/iptrojan.txt)
if [[ -z "$jum" ]]; then
echo > /dev/null
else
jum2=$(cat /tmp/iptrojan.txt | nl)
echo "user : $akun";
echo "$jum2";
echo "-----------------------------------------"
fi
rm -rf /tmp/iptrojan.txt
done
oth=$(cat /tmp/other.txt | sort | uniq | nl)
echo "other";
echo "$oth";
echo "-----------------------------------------"
echo "Script By Arya Blitar"
rm -rf /tmp/other.txt
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
menu-trgfw
}

function delws() {
clear
NUMBER_OF_CLIENTS=$(grep -c -E "^#&# " "/etc/xray/config.json")
	if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
		echo ""
		echo "You have no existing clients!"
		exit 1
	fi

	echo ""
	echo " Select the existing client you want to remove"
	echo " Press CTRL+C to return"
	echo " ==============================="
	echo "     No  Expired   User"
	grep -E "^#&# " "/etc/xray/config.json" | cut -d ' ' -f 2-3 | nl -s ') '
	until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
		if [[ ${CLIENT_NUMBER} == '1' ]]; then
			read -rp "Select one client [1]: " CLIENT_NUMBER
		else
			read -rp "Select one client [1-${NUMBER_OF_CLIENTS}]: " CLIENT_NUMBER
		fi
	done
user=$(grep -E "^#&# " "/etc/xray/config.json" | cut -d ' ' -f 2 | sed -n "${CLIENT_NUMBER}"p)
exp=$(grep -E "^#&# " "/etc/xray/config.json" | cut -d ' ' -f 3 | sed -n "${CLIENT_NUMBER}"p)
sed -i "/^#&# $user $exp/,/^},{/d" /etc/xray/config.json
sed -i "/^#&# $user $exp/,/^},{/d" /etc/xray/config.json
systemctl restart xray.service
service cron restart
clear
echo ""
echo "================================"
echo "  XRAYS/Trojan Account Deleted  "
echo "================================"
echo "Username  : $user"
echo "Expired   : $exp"
echo "================================"
    echo ""
    read -n 1 -s -r -p "Press any key to back on menu"
    
    menu-trgfw
    #fi
}
clear
echo -e "$PURPLE┌─────────────────────────────────────────────────┐${NC}"
echo -e "$PURPLE│\E[42;1;37m                 TROJAN-GFW MENU                 $PURPLE│$NC"
echo -e "$PURPLE└─────────────────────────────────────────────────┘${NC}"
echo -e " $PURPLE┌───────────────────────────────────────────────┐${NC}"
echo -e "     ${GREEN}[${BIWhite}1${GREEN}] ${NC}Create Tro-Gfw Account      "
echo -e "     ${GREEN}[${BIWhite}2${GREEN}] ${NC}Delete Account Tro-Gfw      "
echo -e "     ${GREEN}[${BIWhite}3${GREEN}] ${NC}Renew Account Tro-Gfw      "
echo -e "     ${GREEN}[${BIWhite}4${GREEN}] ${NC}CEK Account Tro-Gfw     "
echo -e " "
echo -e "     ${GREEN}[${BIWhite}0${GREEN}] Back To Menu     "
echo -e " ${PURPLE}└──────────────────────────────────────────────┘${NC}"
echo ""
read -p " Select menu : " opt
echo -e ""
case $opt in
1) clear ; add-tr ;;
2) clear ; delws ;;
3) clear ; renewws;;
4) clear ; cektrf ;;
0) clear ; menu ;;
x) exit ;;
*) echo -e "" ; echo "Press any key to back on menu" ; sleep 1 ; menu ;;
esac