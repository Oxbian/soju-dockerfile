FROM alpine

LABEL maintainer="oxbian"

RUN apk add --no-cache go git make scdoc gcc musl-dev

# Installing soju
RUN git clone https://git.sr.ht/~emersion/soju
WORKDIR /soju
RUN make && make install

# Exposing data volume
VOLUME /data

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
