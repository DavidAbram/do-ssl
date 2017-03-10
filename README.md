# digitalocean-ssl
Generate SSL certificates for DigitalOcean domain records using letsencrypt.org.

This project enables you to generate and renew SSL certificates provided by Let's Encrypt (let's encrypt.org).

The idea behind this project is to generate a single certificate on a "master" server and propagate it to "children" servers. A single certificate can hold up to 100 individual subdomain names (SAN certificate), and because Let's Encrypt allows you to generate 20 of such certificates per week, you can supply the cerificates to up to 2000 subdomains per week.

The "master" server also checks if the certificates should be renewed and does so if necessary.

The certificates are uploaded to "children" servers using SSH, both on initial upload and on renewal. You can supply the commands to be executed on "children" servers on a successful renewal, such as http server restart.

Follow the instructions below:

![alt tag](https://igorsaric.github.io/images/cert.svg)
