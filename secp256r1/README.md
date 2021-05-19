# Generate and verify secp256r1 certificate

![secp256r1](https://www.gitcoins.io/assets/images/elliptic-curve-0d9de7e1b8ff7a1adc62cc432a4427b8.png)


## 1. Root (EC) cert
First to generate EC private key and self-signed certificate

```
openssl ecparam -genkey -out ca.key -name secp256r1 
openssl req -x509 -new -key ca.key -out ca.cert -subj "/C=FR/ST=Occitanie/L=Toulouse/O=Tech School/OU=Education/CN=*.techschool.guru/emailAddress=root.guru@gmail.com"
```

> Notive: To assign **secp256k1** as name of openssl ecparam genkey.

## 2. Server's cert request 
Second to generate web server's private key and certificate signing request (EC)

```
openssl ecparam -genkey -out server.key -name secp256r1 
openssl req  -key server.key -new -out server.req -subj "/C=FR/ST=Ile de France/L=Paris/O=PC Book/OU=Computer/CN=*.pcbook.com/emailAddress=server@gmail.com"
```

## 3. Server's cert
Third to use CA's private key to sign web server's CSR and get back the signed certificate of server
```
openssl x509 -req -in server.req -days 60 -CA ca.cert -CAkey ca.key -CAcreateserial -out server.cert -extfile server.ext
```

## 4. Client's cert request
Fourth to generate client's private key and certificate signing request (EC)
```
openssl ecparam -genkey -out client.key -name secp256r1 
openssl req -key client.key -new  -out client.req -subj "/C=FR/ST=Alsace/L=Strasbourg/O=PC Client/OU=Computer/CN=*.client.com/emailAddress=client@gmail.com"
```

## 5. Client's cert
Fifth to use CA's private key to sign client's CSR and get back the signed certificate of client
```
openssl x509 -req -in client.req -days 60 -CA ca.cert -CAkey ca.key -CAcreateserial -out client.cert -extfile client.ext
```

## 6. Verify the server certificate aginst by root CA
```
openssl verify -show_chain -CAfile ca.cert server.cert
```

## 7. verify the client certificate aginst by root CA.
```
openssl verify -show_chain -CAfile ca.cert client.cert
```

## Generate and verify secp256k1 certificate

> The same as **secp256K1**, if you want to reuse these code with secp256r1, please go through [the detailed infomation in github](https://github.com/vulnsystem/OpenssLabs/blob/main/secp256k1/).

