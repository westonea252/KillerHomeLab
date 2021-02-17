sudo apt -y update

sudo tee -a /etc/apt/sources.list <<EOF
deb http://us.archive.ubuntu.com/ubuntu/ bionic universe
deb http://us.archive.ubuntu.com/ubuntu/ bionic-updates universe
EOF

sudo hostnamectl set-hostname khl-kf-01.dir.ad.killerhomelab.com

sudo systemctl disable systemd-resolved
sudo systemctl stop systemd-resolved

sudo apt update
sudo apt -y install realmd libnss-sss libpam-sss sssd sssd-tools adcli samba-common-bin oddjob oddjob-mkhomedir packagekit