# Day 03 - Azure Linux Virtual Machine

## Topics Covered

- Azure Virtual Machine
- SSH Authentication
- Ubuntu Administration
- Package Management
- NGINX Installation

---

## Commands Used

```bash
hostname
whoami
sudo apt update
sudo apt upgrade -y
sudo apt install nginx -y
sudo systemctl status nginx
pwd
ls -la
ip addr
df -h
free -h
```

---

## Key Concepts

- SSH is the standard secure method for managing Linux VMs.
- `apt update` refreshes the package list.
- `apt upgrade` installs the latest package versions.
- `systemctl` is used to manage Linux services.
- NGINX is a high-performance web server commonly used to host websites and APIs.

---

## Interview Questions

**Q:** Why do we use SSH instead of RDP for Linux?

**Answer:** SSH is a secure command-line protocol for remotely managing Linux systems.

**Q:** What is NGINX?

**Answer:** NGINX is a web server and reverse proxy used to serve web applications and static content.

---

## Hands-on Completed

- Created Ubuntu VM
- Connected via SSH
- Updated packages
- Installed NGINX