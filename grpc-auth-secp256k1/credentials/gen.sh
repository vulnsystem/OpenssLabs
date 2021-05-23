rm *.pem
rm *.key
rm *.cert
rm *.req
rm *.srl

# 1. Generate EC private key and self-signed certificate
openssl ecparam -genkey -out ca.key -name secp256k1 
openssl req -x509 -new -key ca.key -out ca.cert -subj "/C=FR/ST=Occitanie/L=Toulouse/O=Tech School/OU=Education/CN=*.techschool.guru/emailAddress=root.guru@gmail.com"

echo "CA's self-signed certificate"
openssl x509 -in ca.cert -noout -text

# 2. Generate web server's private key and certificate signing request (EC)
openssl ecparam -genkey -out server.key -name secp256k1 
openssl req  -key server.key -new -out server.req -subj "/C=FR/ST=Ile de France/L=Paris/O=PC Book/OU=Computer/CN=*.pcbook.com/emailAddress=server@gmail.com"

# 3. Use CA's private key to sign web server's CSR and get back the signed certificate
openssl x509 -req -in server.req -days 60 -CA ca.cert -CAkey ca.key -CAcreateserial -out server.cert -extfile server.ext

echo "Server's signed certificate"
openssl x509 -in server.cert -noout -text

# 4. Generate client's private key and certificate signing request (EC)
openssl ecparam -genkey -out client.key -name secp256k1 
openssl req -key client.key -new  -out client.req -subj "/C=FR/ST=Alsace/L=Strasbourg/O=PC Client/OU=Computer/CN=*.client.com/emailAddress=client@gmail.com"

# 5. Use CA's private key to sign client's CSR and get back the signed certificate
openssl x509 -req -in client.req -days 60 -CA ca.cert -CAkey ca.key -CAcreateserial -out client.cert -extfile client.ext

echo "Client's signed certificate"
openssl x509 -in client.cert -noout -text

# 6. To verify the server certificate aginst by root CA
echo "server's certificate verification"
openssl verify -show_chain -CAfile ca.cert server.cert

# 7. To verify the client certificate aginst by root CA.
echo "client's certificate verification"
openssl verify -show_chain -CAfile ca.cert client.cert
