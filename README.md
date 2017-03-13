# do-ssl

## Introduction

These scripts enable you to generate and renew SSL certificates provided by Let's Encrypt (letsencrypt.org) using DigitalOcean API for domain record validation.

The idea behind this project is to issue a single certificate on a "master" server and propagate it to "child" servers, so that a single shared certificate can be used on up to 100 subdomains. Let's Encrypt allows you to issue 20 of such certificates per week, which means you can supply the certificates for up to 2000 subdomains in total (per week).

When issued or renewed, the script uploads the certificates to child servers using SSH. You can supply the commands to be executed on child servers on a successful renewal, such as service restart. For this to work correctly, passphrase-less SSH key pair (public key) on child servers must be configured.

The ACME challenge is done through DNS using TXT entries, which are created through API on DigitalOcean domain records, as displayed on the image below:

![alt tag](https://igorsaric.github.io/images/cert.svg)

## Usage
### Issue SSL certificates
1. Configure the required values in ``config.json``:
    ```
    {
        "api_token": "<set your DigitalOcean API key here>",
        "master_domain": "<set your master domain here, i.e. example.com>"
    }
    ```

2. On master server, enter the domains to issue certificates for in ``domains.txt`` (one domain per line), for example:
    ```
    example.com
    x.example.com
    y.example.com
    z.example.com
    ```

3. Ensure you can SSH from the master server to child servers without a password. If not, take the following actions:
    1. On the master server, use ``ssh-keygen`` to generate a SSH key pair without a passphrase.
    2. Copy the content of ``/root/.ssh/id_rsa.pub`` to ``/root/.ssh/authorized_keys`` on child servers.
    3. Verify you can SSH to child servers without a password.

4. Execute ``./issue.sh``. This will generate a certificate on a master server in ``/etc/letsencrypt/live/<first_domain>/`` for every 100 domains in ``domains.txt``.

5. ``issue.sh`` will attempt to upload the certificates to remote servers (using the domain names as destination addresses). The certificates will be uploaded as ``/etc/certs/fullchain.pem`` and ``/etc/certs/privkey.pem``. Configure nginx (example provided) to consume the issued certificates.

### Auto-renew SSL certificates

If you successfully issued the certificate, you can configure auto-renewal.  Auto-renewal is achieved using systemd service (timer) on master server:

1. Configure ``post_exec.sh`` to execute the appropriate commands on the child servers when certificate is renewed and copied over.

2. Configure provided ``systemd/renew.service`` to point to correct absolute path to ``renew.sh`` on the line ``ExecStart=/home/user/do-ssl/renew.sh``.

3. Copy both ``systemd/renew.service`` and ``systemd/renew.timer`` to ``/etc/systemd/system/``.

4. Run ``systemctl enable renew.timer`` and ``systemctl start renew.timer``.

5. Service should now be running once a day (on a random time) on the master server. Verify this by running ``journalctl -u renew.timer``.

When a certificate is renewed, it will be uploaded to appropriate servers using the same mechanism as when originally issued.
