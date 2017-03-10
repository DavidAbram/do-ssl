# digitalocean-ssl

## Introduction

This project enables you to generate and renew SSL certificates provided by Let's Encrypt (letsencrypt.org) using DigitalOcean domain record API.

The idea behind this project is to issue a single certificate on a "master" server and propagate it to "children" servers, so that a single shared certificate can be used on the subdomains. A single certificate can hold up to 100 individual subdomain names (SAN certificate), and because Let's Encrypt allows you to issue 20 of such certificates per week, you can supply the certificates for up to 2000 subdomains (per week).

The certificates are optionally uploaded to children servers using SSH, after the certificate was issued and on certificate renewal. You can supply the commands to be executed on children servers on a successful renewal, such as service restart.

The ACME challenge is done through DNS (using TXT entries), which are created through API on DigitalOcean domain records, as displayed on the image below:

![alt tag](https://igorsaric.github.io/images/cert.svg)

## Usage

Follow the instructions below:
    
1. Enter the domains to issue certificates for in ``domains.txt`` (one domain per line).

2. Configure the values in ``config.json`` (DigitalOcean API token, master domain string, automatic upload).

1. If you enabled automatic upload in ``config.json``, ensure you can SSH to children servers without a password:

    1. On the master server, use ``ssh-keygen`` to generate a SSH key pair without a passphrase.
    2. Copy the content of ``/root/.ssh/id_rsa.pub`` to ``/root/.ssh/authorized_keys`` on children servers.

4. Execute ``./create.sh``. This will generate a certificate for every 100 domains in ``domains.txt``.

5. If you enabled automatic upload in ``config.json``, an attempt will be made to upload the certificates to remote servers (using the domain names as addresses). The certificates will be uploaded as ``/etc/certs/fullchain.pem`` and ``/etc/certs/privkey.pem``.

