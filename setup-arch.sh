#!/bin/bash

# 1. Pastikan script dijalankan sebagai root
if [ "$EUID" -ne 0 ]; then
  echo "[-] Harap jalankan skrip ini dengan hak akses root (sudo ./setup-arch.sh)"
  exit 1
fi

# 2. Deteksi Package Manager (Multi-Distro Support: Arch vs Debian/Ubuntu)
if command -v pacman &> /dev/null; then
    OS="arch"
elif command -v apt &> /dev/null; then
    OS="debian"
else
    echo "[-] Error: Package manager tidak didukung (hanya mendukung pacman dan apt)."
    exit 1
fi

# Fungsi untuk Update & Install Tools
install_tools() {
    echo "[+] Memperbarui sistem & menginstal tools keamanan..."
    if [ "$OS" == "arch" ]; then
        pacman -Syu --noconfirm
        pacman -S --needed ufw fail2ban curl git openssh --noconfirm
    elif [ "$OS" == "debian" ]; then
        apt update && apt upgrade -y
        apt install -y ufw fail2ban curl git openssh-server
    fi
    echo "[+] Instalasi selesai!"
}

# Fungsi untuk Konfigurasi Firewall UFW
setup_ufw() {
    echo "[+] Mengonfigurasi UFW Firewall..."
    systemctl enable ufw
    systemctl start ufw
    ufw default deny incoming
    ufw default allow outgoing
    ufw allow 22/tcp   # SSH
    ufw allow 80/tcp   # HTTP
    ufw allow 443/tcp  # HTTPS
    ufw --force enable
    echo "[+] UFW Firewall berhasil dikonfigurasi dan diaktifkan."
}

# Fungsi untuk Setup Fail2Ban
setup_fail2ban() {
    echo "[+] Mengaktifkan Fail2Ban..."
    systemctl enable fail2ban
    systemctl start fail2ban
    echo "[+] Fail2Ban aktif dan berjalan."
}

# Fungsi untuk SSH Hardening
setup_ssh() {
    echo "[+] Menerapkan SSH Hardening..."
    SSHD_CONFIG="/etc/ssh/sshd_config"

    if [ -f "$SSHD_CONFIG" ]; then
      cp $SSHD_CONFIG ${SSHD_CONFIG}.bak
      sed -i 's/^#PermitRootLogin.*/PermitRootLogin no/' $SSHD_CONFIG
      sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' $SSHD_CONFIG
      
      if [ "$OS" == "arch" ]; then
          systemctl restart sshd
      else
          systemctl restart ssh
      fi
      echo "[+] SSH Hardening berhasil diterapkan (PermitRootLogin: no)."
    fi
}

# Fungsi untuk Menjalankan Semua Sekaligus (Full Automation)
run_all() {
    install_tools
    setup_ufw
    setup_fail2ban
    setup_ssh
    echo "[========================================================]"
    echo "[+] Semua tahapan Server Hardening Selesai Diterapkan!"
    echo "[========================================================]"
}

# 3. Main Menu (Looping Interactive CLI)
while true; do
    clear
    echo "=============================================="
    echo "   LINUX SERVER HARDENING & AUTOMATION TOOL"
    echo "   Detected OS: $OS"
    echo "=============================================="
    echo "1. Jalankan Semua (Full Hardening & Setup)"
    echo "2. Update Sistem & Install Tools Keamanan"
    echo "3. Konfigurasi UFW Firewall"
    echo "4. Aktifkan Fail2Ban"
    echo "5. Terapkan SSH Hardening (Disable Root Login)"
    echo "6. Keluar (Exit)"
    echo "=============================================="
    read -p "Pilih menu [1-6]: " choice

    case $choice in
        1)
            run_all
            read -p "Tekan [Enter] untuk kembali ke menu..."
            ;;
        2)
            install_tools
            read -p "Tekan [Enter] untuk kembali ke menu..."
            ;;
        3)
            setup_ufw
            read -p "Tekan [Enter] untuk kembali ke menu..."
            ;;
        4)
            setup_fail2ban
            read -p "Tekan [Enter] untuk kembali ke menu..."
            ;;
        5)
            setup_ssh
            read -p "Tekan [Enter] untuk kembali ke menu..."
            ;;
        6)
            echo "Keluar dari skrip. Sampai jumpa!"
            exit 0
            ;;
        *)
            echo "[-] Pilihan tidak valid! Masukkan angka 1 sampai 6."
            sleep 2
            ;;
    esac
done