
Today we will learn how to secure the [gRPC connection using TLS](https://www.gitcoins.io/docs/next/grpc-auth-labs).

![grpc](https://www.gitcoins.io/assets/images/grpc-2b88fa6714071d12c164ea4cb2a00d14.svg)

If you haven’t read my post about SSL/TLS. I highly recommend you to read it first to have a deep understanding about TLS before continue.

- [Overview of SSL/TLS](https://www.gitcoins.io/docs/next/ssl-tls-overview)
- [Symmetric Cryptography](https://www.gitcoins.io/docs/next/symmetric-cryptography)
- [Asymmetric Cryptography](https://www.gitcoins.io/docs/next/asymmetric-cryptography)
- [TLS Handshake](https://www.gitcoins.io/docs/next/tls-handshake)

There are 3 types of gRPC connections:

![grpc-connection-types](https://www.gitcoins.io/assets/images/grpc-connection-types-08b1b5c28f3316e3e5b06e61a89bba26.png)

- The first one is insecure connection, which we’ve been using since the beginning of this course. In this connection, all data transfered between client and server is not encrypted. So please don’t use it in production!
- The second type is connection secured by server-side TLS. In this case, all the data is encrypted, but only the server needs to provide its TLS certificate to the client. You can use this type of connection if the server doesn’t care which client is calling its API.
- The third and strongest type is connection secured by mutual TLS. We use it when the server also needs to verify who’s calling its services. So in this case, both client and server must provide their TLS certificates to the other.

In this article, we will learn to implement both server-side and mutual TLS in node. So let’s get started!
Generate TLS certificates.

## Generate CA and server certificates

First we write the [gen.sh](https://github.com/vulnsystem/OpenssLabs/blob/main/grpc-server-auth/credentials/gen.sh) script to generate TLS certificates.

```shell
# 1. Generate server CA's private key and self-signed certificate
openssl req -x509 -newkey rsa:4096 -days 365 -nodes -keyout ca.key -out ca.cert -subj "/CN=localhost/emailAddress=ca@gmail.com"

echo "CA's self-signed certificate"
openssl x509 -in ca.cert -noout -text

# 2. Generate web server's private key and certificate signing request (CSR)
openssl req -newkey rsa:4096 -nodes -keyout server.key -out server.req -subj "/CN=localhost/emailAddress=server@gmail.com"

# 3. Use CA's private key to sign web server's CSR and get back the signed certificate
openssl x509 -req -in server.req -days 60 -CA ca.cert -CAkey ca.key -CAcreateserial -out server.cert -extfile server-ext.cnf

echo "Server's signed certificate"
openssl x509 -in server.cert -noout -text

# 4. To verify the server certificate aginst by root CA
echo "server's certificate verification"
openssl verify -show_chain -CAfile ca.cert server.cert
```

I encourage you to read my post about [how to create and sign TLS certificate](https://www.gitcoins.io/docs/next/create-certificates) to understand how this script works.

Basically this script contains 3 parts:

- First, generate CA’s private key and its self-signed certificate.
- Second, create web server’s private key and CSR.
- And third, use CA’s private key to sign the web server’s CSR and get back its certificate.

The generated files that we care about in this lab are:

- The CA’s certificate,
- The CA’s private key,
- The server’s certificate,
- And the server’s private key.

## Implement server-side TLS

Next step, I will show you how to secure our gRPC connection with server-side TLS.

Let’s open [greeter_server.js](https://github.com/vulnsystem/OpenssLabs/blob/main/grpc-server-auth/greeter_server.js) file. I will add ca and server certificates and sever private key to create TLS credentials.

```
function main() {
  var server = new grpc.Server();

  server.addService(hello_proto.Greeter.service, {sayHello: sayHello});
  server.bindAsync('0.0.0.0:50051', grpc.ServerCredentials.createSsl(
    fs.readFileSync('./credentials/ca.cert'),
    [{
        cert_chain: fs.readFileSync('./credentials/server.cert'),
        private_key: fs.readFileSync('./credentials/server.key')
    }],
    false
  ), () => {
    server.start();
  });
}
```

Now we can start the server:

```shell
npm install
node greeter_server.js
```

## Start client connection

After the server started, the client will try to connect with insecure function. But it failed because we haven’t enabled TLS on the client side yet. So let’s do that!

Similar to what we did on the server, I also add a function to load TLS credentials from files. But this time, we only need to load the certificate of the CA who signed the server’s certificate.

The reason is, client needs to make sure that it’s the right server it wants to talk to. So server's cert will be verified against the CA's cert and the CA should be trusted by client.

Let’s open [greeter_client.js](https://github.com/vulnsystem/OpenssLabs/blob/main/grpc-server-auth/greeter_client.js) file and add the trusted ca certificates to client.

```
var client = new hello_proto.Greeter(target,
            grpc.credentials.createSsl(fs.readFileSync('./credentials/ca.cert')));
```

So here we load the ca.cert file. Note that we only need to set the RootCAs field, which contains the trusted CA’s certificate.

And we’re done. Let’s try it out!

```shell
node greeter_client.js
```

This time the requests are successfully sent to the server. Perfect!
