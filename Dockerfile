FROM alpine

LABEL maintainer="oxbian"

RUN apk add --no-cache go git make scdoc gcc

# Installing soju
RUN git clone https://git.sr.ht/~emersion/soju
WORKDIR /soju
RUN make && make install

# Exposing data volume
VOLUME /data

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]
