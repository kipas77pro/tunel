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
tr="$(cat ~/log-install.txt | grep -w "Trojan WS " | cut -d: -f2|sed 's/ //g')"
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${user_EXISTS} == '0' ]]; do
echo -e "\033[0;34m┌─────────────────────────────────────────────────┐\033[0m"
echo -e " \E[42;1;37m              CREATE TROJAN ACCOUNT              \E[0m"
echo -e "\033[0;34m└─────────────────────────────────────────────────┘\033[0m"

		read -rp "User: " -e user
		user_EXISTS=$(grep -w $user /etc/xray/config.json | wc -l)
		
		if [[ ${user_EXISTS} == '1' ]]; then
clear
		echo -e "\033[0;34m┌─────────────────────────────────────────────────┐\033[0m"
		echo -e " \E[42;1;37m               CREATE TROJAN ACCOUNT             \E[0m"
		echo -e "\033[0;34m└─────────────────────────────────────────────────┘\033[0m"
			echo ""
			echo "A client with the specified name was already created, please choose another name."
			echo ""
			echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
			read -n 1 -s -r -p "Press any key to back on menu"
			menu-trojan
		fi
	done

uuid=$(cat /proc/sys/kernel/random/uuid)
read -p "Expired (days): " masaaktif
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#trojanws$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/config.json
sed -i '/#trojangrpc$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/config.json

systemctl restart xray
trojanlink="trojan://${uuid}@bug.com:443?path=%2Ftrojan-ws&security=tls&host=${domain}&type=ws&sni=${domain}#${user}"
trojanlink1="trojan://${uuid}@${domain}:443?mode=gun&security=tls&type=grpc&serviceName=trojan-grpc&sni=bug.com#${user}"
clear
echo -e "\033[0;34m════════════\033[0;33mXRAY/TROJANWS\033[0;34m════════════${NC}"
echo -e "Remarks     : ${user}" 
echo -e "Expired On  : $exp" 
echo -e "Host/IP     : ${domain}" 
echo -e "Port        : 443, 8443, 2087, 2096, 2053, 2083, 2093"
echo -e "Key         : ${uuid}" 
echo -e "Path        : /trojan-ws"
echo -e "ServiceName : trojan-grpc" 
echo -e "\033[0;34m════════════════════════════════════${NC}"
echo -e "Link WS : "
echo -e "${trojanlink}" 
echo -e "\033[0;34m════════════════════════════════════${NC} "
echo -e "Link GRPC : "
echo -e "${trojanlink1}"
echo -e "\033[0;34m════════════════════════════════════${NC}" 
echo -e ""
echo -e " \033[0;32mSc By Arya Blitar${NC}" 
echo "" 
read -n 1 -s -r -p "Press any key to back on menu"
    menu-trojan

}

