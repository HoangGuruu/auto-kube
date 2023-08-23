#!/bin/sh

# Get the proxy cert
envoy_ln=$(cat playbooks/vars.yaml | grep -n '  envoy:' | cut -d ':' -f 1)
envoy_domain=$(tail -n +$envoy_ln playbooks/vars.yaml | grep 'domain:' | head -1 | sed -E "s/[ $(echo -e '\t')]*domain: (.*)/\1/")
openssl s_client -connect $envoy_domain:443 < /dev/null 2> /dev/null | \
sed -En '/^-----BEGIN CERTIFICATE-----$/,/^-----END CERTIFICATE-----$/p' > envoy.crt

# Adopt the cert
sudo cp envoy.crt /usr/local/share/ca-certificates/
sudo update-ca-certificates

