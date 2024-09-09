## Manual Certifiate Management

### Problem: Self-Signed Certificates & Manual Certificate Management

Trusting root certificate is one, but also expired or revoked certificates are a problem.

https://badssl.com/

+ https://expired.badssl.com/
+ https://self-signed.badssl.com/
+ https://revoked.badssl.com/

### Let's Encrypt - Demo

Prerequisites:
+ Create DNS record for `letsencrypt-demo.kammel.dev` pointing to the public IP of the instance.

```bash
terraform init
terraform apply
scp docker-compose.yml datosh@$(terraform output -raw public_ip):~/docker-compose.yml
ssh datosh@$(terraform output -raw public_ip)
```

Verify the environment is configured correctly

```bash
# DNS from outside
dig +short letsencrypt-demo.kammel.dev
# IP from inside
curl -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip
```

Request a certificate from Let's Encrypt staging environment:

```bash
sudo certbot certonly --standalone -d letsencrypt-demo.kammel.dev --test-cert \
    --email "fabian.kammel@control-plane.io" --agree-tos -n

sudo openssl x509 -noout -text -in /etc/letsencrypt/live/letsencrypt-demo.kammel.dev/fullchain.pem | less
```

Fully integrated ACME into Traefik as reverse proxy:

```bash
sudo docker compose up -d
```

[https://letsencrypt-demo.kammel.dev/](https://letsencrypt-demo.kammel.dev/)
