# digitalocean-ssl

## Introduction

Generate SSL certificates for DigitalOcean domain records using letsencrypt.org.

This project enables you to generate and renew SSL certificates provided by Let's Encrypt (let's encrypt.org).

The idea behind this project is to issue a single certificate on a "master" server and propagate it to "children" servers. A single certificate can hold up to 100 individual subdomain names (SAN certificate), and because Let's Encrypt allows you to issue 20 of such certificates per week, you can supply the cerificates for up to 2000 subdomains per week.

The "master" server also checks if the certificates should be renewed and does so if necessary.

The certificates are uploaded to "children" servers using SSH, both on initial upload and on renewal. You can supply the commands to be executed on "children" servers on a successful renewal, such as http server restart.

The ACME challenge is done through DNS (using TXT entries), which are created using an API on DigitalOcean domain records.

![alt tag](https://igorsaric.github.io/images/cert.svg)

## Usage

Follow the instructions below:

1. SSH to a  master servers.
2. Generate a SSH key pair without a passphrase (skip if you have an existing one):

```
[root@machine digitalocean-ssl]# ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa):
Created directory '/root/.ssh'.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /root/.ssh/id_rsa.
Your public key has been saved in /root/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:X7mlp39TpBMaAbrodMtT8vYZ4XvF4ROSUhdLCzadt8I root@machine
The key's randomart image is:
+---[RSA 2048]----+
|          .. +.oo|
|         .  o.+++|
|        .   o.ooo|
|       . . ..E.+.|
|      o S . =o==o|
|     o o * o.=oo+|
|      . + + = .oo|
|         o . *...|
|            =o...|
+----[SHA256]-----+
```

3. Copy the content of /root/.ssh/id_rsa.pub to /root/ssh/authorized_keys on remote servers.
4. Make sure you can SSH into remote servers without a password.
5. Enter the domains you whis to isse certificates for in domains.txt (one domain per line).
6. Execute ./create.sh. This will generate a certificate for every 100 domains in domains.txt.
7. An attempt will be made to upload the certificate to remote servers (using the domain names as addresses). The certificates will be uploaded to /etc/certs/fullchain.pem and /etc/certs/privkey.pem.

