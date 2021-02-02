#  Study of Certificates

+ Create a CentOS8 container
+ follow steps described in [How To Set Up and Configure a Certificate Authority (CA) On CentOS 8](https://www.digitalocean.com/community/tutorials/how-to-set-up-and-configure-a-certificate-authority-ca-on-centos-8)

REFERENCE:
+ Easy-RSA - [https://wiki.archlinux.org/index.php/Easy-RSA](https://wiki.archlinux.org/index.php/Easy-RSA)

## Build container image based on Dockerfile
```
❯ docker build -t centos8 .
```

## Start Container instance

```bash
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

### ca.crt

CA certificate is available from:

```bash
[root@8aba5bef7569 ~]# cat ~/easy-rsa/pki/ca.crt
-----BEGIN CERTIFICATE-----
MIIDSzCCAjOgAwIBAgIUDcR+QHw2+5kB+iv10wPhiMLE2KgwDQYJKoZIhvcNAQEL
BQAwFjEUMBIGA1UEAwwLRWFzeS1SU0EgQ0EwHhcNMjEwMjAyMDUwNjQxWhcNMzEw
MTMxMDUwNjQxWjAWMRQwEgYDVQQDDAtFYXN5LVJTQSBDQTCCASIwDQYJKoZIhvcN
AQEBBQADggEPADCCAQoCggEBANTcDShKb/SSglPfuyt5mmbsXWlUt004fEb2PRbE
T1MpgGaY3FufeQl+9qXrpVpOPXvtRsrtkXyvNo1FUAf+Jby+HNxU2UccB8BEnNTL
yztdWHQktJ7n1i0aYFB7GGjG6E8ZYr0bTgyXzhxBLVYf6762xfu/jKnvKGY6NjPj
amUl5yhLD9sy3UDX7yeZuPFLCIOho7/SdN8hdiZbHFsz0uPC9WBvsxzblo/EZxGV
SAeWEe5wkegJF+hG9HcBOnYcm/Afgv7DCWZaLr1wP4gjn1IRaY2O3BCMVkU3bTns
WuFJ8FOFt1o8ADLb1wexFlVDw/XS6O8r5PKfFLv/nsdsgVECAwEAAaOBkDCBjTAd
BgNVHQ4EFgQUH+bdE0iA0G/BagQHaH0urTqXVfMwUQYDVR0jBEowSIAUH+bdE0iA
0G/BagQHaH0urTqXVfOhGqQYMBYxFDASBgNVBAMMC0Vhc3ktUlNBIENBghQNxH5A
fDb7mQH6K/XTA+GIwsTYqDAMBgNVHRMEBTADAQH/MAsGA1UdDwQEAwIBBjANBgkq
hkiG9w0BAQsFAAOCAQEArG+MiijdRw3GxCoQo6OSfZt723jw+dQn+U02R17dnJ78
f8SNiJxvvNAS3KDPP+FhV6BmGy1lddRQ/tphWTnGwtcmr5WUo6DdSvmrN9pSpuoi
7RrAKY/3pmicpl6oP2BRGnLi9uBGRaeLCB9W/HyrMzjNF5m1oghZj3npPM8uJb2I
NWBFeXDBxlYWR776Cp8fxr76LYUf9/yRcKkgDONNKwa4aZSi1SGVwpWN1WeHXvwW
mYchtkb4hevYEwtw7fL9kS8XTNfP1CqjqA7LwMyyZZrEV54KDqgu/1vwLgCdPmX7
w04x0iaWWEU3gOQx3pVmRw196cmQTn7B7o+5BPh7PA==
-----END CERTIFICATE-----
```

### import the CA certificate

+ On a different host copy the ca.crt to /etc/pki/ca-trust/source/anchors
+ run 'update-ca-trust' = host will now trust certificates signed by CA.crt

```bash
[root@8aba5bef7569 ~]# cd /etc/pki/ca-trust/source/anchors/
[root@8aba5bef7569 anchors]# ls
[root@8aba5bef7569 anchors]# cp ~/easy-rsa/pki/ca.crt .
[root@8aba5bef7569 anchors]# ls
ca.crt
[root@8aba5bef7569 anchors]#  update-ca-trust
```

## Creating and Signing a Practice Certificate Request


### install openssl

```bash
[root@8aba5bef7569 ~]# dnf install -y openssl
Failed to set locale, defaulting to C.UTF-8
Last metadata expiration check: 0:26:05 ago on Tue Feb  2 05:04:28 2021.
Package openssl-1:1.1.1g-12.el8_3.x86_64 is already installed.
Dependencies resolved.
Nothing to do.
Complete!
```

### Create a Private Key

+ create a Private Key: ```server.key```

```bash
[root@8aba5bef7569 ~]# cd
[root@8aba5bef7569 ~]# mkdir ~/practice-csr
[root@8aba5bef7569 ~]# cd ~/practice-csr/
[root@8aba5bef7569 practice-csr]# openssl genrsa -out server.key
Generating RSA private key, 2048 bit long modulus (2 primes)
..............................................+++++
......+++++
e is 65537 (0x010001)
[root@8aba5bef7569 practice-csr]# ls
server.key
```

+ Confirm hostname and local IP

```bash
[root@8aba5bef7569 practice-csr]# echo ${HOSTNAME}
8aba5bef7569
```
```bash
[root@8aba5bef7569 practice-csr]# ip add | grep -w inet
    inet 127.0.0.1/8 scope host lo
    inet 172.17.0.2/16 brd 172.17.255.255 scope global eth0
```

+ create a Certificate Sign Request: server.csr

```bash
[root@8aba5bef7569 practice-csr]# openssl req -new -key server.key -out server.req
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [XX]:US
State or Province Name (full name) []:CA
Locality Name (eg, city) [Default City]:San Jose
Organization Name (eg, company) [Default Company Ltd]:Server1
Organizational Unit Name (eg, section) []:Test
Common Name (eg, your name or your server's hostname) []:8aba5bef7569
Email Address []:vricci@cisco.com

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:DCRSrul3$!
An optional company name []:Server1
```

```bash
[root@8aba5bef7569 practice-csr]# ls
server.key  server.req
```

+ confirm the subject information:

```bash
[root@8aba5bef7569 practice-csr]# openssl req -in server.req -noout -subject
subject=C = US, ST = CA, L = San Jose, O = Server1, OU = Test, CN = 8aba5bef7569, emailAddress = vricci@cisco.com
```

### Importing CSR on CA

+ in this example, the CA and server are the same host
+ local hostname is 8aba5bef7569

```bash
[root@8aba5bef7569 practice-csr]# cd ~/easy-rsa/
[root@8aba5bef7569 easy-rsa]# ./easyrsa import-req ~/practice-csr/server.req 8aba5bef7569
Using SSL: openssl OpenSSL 1.1.1g FIPS  21 Apr 2020

The request has been successfully imported with a short name of: 8aba5bef7569
You may now use this name to perform signing operations on this request.
```

### CA Sign CSR for CN 8aba5bef7569

```bash
[root@8aba5bef7569 easy-rsa]# ./easyrsa sign-req server 8aba5bef7569
Using SSL: openssl OpenSSL 1.1.1g FIPS  21 Apr 2020


You are about to sign the following certificate.
Please check over the details shown below for accuracy. Note that this request
has not been cryptographically verified. Please be sure it came from a trusted
source or that you have verified the request checksum with the sender.

Request subject, to be signed as a server certificate for 825 days:

subject=
    countryName               = US
    stateOrProvinceName       = CA
    localityName              = San Jose
    organizationName          = Server1
    organizationalUnitName    = Test
    commonName                = 8aba5bef7569
    emailAddress              = vricci@cisco.com


Type the word 'yes' to continue, or any other input to abort.
  Confirm request details: yes
Using configuration from /root/easy-rsa/pki/easy-rsa-92.2nxSZz/tmp.j8hsUA
Check that the request matches the signature
Signature ok
The Subject's Distinguished Name is as follows
countryName           :PRINTABLE:'US'
stateOrProvinceName   :ASN.1 12:'CA'
localityName          :ASN.1 12:'San Jose'
organizationName      :ASN.1 12:'Server1'
organizationalUnitName:ASN.1 12:'Test'
commonName            :ASN.1 12:'8aba5bef7569'
emailAddress          :IA5STRING:'vricci@cisco.com'
Certificate is to be certified until May  8 05:44:50 2023 GMT (825 days)

Write out database with 1 new entries
Data Base Updated

Certificate created at: /root/easy-rsa/pki/issued/8aba5bef7569.crt
```

+ With those steps complete, you have signed the server.req CSR using the CA Server’s private key in /root/easy-rsa/pki/private/ca.key