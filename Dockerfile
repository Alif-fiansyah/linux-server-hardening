# Menggunakan base image Ubuntu (mendukung multi-distro 'apt' di skrip kita)
FROM ubuntu:latest

# Mencegah prompt interaktif saat instalasi paket
ENV DEBIAN_FRONTEND=noninteractive

# Update sistem dan instal bash serta systemd simulation/tools yang dibutuhkan
RUN apt update && apt install -y \
    bash \
    systemd \
    sudo \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Buat direktori kerja di dalam kontainer
WORKDIR /app

# Salin seluruh file proyek kita ke dalam kontainer
COPY . /app

# Berikan izin eksekusi pada skrip utama
RUN chmod +x setup-arch.sh

# Perintah default saat kontainer dijalankan (masuk ke mode interactive bash)
CMD ["/bin/bash"]