#!/bin/sh
set -e

VOLUME="/data"
CONFIG="$volume/soju.conf"

[ -f "$CONFIG" ] && printf "A configuration file already exist, if you want to reconfigure please edit manually or delete this file\n" && exit 1
[ -z "$ADMIN" ] && printf "Please setup admin username with the environment variable ADMIN\n" && exit 1
[ -z "$PASSWORD" ] && printf "Please setup admin password with the environment variable PASSWORD\n" && exit 1

if [ -z "$LISTEN_PROTOCOL" ]; then
	printf "Please setup the listening protocol with the environment variable LISTEN_PROTOCOL\n"
   	printf "See https://git.sr.ht/~emersion/soju/tree/master/item/doc/soju.1.scd#L81 for a list of accepted protocols.\n"
	exit 1
fi

if [ -z "$LISTEN_HOST" ]; then
	printf "Listening host is undefined, if you want to use a specific host, use the environment variable LISTEN_HOST\n"
	printf "Default host: 0.0.0.0 (recommanded for docker)\n"
	LISTEN_HOST="0.0.0.0"
fi

if [ -z "$LISTEN_PORT" ]; then
	printf "Listening port is undefined, if you want to use a specific port, use the environment variable LISTEN_PORT\n"
	printf "Default port: 6667 (unsecured IRC communication)\n"
	LISTEN_PORT="6667"
fi


echo "listen $LISTEN_PROTOCOL://$LISTEN_HOST:$LISTEN_PORT" >> "$CONFIG"

if [ -e "$VOLUME/soju.db" ] || ([ -z "$DB_TYPE"] && [ -z "$DB_SOURCE" ]); then
	printf "%s" "$PASSWORD"	| sojuctl -config "$CONFIG" create-user "$ADMIN" -admin
	if [ -z "$DB_TYPE" ]; then
		echo "db $DB_TYPE $DB_SOURCE" >> "$CONFIG"
	else
		echo "db sqlite3 $VOLUME/soju.db" >> "$CONFIG"
	fi
fi

if [ -z "$TLS_CRT" ] && [ -z "$TLS_KEY" ] && [ -e "$TLS_CRT" ] && [ -e "$TLS_KEY" ]; then
	echo "tls $TLS_CRT $TLS_KEY" >> "$CONFIG"
fi

[ -z "$HOSTNAME" ] && echo "hostname $HOSTNAME" >> "$CONFIG"
[ -z "$TITLE" ] && echo "title $TITLE" >> "$CONFIG"
[ -z "$LOG_TYPE" ] && [ -z "$LOG_SOURCE" ] && echo "message-store $LOG_TYPE $LOG_SOURCE" >> "$CONFIG"
[ -z "$FILEUP_TYPE" ] && [ -z "$FILEUP_SOURCE" ] && echo "file-upload $FILEUP_TYPE $FILEUP_SOURCE" >> "$CONFIG"
[ -z "$MOTD" ] && echo "motd $MOTD" >> "$CONFIG"

cd $VOLUME && soju -config $CONFIG

