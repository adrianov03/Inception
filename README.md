# Inception

A fully containerized web infrastructure built from scratch using Docker and Docker Compose, as a hands-on deep dive into container orchestration, reverse proxying, and service isolation.

![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat&logo=docker&logoColor=white)
![Nginx](https://img.shields.io/badge/Nginx-009639?style=flat&logo=nginx&logoColor=white)
![WordPress](https://img.shields.io/badge/WordPress-21759B?style=flat&logo=wordpress&logoColor=white)
![MariaDB](https://img.shields.io/badge/MariaDB-003545?style=flat&logo=mariadb&logoColor=white)
![Debian](https://img.shields.io/badge/Debian-A81D33?style=flat&logo=debian&logoColor=white)

## Overview

The stack runs three services, each in its own container built on `debian:bookworm` — no pre-built application images from DockerHub. All traffic enters through NGINX on port 443; internal services communicate over a private Docker bridge network.

```
                        ┌─────────────────────────────────────┐
                        │           Docker Network             │
  HTTPS :443            │                                      │
  ──────────────────► NGINX ──── FastCGI :9000 ──► WordPress  │
                        │    (reverse proxy / TLS)  (PHP-FPM) │
                        │                               │      │
                        │                          MySQL :3306 │
                        │                               ▼      │
                        │                            MariaDB   │
                        │                                      │
                        └─────────────────────────────────────┘
                              wordpress vol    mariadb vol
                              (persistent)     (persistent)
```

## Stack

| Service   | Image base       | Role                              |
|-----------|------------------|-----------------------------------|
| NGINX     | debian:bookworm  | Reverse proxy, TLS termination    |
| WordPress | debian:bookworm  | CMS + PHP-FPM 8.2 backend         |
| MariaDB   | debian:bookworm  | Relational database               |

## Setup

### Prerequisites

- Debian-based Linux (or a VM running Debian)
- Docker Engine and Docker Compose plugin
- `make`, `sudo`, `openssl`

### Installation

1. Clone the repository:
   ```bash
   git clone git@github.com:adrianov03/Inception.git
   cd Inception
   ```

2. Create the secrets files:
   ```bash
   echo "your_db_password"   > secrets/db_password.txt
   echo "your_root_password" > secrets/db_root_password.txt
   echo "your_wp_password"   > secrets/credentials.txt
   ```

3. Create `srcs/.env`:
   ```
   DOMAIN_NAME=mysite.local
   MYSQL_DATABASE=wordpress
   MYSQL_USER=wpuser
   MYSQL_PASSWORD=your_db_password
   MYSQL_ROOT_PASSWORD=your_root_password
   WP_TITLE=My Site
   WP_ADMIN_USER=admin
   WP_ADMIN_EMAIL=admin@mysite.local
   WP_USER=visitor
   WP_USER_EMAIL=visitor@mysite.local
   DATA_PATH=/home/youruser/data
   ```

4. Add the domain to your hosts file and launch:
   ```bash
   make
   ```

### Useful commands

```bash
make logs    # Follow container logs
make ps      # Show running containers
make down    # Stop containers (data preserved)
make fclean  # Full cleanup including volume data
make re      # Rebuild everything from scratch
```

## Design Decisions

**Secrets over environment variables**  
Environment variables can be leaked via `docker inspect`. Docker secrets mount sensitive data as files at `/run/secrets/` inside the container — passwords never appear in the process environment.

**Custom bridge network over host network**  
`network: host` exposes containers directly on the host's network stack with no isolation. A named bridge network (`inception`) lets containers reach each other by service name while remaining completely isolated from the outside.

**Docker volumes with bind mounts**  
Volumes declared with `driver_opts: type: none, o: bind` combine the explicitness of Docker volume management with the predictability of bind mounts — data persists on the host at a known path and survives container rebuilds.

**No pre-built application images**  
Each service is built from `debian:bookworm` with only the packages it needs. This forces a clear understanding of what each service actually requires and avoids inheriting unknown configurations from third-party images.

## What I Learned

- How Docker networking isolates services and enables inter-container communication by hostname
- Managing sensitive configuration through Docker secrets instead of environment variables
- Writing and debugging entrypoint scripts that handle first-run initialization vs. restarts
- Configuring PHP-FPM as a FastCGI backend and wiring it through NGINX
- TLS certificate generation with OpenSSL and NGINX HTTPS configuration

## Resources

- [Docker documentation](https://docs.docker.com/)
- [Docker Compose reference](https://docs.docker.com/compose/)
- [NGINX TLS configuration](https://nginx.org/en/docs/http/configuring_https_servers.html)
- [WordPress CLI](https://wp-cli.org/)
- [PHP-FPM configuration](https://www.php.net/manual/en/install.fpm.configuration.php)
- [PID 1 and Docker best practices](https://cloud.google.com/architecture/best-practices-for-building-containers)
