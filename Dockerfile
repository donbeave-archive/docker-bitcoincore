FROM debian:stretch-slim

MAINTAINER Alexey Zhokhov <alexey@zhokhov.com>

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r bitcoin && useradd -g bitcoin -d /home/bitcoin -m -r bitcoin

ENV DEBIAN_FRONTEND noninteractive

# Update apt-get
RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
               wget \
               ca-certificates \
               curl \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/* /var/cache/apt/* /tmp/*

ENV GOSU_VERSION=1.10

RUN curl -o /usr/local/bin/gosu -fSL https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture) \
  && chmod +x /usr/local/bin/gosu

ENV BITCOIN_VERSION=0.15.1

RUN wget --no-cookies "https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/bitcoin-${BITCOIN_VERSION}-x86_64-linux-gnu.tar.gz" \
    && tar -xzvf bitcoin-${BITCOIN_VERSION}-x86_64-linux-gnu.tar.gz \
    && mv bitcoin-${BITCOIN_VERSION}/bin/* /usr/local/bin/ \
    && mv bitcoin-${BITCOIN_VERSION}/include/* /usr/local/include/ \
    && mv bitcoin-${BITCOIN_VERSION}/lib/* /usr/local/lib/ \
    && mv bitcoin-${BITCOIN_VERSION}/share/* /usr/local/share/ \
    && rm -r bitcoin-${BITCOIN_VERSION} bitcoin-${BITCOIN_VERSION}-x86_64-linux-gnu.tar.gz

RUN mkdir /data \
    && chown bitcoin:bitcoin /data

VOLUME /data

WORKDIR /data

COPY docker-entrypoint.sh /
RUN chmod a+x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["bitcoind", "-conf=/data/bitcoin.conf", "-datadir=/data", "-printtoconsole"]