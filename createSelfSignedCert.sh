# generate 2048-bit RSA priv key
openssl genrsa -out key.pem 2048

# generate signing request to be use for CA-signed cert
openssl req -new -sha256 -key key.pem -out csr.csr

# create self-signed x509 cert to be used on Web server
openssl req -x509 -sha256 -days 365 -key key.pem -in csr.csr -out certificate.pem

# verify that you can use cert pass 2017
openssl req -in csr.csr -text -noout \
| grep -i "Signature.*SHA256" && echo "All is well" \
|| echo "This certificate will stop working in 2017! You must update OpenSSL to generate a widely-compatible certificate"
