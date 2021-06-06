rm *.pem
rm *.key
rm *.cert
rm *.req
rm *.srl

# 1. Generate server CA's private key and self-signed certificate
openssl req -x509 -newkey rsa:4096 -days 365 -nodes -keyout ca.key -out ca.cert -subj "/CN=localhost/emailAddress=ca@gmail.com" 

echo "CA's self-signed certificate"
openssl x509 -in ca.cert -noout -text

# 2. Generate web server's private key and certificate signing request (CSR)
openssl req -newkey rsa:4096 -nodes -keyout server.key -out server.req -subj "/CN=localhost/emailAddress=server@gmail.com"

# 3. Use CA's private key to sign web server's CSR and get back the signed certificate
openssl x509 -req -in server.req -days 60 -CA ca.cert -CAkey ca.key -CAcreateserial -out server.cert -extfile server.ext

echo "Server's signed certificate"
openssl x509 -in server.cert -noout -text

# 4. To verify the server certificate aginst by root CA
echo "server's certificate verification"
openssl verify -show_chain -CAfile ca.cert server.cert

# 5. Generate web client's private key and certificate signing request (CSR)
openssl req -newkey rsa:4096 -nodes -keyout client.key -out client.req -subj "/CN=localhost/emailAddress=client@gmail.com"

# 6. Use CA's private key to sign web client's CSR and get back the signed certificate
openssl x509 -req -in client.req -days 60 -CA ca.cert -CAkey ca.key -CAcreateserial -out client.cert -extfile client.ext

echo "client's signed certificate"
openssl x509 -in client.cert -noout -text

# 7. To verify the client's certificate aginst by root CA
echo "client's certificate verification"
openssl verify -show_chain -CAfile ca.cert client.cert
