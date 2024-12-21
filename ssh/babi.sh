#!/bin/bash
clear
clear

echo -n > /tmp/other.txt
data=( `cat /etc/xray/config.json | grep '###' | cut -d ' ' -f 2 | sort | uniq`);
echo -e "\033[\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "         CEK ALLVRAY ACCOUNT            \e[0m"
echo -e "\033[\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
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
sed -i "/$jum2/d" /tmp/other.txt > /dev/null 2>&1
done
jum=$(cat /tmp/ipvmess.txt)
if [[ -z "$jum" ]]; then
echo > /dev/null
else
#iplimit=$(cat /etc/kyt/limit/vmess/ip/${akun})
jum2=$(cat /tmp/ipvmess.txt | wc -l)
#byte=$(cat /etc/vmess/${akun})
#lim=$(con ${byte})
#wey=$(cat /etc/limit/vmess/${akun})
#gb=$(con ${wey})
lastlogin=$(cat /var/log/xray/access.log | grep -w "$akun" | tail -n 500 | cut -d " " -f 2 | tail -1)
echo -e "\033[1;91m┌──────────────────────────────────────┐\033[0m"
printf "  %-13s %-7s %-8s %2s\n" "  UserName : ${akun}"
printf "  %-13s %-7s %-8s %2s\n" "  Online   : $lastlogin"
#printf "  %-13s %-7s %-8s %2s\n" "  Usage Quota : ${gb}"
#printf "  %-13s %-7s %-8s %2s\n" "  Limit Quota : ${lim}"
#printf "  %-13s %-7s %-8s %2s\n" "  Limit IP : $iplimit"
printf "  %-13s %-7s %-8s %2s\n" "  Login IP : $jum2"
echo -e "\033[1;91m└──────────────────────────────────────┘\033[0m"
fi 
rm -rf /tmp/ipvmess.txt
done
rm -rf /tmp/other.txt
echo ""
echo -e "\033[\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e " "
echo -e "\033[0;32mSc Arya Blitar \033[0m "
echo -e ""
read -n 1 -s -r -p "Press any key to back on menu"

menu