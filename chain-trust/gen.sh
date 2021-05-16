rm *.pem
rm *.key
rm *.cert
rm *.req
rm *.srl

# 1. Generate root authority's private key and self-signed certificate
openssl req -x509 -newkey rsa:4096 -days 365 -nodes -keyout root.key -out root.cert -subj "/CN=localhost/emailAddress=root@gmail.com" 

echo "CA's self-signed certificate"
openssl x509 -in root.cert -noout -text

# 2. Generate intermediate authorities's private key and certificate signing request (CSR)
openssl req -newkey rsa:4096 -nodes -keyout intermediate.key -out intermediate.req -subj "/CN=localhost/emailAddress=intermediate@gmail.com"

# 3. Use root's private key to sign intermediate's CSR and get back the signed certificate
openssl x509 -req -in intermediate.req -days 60 -CA root.cert -CAkey root.key -CAcreateserial -out intermediate.cert -extfile intermediate.ext

echo "intermediate's signed certificate"
openssl x509 -in intermediate.cert -noout -text

# 4. To verify the intermediate certificate aginst by root CA
echo "intermediate's certificate verification"
openssl verify -show_chain -CAfile root.cert intermediate.cert 

# 5. Generate end-entity leaf's private key and certificate signing request (CSR)
openssl req -newkey rsa:4096 -nodes -keyout leaf.key -out leaf.req -subj "/CN=localhost/emailAddress=leaf@gmail.com"

# 6. Use intermediate's private key to sign leaf's CSR and get back the signed certificate
openssl x509 -req -in leaf.req -days 60 -CA intermediate.cert -CAkey intermediate.key -CAcreateserial -out leaf.cert -extfile leaf.ext

echo "leaf's signed certificate"
openssl x509 -in leaf.cert -noout -text

# 7. To verify the leaf certificate aginst by intermediate CA
echo "intermediate's certificate verification against root certificate"
openssl verify -show_chain -CAfile root.cert intermediate.cert leaf.cert
echo "Partial chain verifiication: to verify leaf's certificate against intermediate certificate"
openssl verify -show_chain -partial_chain -trusted intermediate.cert leaf.cert
echo "Full chain verifiication: to verify leaf's certificate against intermediate and root certificate"
openssl verify -show_chain -CAfile root.cert -untrusted intermediate.cert leaf.cert
