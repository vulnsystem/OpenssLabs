# Chain of trust
Chain of certificate authorities verification

![image](https://user-images.githubusercontent.com/16678393/115525236-7c232d00-a2c1-11eb-9f13-329bc3373cc1.png)

Certificate Authority - A chain of trust
In reality, there’s a chain of certificate authorities.

At the top level is a root certificate authority, who signs their own certificate, and also signs the certificate of their subordinate, which is an intermediate certificate authority.

This authority can sign the certificate of other intermediate authorities, or they can sign the end-entity certificate (or leaf certificate).

Each certificate will reference back to the certificate of their higher level authority, up to the root.

Your operating systems and browsers store a list of certificates of trusted root certificate authorities. That way they can easily verify the authenticity of all certificates.

In these project, we create root, intermediate and leaf certificate. The intermediate's certificate signed by root's and leaf's certificate signed by intermediate's.
So basicConstraints atrribute is added in the extfile(intermediate.ext) which assign the CA to ture and pathlen to zero.
```
basicConstraints=CA:TRUE,pathlen:0
```
> CA:TRUE means it is a intermediate CA and allow the CA to issue certificates. If the CA value not be assigned, the default value FALSE will be assigned. 

> pathlen:0 does still allow the CA to issue certificates, but these certificates must be end-entity-certificates.It also implies that with this certificate, the CA must not issue intermediate CA certificates . 

# Reference:
[Verify a certificate chain using openssl](https://stackoverflow.com/questions/25482199/verify-a-certificate-chain-using-openssl-verify)

[Partial chain verification](https://security.stackexchange.com/questions/118062/use-openssl-to-individually-verify-components-of-a-certificate-chain)
