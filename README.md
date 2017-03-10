# digitalocean-ssl

## Introduction

Generate SSL certificates for DigitalOcean domain records using letsencrypt.org.

This project enables you to generate and renew SSL certificates provided by Let's Encrypt (let's encrypt.org).

The idea behind this project is to issue a single certificate on a "master" server and propagate it to "children" servers. A single certificate can hold up to 100 individual subdomain names (SAN certificate), and because Let's Encrypt allows you to issue 20 of such certificates per week, you can supply the cerificates for up to 2000 subdomains per week.

The master server also checks if the certificates should be renewed and does so if necessary.

The certificates are uploaded to children servers using SSH, both on initial upload and on renewal. You can supply the commands to be executed on children servers on a successful renewal, such as http server restart.

The ACME challenge is done through DNS (using TXT entries), which are created using an API on DigitalOcean domain records.

![alt tag](https://igorsaric.github.io/images/cert.svg)

## Usage

Follow the instructions below:

1. On the master server, use ``ssh-keygen`` to generate a SSH key pair without a passphrase (skip if you have an existing one).
2. Copy the content of ``/root/.ssh/id_rsa.pub`` to ``/root/.ssh/authorized_keys`` on children servers.
3. Make sure you can SSH from the master server into the children servers without a password.
4. Enter the domains for which to issue certificates in ``domains.txt`` (one domain per line).
5. Execute ``./create.sh``. This will generate a certificate for every 100 domains in ``domains.txt``.
6. An attempt will be made to upload the certificate to remote servers (using the domain names as addresses). The certificates will be uploaded as ``/etc/certs/fullchain.pem`` and ``/etc/certs/privkey.pem``.

