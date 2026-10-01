#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "[-] Harap jalankan skrip ini dengan hak akses root (sudo ./setup-arch.sh)"
  exit 1
fi

echo "[+] Memulai Server Hardening & Setup untuk Arch Linux..."
pacman -Syu --noconfirm
pacman -S --needed ufw fail2ban curl git --noconfirm

systemctl enable ufw
systemctl start ufw
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw --force enable

systemctl enable fail2ban
systemctl start fail2ban

echo "[+] Selesai!"
