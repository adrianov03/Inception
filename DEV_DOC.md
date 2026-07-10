# DEV_DOC — Developer Documentation

## Setting up the environment from scratch

### Requirements

- Debian Linux Virtual Machine
- Docker Engine: https://docs.docker.com/engine/install/debian/
- Docker Compose plugin (included with Docker Engine v2+)
- `make`, `sudo`, `openssl`

### Configuration files (not in git)

After cloning, create these files manually:

**`secrets/db_password.txt`** — MariaDB user password
**`secrets/db_root_password.txt`** — MariaDB root password
**`secrets/credentials.txt`** — WordPress admin password

**`srcs/.env`**:
```
DOMAIN_NAME=yourusername.42.fr
MYSQL_DATABASE=wordpress
MYSQL_USER=wpuser
MYSQL_PASSWORD=your_password
MYSQL_ROOT_PASSWORD=your_root_password
WP_TITLE=My Inception Site
WP_ADMIN_USER=admin
WP_ADMIN_EMAIL=admin@yourusername.42.fr
WP_USER=visitor
WP_USER_EMAIL=visitor@yourusername.42.fr
DATA_PATH=/home/youruser/data
```

## Building and launching

```bash
make          # Full build + launch
make up       # Launch only (images already built)
make down     # Stop and remove containers (volumes kept)
make re       # Rebuild from scratch
```

## Managing containers and volumes

```bash
# Shell into a container
docker exec -it nginx bash
docker exec -it wordpress bash
docker exec -it mariadb bash

# MySQL prompt
docker exec -it mariadb mysql -u root -p

# View logs
docker logs -f wordpress

# Remove all containers and images (keeps volume data)
make clean

# Remove everything including volume data
make fclean
```

## Data storage and persistence

| Data            | Location on host                  | Volume name    |
|-----------------|-----------------------------------|----------------|
| WordPress files | `/home/youruser/data/wordpress`   | `srcs_wordpress` |
| MariaDB database| `/home/youruser/data/mariadb`     | `srcs_mariadb`   |

Data persists between container restarts. Only `make fclean` removes it.

## Directory structure

```
inception/
├── Makefile
├── README.md
├── USER_DOC.md
├── DEV_DOC.md
├── .gitignore
├── secrets/              ← NOT in git
│   ├── credentials.txt
│   ├── db_password.txt
│   └── db_root_password.txt
└── srcs/
    ├── .env              ← NOT in git
    ├── docker-compose.yml
    └── requirements/
        ├── nginx/
        │   ├── Dockerfile
        │   ├── conf/nginx.conf
        │   └── tools/docker-entrypoint.sh
        ├── wordpress/
        │   ├── Dockerfile
        │   ├── conf/www.conf
        │   └── tools/docker-entrypoint.sh
        └── mariadb/
            ├── Dockerfile
            ├── conf/my.cnf
            └── tools/docker-entrypoint.sh
```
