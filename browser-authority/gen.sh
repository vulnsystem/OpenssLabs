######################
# Become a Certificate Authority
######################
rm *.key
rm *.pem
rm *.srl
rm *.ext
rm *.crt
rm *.csr

# Generate private key
openssl genrsa -des3 -out ca.key 2048
# Generate root certificate
openssl req -x509 -new -key ca.key -sha256 -days 825 -out ca.cert -subj "/C=FR/ST=Occitanie/O=RootCA/emailAddress=ca@gmail.com"

######################
# Create CA-signed certs
######################

NAME=server # Use your own domain name
# Generate a private key
openssl genrsa -out $NAME.key 2048
# Create a certificate-signing request
openssl req -new -key $NAME.key -out $NAME.csr -subj "/C=FR/ST=Occitanie/O=ServerCA/emailAddress=server@gmail.com"
# Create a config file for the extensions
>$NAME.ext cat <<-EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = $NAME # Be sure to include the domain name here because Common Name is not so commonly honoured by itself
DNS.2 = localhost # Optionally, add additional domains (I've added a subdomain here)
IP.1 = 0.0.0.0  # Optionally, add an IP address (if the connection which you have planned requires it)
EOF

# Create the signed certificate
openssl x509 -req -in $NAME.csr -CA ca.cert -CAkey ca.key -CAcreateserial \
-out $NAME.cert -days 825 -sha256 -extfile $NAME.ext
