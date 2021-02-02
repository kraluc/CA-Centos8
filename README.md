#  Study of Certificates

+ Create a CentOS8 container
+ follow steps described in [How To Set Up and Configure a Certificate Authority (CA) On CentOS 8](https://www.digitalocean.com/community/tutorials/how-to-set-up-and-configure-a-certificate-authority-ca-on-centos-8)

## Build container image based on Dockerfile
```
❯ docker build -t centos8 .
```

## Start Container instance

```
❯ docker run -it centos8
[root@8aba5bef7569 ~]# cd easy-rsa/
[root@8aba5bef7569 easy-rsa]# ./easyrsa build-ca nopass
Using SSL: openssl OpenSSL 1.1.1g FIPS  21 Apr 2020
Generating RSA private key, 2048 bit long modulus (2 primes)
...................+++++
...........................+++++
e is 65537 (0x010001)
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Common Name (eg: your user, host, or server name) [Easy-RSA CA]:

CA creation complete and you may now import and sign cert requests.
Your new CA certificate file for publishing is at:
/root/easy-rsa/pki/ca.crt


[root@8aba5bef7569 easy-rsa]#
```