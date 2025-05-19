#!/bin/bash
NC='\033[0;37m' 
PURPLE='\033[0;34m' 
GREEN='\033[0;32m' 
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }

# // Export Align
export BOLD="\e[1m"
export WARNING="${red}\e[5m"
export UNDERLINE="\e[4m"
clear

function del(){
clear
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "\E[42;1;37m               MEMBER SSH                 \E[0m"
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"      
echo "USERNAME          EXP DATE          STATUS"
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
while read expired
do
AKUN="$(echo $expired | cut -d: -f1)"
ID="$(echo $expired | grep -v nobody | cut -d: -f3)"
exp="$(chage -l $AKUN | grep "Account expires" | awk -F": " '{print $2}')"
status="$(passwd -S $AKUN | awk '{print $2}' )"
if [[ $ID -ge 1000 ]]; then
if [[ "$status" = "L" ]]; then
printf "%-17s %2s %-17s %2s \n" "$AKUN" "$exp     " "LOCKED${NORMAL}"
else
printf "%-17s %2s %-17s %2s \n" "$AKUN" "$exp     " "UNLOCKED${NORMAL}"
fi
fi
done < /etc/passwd
JUMLAH="$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd | wc -l)"
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "\E[42;1;37m                DELETE USER               \E[0m"
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"  
echo ""
read -p "Username SSH to Delete : " Pengguna

if getent passwd $Pengguna > /dev/null 2>&1; then
        userdel $Pengguna > /dev/null 2>&1
        echo -e "User $Pengguna was removed."
else
        echo -e "Failure: User $Pengguna Not Exist."
fi

read -n 1 -s -r -p "Press any key to back on menu"

menu-ssh
}
function autodel(){
clear
               hariini=`date +%d-%m-%Y`
               echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
               echo -e "\E[42;1;37m                AUTO DELETE               \E[0m"
               echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"  
               echo "Thank you for removing the EXPIRED USERS"
               echo -e "$PURPLE━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"  
               cat /etc/shadow | cut -d: -f1,8 | sed /:$/d > /tmp/expirelist.txt
               totalaccounts=`cat /tmp/expirelist.txt | wc -l`
               for((i=1; i<=$totalaccounts; i++ ))
               do
               tuserval=`head -n $i /tmp/expirelist.txt | tail -n 1`
               username=`echo $tuserval | cut -f1 -d:`
               userexp=`echo $tuserval | cut -f2 -d:`
               userexpireinseconds=$(( $userexp * 86400 ))
               tglexp=`date -d @$userexpireinseconds`             
               tgl=`echo $tglexp |awk -F" " '{print $3}'`
               while [ ${#tgl} -lt 2 ]
               do
               tgl="0"$tgl
               done
               while [ ${#username} -lt 15 ]
               do
               username=$username" " 
               done
               bulantahun=`echo $tglexp |awk -F" " '{print $2,$6}'`
               echo "echo "Expired- User : $username Expire at : $tgl $bulantahun"" >> /usr/local/bin/alluser
               todaystime=`date +%s`
               if [ $userexpireinseconds -ge $todaystime ] ;
               then
		    	:
               else
               echo "echo "Expired- Username : $username are expired at: $tgl $bulantahun and removed : $hariini "" >> /usr/local/bin/deleteduser
	           echo "Username $username that are expired at $tgl $bulantahun removed from the VPS $hariini"
               userdel $username
               fi
               done
               echo " "
               echo -e "$PURPLE━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"  
               
               read -n 1 -s -r -p "Press any key to back on menu"
               menu-ssh
        
}
function ceklim(){
clear
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "\E[42;1;37m          CEK USER MULTILOGIN      \E[0m"
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
if [ -e "/root/log-limit.txt" ]; then
echo "User Who Violate The Maximum Limit";
echo "Time - Username - Number of Multilogin"
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
cat /root/log-limit.txt
else
echo " No user has committed a violation"
echo " "
echo " or"
echo " "
echo " The user-limit script not been executed."
fi
echo " ";
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo " ";
read -n 1 -s -r -p "Press any key to back on menu"
menu
}
function cek(){
if [ -e "/var/log/auth.log" ]; then
        LOG="/var/log/auth.log";
fi
if [ -e "/var/log/secure" ]; then
        LOG="/var/log/secure";
fi
                
data=( `ps aux | grep -i dropbear | awk '{print $2}'`);
echo -e "\033[0;34m┌──────────────────────────────────────────┐\033[0m"
echo "    ID  |  Username  |  IP Address";
echo -e "\033[0;34m└──────────────────────────────────────────┘\033[0m"
cat $LOG | grep -i dropbear | grep -i "Password auth succeeded" > /tmp/login-db.txt;
for PID in "${data[@]}"
do
            cat /tmp/login-db.txt | grep "dropbear\[$PID\]" > /tmp/login-db-pid.txt;
            NUM=`cat /tmp/login-db-pid.txt | wc -l`;
            USER=`cat /tmp/login-db-pid.txt | awk '{print $10}'`;
            IP=`cat /tmp/login-db-pid.txt | awk '{print $12}'`;
            if [ $NUM -eq 1 ]; then
                    echo "$PID - $USER - $IP";
                    fi
done
echo -e "\033[0;34m└──────────────────────────────────────────┘\033[0m"
echo " "
echo -e "\033[0;34m┌──────────────────────────────────────────┐\033[0m"
echo "    ID  |  Username  |  IP Address";
echo -e "\033[0;34m└──────────────────────────────────────────┘\033[0m"
cat $LOG | grep -i sshd | grep -i "Accepted password for" > /tmp/login-db.txt
data=( `ps aux | grep "\[priv\]" | sort -k 72 | awk '{print $2}'`);

for PID in "${data[@]}"
do
            cat /tmp/login-db.txt | grep "sshd\[$PID\]" > /tmp/login-db-pid.txt;
            NUM=`cat /tmp/login-db-pid.txt | wc -l`;
            USER=`cat /tmp/login-db-pid.txt | awk '{print $9}'`;
            IP=`cat /tmp/login-db-pid.txt | awk '{print $11}'`;
            if [ $NUM -eq 1 ]; then
                    echo "$PID - $USER - $IP";
        fi
done
echo -e "\033[0;34m└──────────────────────────────────────────┘\033[0m"
if [ -f "/etc/openvpn/server/openvpn-tcp.log" ]; then
echo ""
echo -e "\033[0;34m┌──────────────────────────────────────────┐\033[0m"
echo "    Username  |  IP Address  |  Connected";
echo -e "\033[0;34m└──────────────────────────────────────────┘\033[0m"
            cat /etc/openvpn/server/openvpn-tcp.log | grep -w "^CLIENT_LIST" | cut -d ',' -f 2,3,8 | sed -e 's/,/      /g' > /tmp/vpn-login-tcp.txt
            cat /tmp/vpn-login-tcp.txt
fi
echo -e "\033[0;34m└──────────────────────────────────────────┘\033[0m"

if [ -f "/etc/openvpn/server/openvpn-udp.log" ]; then
echo " "
echo -e "\033[0;34m┌──────────────────────────────────────────┐\033[0m"
echo "    Username  |  IP Address  |  Connected";
echo -e "\033[0;34m└──────────────────────────────────────────┘\033[0m"
            cat /etc/openvpn/server/openvpn-udp.log | grep -w "^CLIENT_LIST" | cut -d ',' -f 2,3,8 | sed -e 's/,/      /g' > /tmp/vpn-login-udp.txt
            cat /tmp/vpn-login-udp.txt
fi
echo -e "\033[0;34m└──────────────────────────────────────────┘\033[0m"
echo "";
echo ""
echo -e "\033[0;33m┌──────────────────────────────────────────┐\033[0m"
echo -e "      Autoscript By Arya Blitar       "
echo -e "\033[0;33m└──────────────────────────────────────────┘\033[0m"
echo ""

rm -f /tmp/login-db-pid.txt
rm -f /tmp/login-db.txt
rm -f /tmp/vpn-login-tcp.txt
rm -f /tmp/vpn-login-udp.txt
read -n 1 -s -r -p "Press any key to back on menu"

menu-ssh
}
function member(){
clear
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "\E[42;1;37m               MEMBER SSH                 \E[0m"
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"      
echo "USERNAME          EXP DATE          STATUS"
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
while read expired
do
AKUN="$(echo $expired | cut -d: -f1)"
ID="$(echo $expired | grep -v nobody | cut -d: -f3)"
exp="$(chage -l $AKUN | grep "Account expires" | awk -F": " '{print $2}')"
status="$(passwd -S $AKUN | awk '{print $2}' )"
if [[ $ID -ge 1000 ]]; then
if [[ "$status" = "L" ]]; then
printf "%-17s %2s %-17s %2s \n" "$AKUN" "$exp     " "LOCKED${NORMAL}"
else
printf "%-17s %2s %-17s %2s \n" "$AKUN" "$exp     " "UNLOCKED${NORMAL}"
fi
fi
done < /etc/passwd
JUMLAH="$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd | wc -l)"
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo "Account number: $JUMLAH user"
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
read -n 1 -s -r -p "Press any key to back on menu"
menu-ssh
}
function renew(){
clear
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "\E[42;1;37m               MEMBER SSH                 \E[0m"
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"      
echo "USERNAME          EXP DATE          STATUS"
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
while read expired
do
AKUN="$(echo $expired | cut -d: -f1)"
ID="$(echo $expired | grep -v nobody | cut -d: -f3)"
exp="$(chage -l $AKUN | grep "Account expires" | awk -F": " '{print $2}')"
status="$(passwd -S $AKUN | awk '{print $2}' )"
if [[ $ID -ge 1000 ]]; then
if [[ "$status" = "L" ]]; then
printf "%-17s %2s %-17s %2s \n" "$AKUN" "$exp     " "LOCKED${NORMAL}"
else
printf "%-17s %2s %-17s %2s \n" "$AKUN" "$exp     " "UNLOCKED${NORMAL}"
fi
fi
done < /etc/passwd
JUMLAH="$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd | wc -l)"
echo -e ""
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "\E[42;1;37m            Perpanjang  User              \E[0m"
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"  
echo
read -p "Username : " User
egrep "^$User" /etc/passwd >/dev/null
if [ $? -eq 0 ]; then
read -p "Day Extend : " Days
Today=`date +%s`
Days_Detailed=$(( $Days * 86400 ))
Expire_On=$(($Today + $Days_Detailed))
Expiration=$(date -u --date="1970-01-01 $Expire_On sec GMT" +%Y/%m/%d)
Expiration_Display=$(date -u --date="1970-01-01 $Expire_On sec GMT" '+%d %b %Y')
passwd -u $User
usermod -e  $Expiration $User
egrep "^$User" /etc/passwd >/dev/null
echo -e "$Pass\n$Pass\n"|passwd $User &> /dev/null
clear
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "\E[42;1;37m            Perpanjang  User              \E[0m"
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"  
echo -e ""
echo -e " Username : $User"
echo -e " Days Added : $Days Days"
echo -e " Expires on :  $Expiration_Display"
echo -e ""
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
else
clear
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "\E[42;1;37m            Perpanjang  User              \E[0m"
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"  
echo -e ""
echo -e "   Username Doesnt Exist      "
echo -e ""
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
fi
read -n 1 -s -r -p "Press any key to back on menu"
menu-ssh
}
function tendang(){
clear
MAX=1
if [ -e "/var/log/auth.log" ]; then
        OS=1;
        LOG="/var/log/auth.log";
fi
if [ -e "/var/log/secure" ]; then
        OS=2;
        LOG="/var/log/secure";
fi

if [ $OS -eq 1 ]; then
	service ssh restart > /dev/null 2>&1;
fi
if [ $OS -eq 2 ]; then
	service sshd restart > /dev/null 2>&1;
fi
	service dropbear restart > /dev/null 2>&1;
				
if [[ ${1+x} ]]; then
        MAX=$1;
fi

        cat /etc/passwd | grep "/home/" | cut -d":" -f1 > /root/user.txt
        username1=( `cat "/root/user.txt" `);
        i="0";
        for user in "${username1[@]}"
			do
                username[$i]=`echo $user | sed 's/'\''//g'`;
                jumlah[$i]=0;
                i=$i+1;
			done
        cat $LOG | grep -i dropbear | grep -i "Password auth succeeded" > /tmp/log-db.txt
        proc=( `ps aux | grep -i dropbear | awk '{print $2}'`);
        for PID in "${proc[@]}"
			do
                cat /tmp/log-db.txt | grep "dropbear\[$PID\]" > /tmp/log-db-pid.txt
                NUM=`cat /tmp/log-db-pid.txt | wc -l`;
                USER=`cat /tmp/log-db-pid.txt | awk '{print $10}' | sed 's/'\''//g'`;
                IP=`cat /tmp/log-db-pid.txt | awk '{print $12}'`;
                if [ $NUM -eq 1 ]; then
                        i=0;
                        for user1 in "${username[@]}"
							do
                                if [ "$USER" == "$user1" ]; then
                                        jumlah[$i]=`expr ${jumlah[$i]} + 1`;
                                        pid[$i]="${pid[$i]} $PID"
                                fi
                                i=$i+1;
							done
                fi
			done
        cat $LOG | grep -i sshd | grep -i "Accepted password for" > /tmp/log-db.txt
        data=( `ps aux | grep "\[priv\]" | sort -k 72 | awk '{print $2}'`);
        for PID in "${data[@]}"
			do
                cat /tmp/log-db.txt | grep "sshd\[$PID\]" > /tmp/log-db-pid.txt;
                NUM=`cat /tmp/log-db-pid.txt | wc -l`;
                USER=`cat /tmp/log-db-pid.txt | awk '{print $9}'`;
                IP=`cat /tmp/log-db-pid.txt | awk '{print $11}'`;
                if [ $NUM -eq 1 ]; then
                        i=0;
                        for user1 in "${username[@]}"
							do
                                if [ "$USER" == "$user1" ]; then
                                        jumlah[$i]=`expr ${jumlah[$i]} + 1`;
                                        pid[$i]="${pid[$i]} $PID"
                                fi
                                i=$i+1;
							done
                fi
        done
        j="0";
        for i in ${!username[*]}
			do
                if [ ${jumlah[$i]} -gt $MAX ]; then
                        date=`date +"%Y-%m-%d %X"`;
                        echo "$date - ${username[$i]} - ${jumlah[$i]}";
                        echo "$date - ${username[$i]} - ${jumlah[$i]}" >> /root/log-limit.txt;
                        kill ${pid[$i]};
                        pid[$i]="";
                        j=`expr $j + 1`;
                fi
			done
        if [ $j -gt 0 ]; then
                if [ $OS -eq 1 ]; then
                        service ssh restart > /dev/null 2>&1;
                fi
                if [ $OS -eq 2 ]; then
                        service sshd restart > /dev/null 2>&1;
                fi
                service dropbear restart > /dev/null 2>&1;
                j=0;
		fi
read -n 1 -s -r -p "Press any key to back on menu"
menu-ssh
}

clear
echo -e "${PURPLE}┌─────────────────────────────────────────────────┐${NC}"
echo -e "${PURPLE} \E[42;1;37m                     SSH MENU                    ${PURPLE}│$NC"
echo -e "${PURPLE}└─────────────────────────────────────────────────┘${NC}"
echo -e "${PURPLE}┌───────────────────────────────────────────────┐${NC}"
echo -e "     ${GREEN}[1]${NC}  Create Ssh Account "
echo -e "     ${GREEN}[2]${NC}  Trial Ssh Acoount  "
echo -e "     ${GREEN}[3]${NC}  Delete Ssh Acoount  "
echo -e "     ${GREEN}[4]${NC}  Perpanjang Ssh Account  "
echo -e "     ${GREEN}[5]${NC}  Cek User Login "
echo -e "     ${GREEN}[6]${NC}  Cek User Multi Log "
echo -e "     ${GREEN}[7]${NC}  Auto Del User Exp  "
echo -e "     ${GREEN}[8]${NC}  Auto Kill User Ssh "
echo -e "     ${GREEN}[9]${NC}  Cek All Member Ssh "
echo -e "     ${GREEN}[10]${NC} Tendang User Multi"
echo -e " "
echo -e "     ${GREEN}[0]${NC} Back To Menu      "
echo -e "${PURPLE}└───────────────────────────────────────────────┘${NC}"
echo ""
read -p " Select menu : " opt
echo -e ""
case $opt in
1) clear ; addssh ;;
2) clear ; trialssh ;;
3) clear ; del ;;
4) clear ; renew;;
5) clear ; cek ;;
6) clear ; ceklim ;;
7) clear ; autodel ;;
8) clear ; autokill ;;
9) clear ; member ;;
10) clear ; autotendang ;;
0) clear ; menu ;;
*) echo -e "" ; echo "Press any key to back on menu" ; sleep 1 ; menu ;;
esac
