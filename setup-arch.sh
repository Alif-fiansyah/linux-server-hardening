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

# Direktori penyimpanan hasil backup
BACKUP_DIR="/var/backups/server-hardening"

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

# Fungsi Baru: Backup Konfigurasi Kritis
backup_config() {
    echo "[+] Memulai proses Backup Konfigurasi Server..."
    
    # Buat direktori backup jika belum ada
    mkdir -p "$BACKUP_DIR"
    
    # Buat nama file berdasarkan tanggal & waktu (timestamp)
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    BACKUP_FILE="$BACKUP_DIR/config_backup_$TIMESTAMP.tar.gz"
    
    # Arsipkan file konfigurasi penting (SSH, UFW, Fail2Ban jika ada)
    tar -czf "$BACKUP_FILE" \
        /etc/ssh/sshd_config \
        /etc/ufw/ \
        /etc/fail2ban/jail.conf 2>/dev/null
        
    if [ $? -eq 0 ]; then
        echo "[+] Backup berhasil disimpan di: $BACKUP_FILE"
    else
        echo "[-] Terjadi kesalahan atau beberapa file konfigurasi belum tersedia untuk di-backup."
    fi
}

# Fungsi untuk Menjalankan Semua Sekaligus (Full Automation)
run_all() {
    install_tools
    setup_ufw
    setup_fail2ban
    setup_ssh
    backup_config
    echo "[========================================================]"
    echo "[+] Semua tahapan Server Hardening & Backup Selesai!"
    echo "[========================================================]"
}

# 3. Main Menu (Looping Interactive CLI)
while true; do
    clear
    echo "=============================================="
    echo "   LINUX SERVER HARDENING & AUTOMATION TOOL"
    echo "   Detected OS: $OS"
    echo "=============================================="
    echo "1. Jalankan Semua (Full Hardening + Backup)"
    echo "2. Update Sistem & Install Tools Keamanan"
    echo "3. Konfigurasi UFW Firewall"
    echo "4. Aktifkan Fail2Ban"
    echo "5. Terapkan SSH Hardening (Disable Root Login)"
    echo "6. Backup Konfigurasi Server (.tar.gz)"
    echo "7. Keluar (Exit)"
    echo "=============================================="
    read -p "Pilih menu [1-7]: " choice

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
            backup_config
            read -p "Tekan [Enter] untuk kembali ke menu..."
            ;;
        7)
            echo "Keluar dari skrip. Sampai jumpa!"
            exit 0
            ;;
        *)
            echo "[-] Pilihan tidak valid! Masukkan angka 1 sampai 7."
            sleep 2
            ;;
    esac
done