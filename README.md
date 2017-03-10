# digitalocean-ssl

## Introduction

These scripts enable you to generate and renew SSL certificates provided by Let's Encrypt (letsencrypt.org) using DigitalOcean API domain record validation.

The idea behind this project is to issue a single certificate on a "master" server and propagate it to "child" servers, so that a single shared certificate can be used on up to 100 subdomains. Let's Encrypt allows you to issue 20 of such certificates per week, which means you can supply the certificates for up to 2000 subdomains in total (per week).

When issued or renewed, the script uploads the certificates to child servers using SSH. You can supply the commands to be executed on child servers on a successful renewal, such as service restart. For this to work correctly, passphrase-less SSH key pair (public key) on child servers must be configured.

The ACME challenge is done through DNS (using TXT entries), which are created through API on DigitalOcean domain records, as displayed on the image below:

![alt tag](https://igorsaric.github.io/images/cert.svg)

## Usage

Follow the instructions below:
    
1. Enter the domains to issue certificates for in ``domains.txt`` (one domain per line), for example:
```
example.com
x.example.com
y.example.com
z.example.com
```

2. Configure the values in ``config.json`` (DigitalOcean API token, master domain string).

```
{
    "api_token": "<set your DigitalOcean API key here>",
    "master_domain": "<set your master domain here, i.e. example.com>"
}
```

1. Ensure you can SSH to child servers without a password:

    1. On the master server, use ``ssh-keygen`` to generate a SSH key pair without a passphrase.
    2. Copy the content of ``/root/.ssh/id_rsa.pub`` to ``/root/.ssh/authorized_keys`` on children servers.
    3. Verify you can SSH to children servers without a password.

4. Execute ``./create.sh``. This will generate a certificate for every 100 domains in ``domains.txt``. The certificate files will be located in ``/etc/letsencrypt/live/<domain>/``

5. If you enabled automatic upload in ``config.json``, an attempt will be made to upload the certificates to remote servers (using the domain names as addresses). The certificates will be uploaded as ``/etc/certs/fullchain.pem`` and ``/etc/certs/privkey.pem``.

