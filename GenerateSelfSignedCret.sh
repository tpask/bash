#sample script to generate self signed cert
  
function genCert {
# Set our CSR variables
  SSL_DIR="/etc/ssl/private"
  certName="selfSignedCert"
  certDir="/etc/ssl/certs"
  DOMAIN="*.myDomain.com"
  PASSPHRASE=""
  
SUBJ="
C=US
ST=myState
O=myOrg
localityName=myCity
commonName=$DOMAIN
organizationalUnitName=myOrg
emailAddress=myEmailAddr
"
mkdir -p "$SSL_DIR"

# Generate our Private Key, CSR and Certificate
openssl genrsa -out "$SSL_DIR/$certName.key" 2048
openssl req -new -subj "$(echo -n "$SUBJ" | tr "\n" "/")" -key "$SSL_DIR/$certName.key" -out "$SSL_DIR/$certName.csr" -passin pass:$PASSPHRASE
openssl x509 -req -days 365 -in "$SSL_DIR/$certName.csr" -signkey "$SSL_DIR/$certName.key" -out $certDir/$certName.crt
openssl dhparam -out $certDir/$certName.pem 2048                                                            
}

##
genCert
