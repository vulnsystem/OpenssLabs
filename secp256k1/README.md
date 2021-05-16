# To create and verify the certificat with secp256r1

![secp256r1](https://www.gitcoins.io/assets/images/elliptic-curve-0d9de7e1b8ff7a1adc62cc432a4427b8.png)

1. Start a openssl server in one console

```
openssl s_server -accept 10000 -cert server.cert -key server.key -CAfile ca.cert -debug -tlsextdebug -tls1_2 -curves secp256k1
```

2. Start a openssl client in another console

```
openssl s_client -connect 0.0.0.0:10000 -cert client.cert -key client.key -CAfile ca.cert -tls1_2 -curves secp256k1
```
