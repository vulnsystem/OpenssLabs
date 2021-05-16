# To create and verify the certificat with secp256r1

![secp256r1](https://www.gitcoins.io/assets/images/elliptic-curve-0d9de7e1b8ff7a1adc62cc432a4427b8.png)

1. Start a openssl server in one console

```
openssl s_server -accept 20000 -cert server.cert -key server.key  -WWW -debug -tlsextdebug

```

2. Start a openssl client by browser

```
https://localhost:20000/index.html
```

3. The Security Warning occur

4. Add the CA certification to the browser

5. access OK
