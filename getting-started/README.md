# Getting started
To create and verify certificates with openssl tool

[create and verify the certificates according the tutorial](https://www.gitcoins.io/docs/next/create-certificates)

There is an error to create the certificate, please remove or comment the rnd in the configuration file.

>error:2406F079:random number generator:RAND_load_file:Cannot open file:../crypto/rand/randfile.c:88

[Can't load /root/.rnd into RNG](https://stackoverflow.com/questions/63893662/cant-load-root-rnd-into-rng)
