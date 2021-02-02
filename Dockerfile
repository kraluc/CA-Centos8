FROM centos:8
RUN dnf --enablerepo="*" clean metadata
RUN dnf clean all
RUN dnf repolist -y
RUN dnf -y update && dnf -y upgrade
RUN dnf -y install epel-release tree
RUN dnf -y install git ansible openssh-clients openssl
RUN dnf -y install easy-rsa
# https://www.digitalocean.com/community/tutorials/how-to-set-up-and-configure-a-certificate-authority-ca-on-centos-8
RUN mkdir -m 700 ~/easy-rsa
RUN ln -s /usr/share/easy-rsa/3/* ~/easy-rsa
RUN cd ~/easy-rsa && ./easyrsa init-pki
COPY vars ~/easy-rsa/vars
WORKDIR /root
