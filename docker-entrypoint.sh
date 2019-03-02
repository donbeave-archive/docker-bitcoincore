#!/bin/bash
set -e

NETWORK="${NETWORK:=mainnet}"

# This shouldn't be in the Dockerfile or containers built from the same image
# will have the same credentials.
if [ ! -e "/data/bitcoin.conf" ]; then
    mkdir -p /data

    echo "Creating bitcoin.conf"

    # Seed a random password for JSON RPC server
    cat <<EOF > /data/bitcoin.conf
datadir=/data/
txindex=1
server=1
rest=1
rpcuser=${RPCUSER:-bitcoinrpc}
rpcpassword=${RPCPASSWORD:-`dd if=/dev/urandom bs=33 count=1 2>/dev/null | base64`}
rpcallowip=::/0
EOF

	case "$NETWORK" in
		mainnet)
	    	echo "Connect to mainnet"
	        ;;
	         
	    testnet)
	    	echo "Connect to testnet"
	    	echo "testnet=1" >> /data/bitcoin.conf
	        ;;

	    regtest)
	    	echo "Use regtest mode"
	    	echo "regtest=1" >> /data/bitcoin.conf
	        ;;

	    *)
			echo "ERROR: Network is wrong"
			echo $NETWORK
	        exit 1
	esac

	chmod 600 /data/bitcoin.conf
	chown bitcoin:bitcoin /data/bitcoin.conf

	mkdir -p /root/.bitcoin
	mkdir -p /home/bitcoin/.bitcoin

	chown bitcoin:bitcoin /root/.bitcoin
	chown bitcoin:bitcoin /home/bitcoin/.bitcoin

	ln -s /data/bitcoin.conf /root/.bitcoin/bitcoin.conf
	ln -s /data/bitcoin.conf /home/bitcoin/.bitcoin/bitcoin.conf
fi

chown -R bitcoin:bitcoin /data

cat /data/bitcoin.conf

cp /data/bitcoin.conf /root/.bitcoin/bitcoin.conf

echo "Initialization completed successfully"

if [ "$1" = "bitcoind" ] || [ "$1" = "bitcoin-cli" ] || [ "$1" = "bitcoin-tx" ]; then
  echo
  exec gosu bitcoin:bitcoin "$@"
fi

exec "$@"
