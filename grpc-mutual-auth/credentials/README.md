# Create and verify the RSA certification

![image](https://www.gitcoins.io/assets/images/asymmetric-overview-4b4225f21c160ad9a57edd113e730068.png)


[To create and verify the certificates according to the tutorial](https://www.gitcoins.io/docs/next/create-certificates)

> Copyright: the following content is totally copy from the [TECHSCHOOL](https://dev.to/techschoolguru/how-to-create-sign-ssl-tls-certificates-2aai).

Now let's create and verify the certificates with openssl.
For the purpose of this tutorial, we won’t submit our Certificate Signing Request (CSR) to a real CA. Instead, we will play both roles: the certificate authority and the certificate applicant.

So here's what we're gonna do:
- In the first step, we will generate a private key and its self-signed certificate for the CA. They will be used to sign the CSR later.
- In the second step, we will generate a private key and its paired CSR for the web server that we want to use TLS.
- Then finally we will use the CA’s private key to sign the web server’s CSR and get back the signed certificate.

## Notice
Notice: There is an error to create the certificate, please remove or comment the rnd in the configuration file.

>error:2406F079:random number generator:RAND_load_file:Cannot open file:../crypto/rand/randfile.c:88

[Can't load /root/.rnd into RNG](https://stackoverflow.com/questions/63893662/cant-load-root-rnd-into-rng)

# Reference:
https://dev.to/techschoolguru/a-complete-overview-of-ssl-tls-and-its-cryptographic-system-36pd
