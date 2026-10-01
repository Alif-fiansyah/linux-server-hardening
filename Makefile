IMAGE_NAME = linux-hardening-test
CONTAINER_NAME = hardening-container

.PHONY: help build run clean

# Menampilkan bantuan perintah yang tersedia
help:
	@echo "=================================================="
	@echo " Makefile Commands for Linux Server Hardening"
	@echo "=================================================="
	@echo "  make build   - Build the Docker testing image"
	@echo "  make run     - Run the container in interactive mode"
	@echo "  make clean   - Remove the Docker image and containers"
	@echo "=================================================="

# Build Docker image
build:
	@echo "[+] Building Docker image ($(IMAGE_NAME))..."
	docker build -t $(IMAGE_NAME) .

# Run Docker container interactively
run:
	@echo "[+] Starting interactive container..."
	docker run --name $(CONTAINER_NAME) -it $(IMAGE_NAME)

# Clean up Docker images and stopped containers
clean:
	@echo "[-] Cleaning up Docker containers and images..."
	-docker rm -f $(CONTAINER_NAME) 2>/dev/null || true
	-docker rmi -f $(IMAGE_NAME) 2>/dev/null || true
	@echo "[+] Cleanup completed!"