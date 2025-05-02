#!/bin/bash
NC='\033[0;37m'
green='\033[0;32m'

clear
echo ""
sleep 1
echo -e "[ ${green}INFO${NC} ] Checking... "
sleep 2
sleep 1
echo -e "[ ${green}INFO${NC} ] Download & Install rclone... "
curl -fsSL https://rclone.org/install.sh | bash > /dev/null 2>&1
printf "q\n" | rclone config > /dev/null 2>&1
sleep 1
echo -e "[ ${green}INFO${NC} ] Downloading rclone config ... "
wget -q -O /root/.config/rclone/rclone.conf "https://raw.githubusercontent.com/kipas77pro/tunel/main/backup/rclone.conf"
git clone https://github.com/magnific0/wondershaper.git &> /dev/null
cd wondershaper
sleep 1
echo -e "[ ${green}INFO${NC} ] Installing wondershaper... "
make install > /dev/null 2>&1
cd
rm -rf wondershaper > /dev/null 2>&1
echo > /home/limit

pkgs='msmtp-mta ca-certificates bsd-mailx'
if ! dpkg -s $pkgs > /dev/null 2>&1; then
sleep 1
echo -e "[ ${green}INFO${NC} ] Installing... "
apt install -y $pkgs > /dev/null 2>&1
else
sleep 1
echo -e "[ ${green}INFO${NC} ] Already Installed... "
fi
sleep 1
echo -e "[ ${green}INFO${NC} ] Creating service... "
sleep 1
echo -e "[ ${green}INFO${NC} ] Downloading files... "
wget -q -O /usr/bin/backup "https://raw.githubusercontent.com/kipas77pro/tunel/main/ssh/backup.sh" && chmod +x /usr/bin/backup
wget -q -O /usr/bin/restore "https://raw.githubusercontent.com/kipas77pro/tunel/main/ssh/restore.sh" && chmod +x /usr/bin/restore
wget -q -O /usr/bin/cleaner "https://raw.githubusercontent.com/kipas77pro/tunel/main/backup/cleaner.sh" && chmod +x /usr/bin/cleaner
wget -q -O /usr/bin/autobackup "https://raw.githubusercontent.com/kipas77pro/tunel/main/backup/autobackup.sh" && chmod +x /usr/bin/autobackup

service cron restart > /dev/null 2>&1

rm -f /root/set-br.sh
