![CI Testing](https://github.com/Alif-fiansyah/linux-server-hardening/actions/workflows/ci.yml/badge.svg)

# Linux Server Hardening

An advanced, menu-driven Bash automation script designed for initial configuration, multi-distro package management, security hardening, and basic utility installation on Linux systems (**Arch Linux** & **Debian/Ubuntu**). This project is built to streamline and standardize server security quickly and efficiently, ideal for infrastructure automation portfolios.

## Key Features
- **Interactive Menu-Driven CLI**: A user-friendly, text-based navigation interface allowing you to run specific tasks or execute full automation effortlessly.
- **Multi-Distro Support**: Automatically detects the underlying system package manager (`pacman` for Arch Linux or `apt` for Debian/Ubuntu) and handles updates accordingly.
- **System Update & Upgrade**: Automatically updates all system packages to the latest secure version.
- **UFW Firewall Configuration**: Blocks all incoming traffic (*deny incoming*) except for essential ports (SSH, HTTP, HTTPS) and automatically enables the UFW service via `systemd`.
- **Fail2Ban Integration**: Protects SSH services against brute-force attacks with a responsive local jail configuration.
- **SSH Hardening**: Enhances remote access security by automatically disabling direct root logins (`PermitRootLogin no`).
- **Automated Configuration Backup**: Safely archives critical server configurations (`/etc/ssh/sshd_config`, `/etc/ufw/`, etc.) into a compressed `.tar.gz` file with unique timestamp naming.
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

### 🐳 Docker Testing 
You can safely test this automation script inside an isolated Docker container without affecting your host system:
### 1. Build the Docker image:
   ```bash
   docker build -t linux-hardening-test .
```
### 2. Run the container interactively:
```bash
docker run -it linux-hardening-test
```

### 3. Execute the script inside the container:
```bash
./setup-arch.sh
```


---

## Tech Stack & Architecture

- **Language:** Bash Scripting
- **Os Target:** Arch Linux, Debian, Ubuntu
- **Containerization:** Docker & Makefile
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

### 3. Check SSH Hardening Configuration:
```bash
sudo grep -i "PermitRootLogin" /etc/ssh/sshd_config
```



