# USER_DOC — User Documentation

## What services does this stack provide?

| Service   | Role                                      | Port            |
|-----------|-------------------------------------------|-----------------|
| NGINX     | Reverse proxy, HTTPS entrypoint (TLSv1.3) | 443             |
| WordPress | CMS website + PHP-FPM backend             | 9000 (internal) |
| MariaDB   | MySQL-compatible relational database      | 3306 (internal) |

All traffic enters through NGINX on port 443. Internal services are not directly accessible from outside.

## Starting and stopping the stack

```bash
make          # Build and start everything
make down     # Stop containers (keeps data)
make start    # Start already-built containers
make stop     # Stop without removing
```

## Accessing the website

- **Public site**: `https://mysite.local`
- **Admin panel**: `https://mysite.local/wp-admin`

> Accept the browser warning for the self-signed SSL certificate.

## Credentials

All passwords are stored in the `secrets/` folder (not in git):

| File                          | Contains                       |
|-------------------------------|--------------------------------|
| `secrets/db_password.txt`     | MariaDB user (wpuser) password |
| `secrets/db_root_password.txt`| MariaDB root password          |
| `secrets/credentials.txt`     | WordPress admin password       |

WordPress admin username: defined in your `.env` file

## Checking that services are running

```bash
make ps              # See all container statuses
make logs            # Follow live logs
docker logs nginx    # Check a specific container
docker logs wordpress
docker logs mariadb
```

All containers should show status `Up`.
