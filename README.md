# Soju docker
---

[![Build](https://github.com/Oxbian/soju-dockerfile/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/Oxbian/soju-dockerfile/actions/workflows/docker-publish.yml)
[![License: AGPL v3](https://img.shields.io/badge/License-AGPL_v3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)

[Soju](https://git.sr.ht/~emersion/soju/) is an IRC bouncer used by projects like sourcehut, for their chat.

## Installation

To install and use this Dockerfile, just pull it and run it.

```sh
docker pull  
```

## Configuration

It's recommanded to use TLS for communication, you can use these commands to generate the certificate and private key

```sh
openssl req -nodes -newkey rsa:4096 -keyout soju.key -x509 -days 3650 -out soju.crt
chmod 400 soju.key
cat soju.crt soju.key > soju.pem
chmod 400 soju.pem
```

### Environment variables

- **CONFIG**: soju configuration filepath
- **ADMIN**: admin username
- **PASSWORD**: admin password (use a strong password)
- **LISTEN_PROTOCOL**: protocol used for soju connection [list here](https://git.sr.ht/~emersion/soju/tree/master/item/doc/soju.1.scd#L81)
- **LISTEN_HOST**: host ip that soju will listen
- **LISTEN_PORT**: port that soju will listen

*Optionals*
- **DB_TYPE**: database type (sqlite3 or postgres)
- **DB_SOURCE**: database filepath or login (db) [more info here](https://git.sr.ht/~emersion/soju/tree/master/item/doc/soju.1.scd#L128)

- **TLS_CRT**: filepath to the tls certificate
- **TLS_KEY**: filepath to the tls key

- **HOSTNAME**: server hostname

- **TITLE**: title for the IRC server when user hasn't specify a network yet

- **LOG_TYPE**: log format (db, memory, file...) [list here](https://git.sr.ht/~emersion/soju/tree/master/item/doc/soju.1.scd#L141)
- **LOG_SOURCE**: log filepath or login (db)

- **FILEUP_TYPE**: file uploader type (https, http+insecure, fs) [list here](https://git.sr.ht/~emersion/soju/tree/master/item/doc/soju.1.scd#L160)
- **FILEUP_SOURCE**: url or filepath

- **MOTD**: motd filepath

### Run the image from the CLI

```sh
docker run -e CONFIG='PATH_TO_CONFIG' -e ADMIN='admin' -e PASSWORD='complicatedpassword' -e LISTEN_PROTOCOL='PROTOCOL' -e LISTEN_HOST='0.0.0.0' -e LISTEN_PORT='6667' oxbian/soju
```

### Run the image from docker compose

```yaml
version: "3.7"
services:
  soju:
    image: oxbian/soju:latest
    container_name: soju
    volumes:
      - PATH_TO_SOJU/data:/data
    ports:
      - "6667:6667"
    environment:
      - USER=admin
      - PASSWORD=complicatedpassword
      - LISTEN_PROTOCOL=PROTOCOL
      - LISTEN_HOST=0.0.0.0
      - LISTEN_PORT=6667
    restart: unless-stopped
```

## License

This project is under AGPL_v3, so you are free to use it, clone it, copy it, but any modification made on this Dockerfile or scripts needs to be pull request. It's not a contraint, it helps the Dockerfile to be better.

