# Arch Linux Server Hardening

A Bash automation script designed for initial configuration, security hardening, and basic utility installation on **Arch Linux** systems. This project is built to streamline and standardize server security quickly and efficiently.

## Key Features
- **Multi-Distro Support**: Automatically detects the system package manager (`pacman` for Arch Linux or `apt` for Debian/Ubuntu) and handles updates accordingly.
- **System Update & Upgrade**: Automatically updates all system packages to the latest version.
- **UFW Firewall Configuration**: Blocks all incoming traffic (*deny incoming*) except for essential ports (SSH, HTTP, HTTPS) and automatically enables the UFW service via `systemd`.
- **Fail2Ban Integration**: Protects SSH services against brute-force attacks with a responsive local jail configuration.
- **SSH Hardening**: Enhances remote access security by automatically disabling direct root logins (`PermitRootLogin no`).
- **Automated Service Management**: Enables and starts security daemons directly through `systemctl`.

## Usage Instructions

### 1. Clone this repository to your server or target machine:
   ```bash
   git clone [https://github.com/YOUR-USERNAME/linux-server-hardening.git](https://github.com/YOUR-USERNAME/linux-server-hardening.git)
   cd linux-server-hardening
```
### 2. Grant execution permissions to the script:
```bash
chmod +x setup-arch.sh
```
### 3. Run the script with `sudo` privileges:
```bash
sudo ./setup-arch.sh
```

---

## Tech Stack & Architecture

- **Language:** Bash Scripting
- **Os Target:** Arch Linux, Debian, Ubuntu
- **Tools:** `pacman, ufw, fail2ban, systemd, openssh`

## Security Verification

### 1. Check UFW Firewall Status:
   ```bash
   sudo ufw status verbose
```
### 2. Check Fail2Ban & SSH Jail Status:
```bash
sudo fail2ban-client status
sudo fail2ban-client status sshd
```

### 2. Check SSH Hardening Configuration:
```bash
sudo grep -i "PermitRootLogin" /etc/ssh/sshd_config
```



