FROM alpine

LABEL maintainer="oxbian"

RUN apk add --no-cache go git make scdoc

# Installing soju
RUN git clone https://git.sr.ht/~emersion/soju
WORKDIR /soju
RUN make && make install

COPY --from=0 /soju/soju /usr/local/bin/
COPY --from=0 /soju/sojuctl /usr/local/bin/

# Exposing data volume
VOLUME /data

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]