function renewws(){
clear
NUMBER_OF_CLIENTS=$(grep -c -E "^### " "/etc/xray/config.json")
	if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
		clear
        echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
        echo -e "\E[42;1;37m            Renew Trojan           \E[0m"
        echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
		echo ""
		echo "You have no existing clients!"
		echo ""
		echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
        echo ""
        read -n 1 -s -r -p "Press any key to back on menu"
        menu
	fi

	clear
	echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\E[42;1;37m            Renew Trojan           \E[0m"
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo ""
  	grep -E "^### " "/etc/xray/config.json" | cut -d ' ' -f 2-3 | column -t | sort | uniq
    echo ""
    red "tap enter to go back"
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
	read -rp "Input Username : " user
    if [ -z $user ]; then
    menu
    else
    read -p "Expired (days): " masaaktif
    exp=$(grep -wE "^### $user" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
    now=$(date +%Y-%m-%d)
    d1=$(date -d "$exp" +%s)
    d2=$(date -d "$now" +%s)
    exp2=$(( (d1 - d2) / 86400 ))
    exp3=$(($exp2 + $masaaktif))
    exp4=`date -d "$exp3 days" +"%Y-%m-%d"`
    sed -i "/### $user/c\### $user $exp4" /etc/xray/config.json
    systemctl restart xray > /dev/null 2>&1
    clear
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e " \033[0;33mTrojan  Account Was Successfully Renewed"
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo ""
    echo " Client Name : $user"
    echo " Expired On  : $exp4"
    echo ""
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo ""
    read -n 1 -s -r -p "Press any key to back on menu"
    menu-trojan
  fi
}

function trialtrojan(){
clear
domain=$(cat /etc/xray/domain)
tr="$(cat ~/log-install.txt | grep -w "Trojan WS" | cut -d: -f2|sed 's/ //g')"
user=trial`</dev/urandom tr -dc X-Z0-9 | head -c4`
uuid=$(cat /proc/sys/kernel/random/uuid)
masaaktif=1
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#trojanws$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/config.json
sed -i '/#trojangrpc$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/config.json

systemctl restart xray
trojanlink1="trojan://${uuid}@${domain}:443?mode=gun&security=tls&type=grpc&serviceName=trojan-grpc&sni=bug.com#${user}"
trojanlink="trojan://${uuid}@bug.com:443?path=%2Ftrojan-ws&security=tls&host=${domain}&type=ws&sni=${domain}#${user}"
clear
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[42;1;37m           Trial TROJAN            \E[0m"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Remarks      : ${user}"
echo -e "Host/IP      : ${domain}"
echo -e "port         : 443, 8443, 2087, 2096, 2053, 2083"
echo -e "Key          : ${uuid}"
echo -e "Path         : /trojan-ws"
echo -e "ServiceName  : trojan-grpc"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Link WS      : ${trojanlink}"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Link GRPC    : ${trojanlink1}"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Expired On   : $exp"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e " "
echo -e "\033[0;32m Sc Arya Blitar \033[0m"
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
menu-trojan
}

function delws() {
clear
NUMBER_OF_CLIENTS=$(grep -c -E "^### " "/etc/xray/config.json")
	if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
		echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
        echo -e "\E[42;1;37m      Delete Trojan  Account      \E[0m"
        echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
		echo ""
		echo "You have no existing clients!"
		echo ""
		echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
		read -n 1 -s -r -p "Press any key to back on menu"
        menu
	fi

	clear
	echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\E[42;1;37m       Delete Trojan  Account      \E[0m"
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo "  User       Expired  " 
	echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
	grep -E "^### " "/etc/xray/config.json" | cut -d ' ' -f 2-3 | column -t | sort | uniq
    echo ""
    red "tap enter to go back"
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
	read -rp "Input Username : " user
    if [ -z $user ]; then
    menu
    else
    exp=$(grep -wE "^### $user" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
    sed -i "/^### $user $exp/,/^},{/d" /etc/xray/config.json
    systemctl restart xray > /dev/null 2>&1
    clear
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\033[0;33mTrojan  Account Deleted Successfully"
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo " Client Name : $user"
    echo " Expired On  : $exp"
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo ""
    read -n 1 -s -r -p "Press any key to back on menu"
    
    menu-trojan
    fi
}
clear
echo -e "$PURPLE┌─────────────────────────────────────────────────┐${NC}"
echo -e "$PURPLE│\E[42;1;37m                    TROJAN MENU                  $PURPLE│$NC"
echo -e "$PURPLE└─────────────────────────────────────────────────┘${NC}"
echo -e " $PURPLE┌───────────────────────────────────────────────┐${NC}"
echo -e "     ${GREEN}[${BIWhite}1${GREEN}] ${NC}Create Trojan Account      "
echo -e "     ${GREEN}[${BIWhite}2${GREEN}] ${NC}Trial Account Trojan     "
echo -e "     ${GREEN}[${BIWhite}3${GREEN}] ${NC}Delete Account Trojan      "
echo -e "     ${GREEN}[${BIWhite}4${GREEN}] ${NC}Renew Account Trojan      "
echo -e " "
echo -e "     ${GREEN}[${BIWhite}0${GREEN}] Back To Menu     "
echo -e " ${PURPLE}└──────────────────────────────────────────────┘${NC}"
echo ""
read -p " Select menu : " opt
echo -e ""
case $opt in
1) clear ; add-tr ;;
2) clear ; trialtrojan ;;
3) clear ; delws ;;
4) clear ; renewws;;
0) clear ; menu ;;
x) exit ;;
*) echo -e "" ; echo "Press any key to back on menu" ; sleep 1 ; menu ;;
esac
