# A chain of trust

![image](https://user-images.githubusercontent.com/16678393/115525236-7c232d00-a2c1-11eb-9f13-329bc3373cc1.png)

[The lab implement according to the tutorial](https://www.gitcoins.io/docs/next/openssl-labs#a-chain-of-trust)

In these lab, we create root, intermediate and leaf certificate. The intermediate's certificate signed by root's and leaf's certificate signed by intermediate's. 

## Root (RSA) cert
First to generate root authority's private key and self-signed certificate.
```
openssl req -x509 -newkey rsa:4096 -days 365 -nodes -keyout root.key -out root.cert -subj "/CN=localhost/emailAddress=root@gmail.com" 
```
### Intermediate cert request
Second to generate intermediate authorities's private key and certificate signing request (CSR)
```
openssl req -newkey rsa:4096 -nodes -keyout intermediate.key -out intermediate.req -subj "/CN=localhost/emailAddress=intermediate@gmail.com"
```

## Intermediate cert
Third to use root's private key to sign intermediate's CSR and get back the signed certificate of intermediate.

```
openssl x509 -req -in intermediate.req -days 60 -CA root.cert -CAkey root.key -CAcreateserial -out intermediate.cert -extfile intermediate.ext
```

Notice basicConstraints atrribute in intermediate.ext should be assigned as following.
``` name=intermediate.ext
subjectAltName=DNS:*.pcbook.com,DNS:*.pcbook.org,IP:0.0.0.0
basicConstraints=CA:TRUE,pathlen:0
```

> CA:TRUE means it is a intermediate CA and allow the CA to issue certificates. If the CA value not be assigned, the default value FALSE will be assigned.

> pathlen:0 does still allow the CA to issue certificates, but these certificates must be end-entity-certificates.It also implies that with this certificate, the CA must not issue intermediate CA certificates .

## Leaf cert request
Fourth to generate end-entity leaf's private key and certificate signing request (CSR)
```
openssl req -newkey rsa:4096 -nodes -keyout leaf.key -out leaf.req -subj "/CN=localhost/emailAddress=leaf@gmail.com"
```
## Leaf cert
Fifty ot use intermediate's private key to sign leaf's CSR and get back the signed certificate of leaf
```
openssl x509 -req -in leaf.req -days 60 -CA intermediate.cert -CAkey intermediate.key -CAcreateserial -out leaf.cert -extfile leaf.ext
```
> Notice basicConstraints atrribute in leaf.ext have been assigned defaultly **(FALSE)**. 

``` name=leaf.ext
subjectAltName=DNS:*.pcbook.com,DNS:*.pcbook.org,IP:0.0.0.0
```

## verify the trust chain
To verify the leaf certificate aginst by intermediate CA
1. intermediate's certificate verification against root certificate"
```
openssl verify -show_chain -CAfile root.cert intermediate.cert leaf.cert
```
2. Partial chain verifiication: to verify leaf's certificate against intermediate certificate
```
openssl verify -show_chain -partial_chain -trusted intermediate.cert leaf.cert
```
3. Full chain verifiication: to verify leaf's certificate against intermediate and root certificate
```
openssl verify -show_chain -CAfile root.cert -untrusted intermediate.cert leaf.cert
```

# Reference:
[Verify a certificate chain using openssl](https://stackoverflow.com/questions/25482199/verify-a-certificate-chain-using-openssl-verify)

[Partial chain verification](https://security.stackexchange.com/questions/118062/use-openssl-to-individually-verify-components-of-a-certificate-chain)
