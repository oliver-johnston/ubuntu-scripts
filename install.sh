#!/bin/bash

# install restic
sudo apt install restic -y

# save restic password to password file
mkdir ~/.restic
echo "Enter password for restic backup then press [ENTER]: "
read -s restic_password

echo "Enter B2 Account ID then press [ENTER]: "
read b2_account_id

echo "Enter B2 Account Key then press [ENTER]: "
read -s b2_account_key

echo "RESTIC_PASSWORD=$restic_password" > ~/.crontab
echo "B2_ACCOUNT_ID=$b2_account_id" >> ~/.crontab
echo "B2_ACCOUNT_KEY=$b2_account_key" >> ~/.crontab
echo "0 2 * * * restic -r /media/oliver/backup backup /media/oliver/data" >> ~/.crontab
echo "0 3 * * * restic -r b2:JohnstonBackup backup /media/oliver/data" >> ~/.crontab

# save existing crontab and copy new file
crontab -l > ./crontab.backup
crontab < ~/.crontab



# setup file shares
sudo apt install samba -y

echo "Samba User: "
read samba_user

sudo smbpasswd -a $samba_user
sudo cp /etc/samba/smb.conf .

echo "[data]
path = /media/oliver/data
available = yes
valid users = $samba_user
read only = no
browsable = yes
public = yes
writable = yes" | sudo tee -a /etc/samba/smb.conf

sudo /etc/init.d/smbd restart
sudo testparm
