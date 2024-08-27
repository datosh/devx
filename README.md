# Learning from Open Source: A Developer-First Approach to Security

## Abstract

Everyone is all too familiar with the stereotypical sticky-note with a password attached to a monitor, but we see equivalent security risks in our jobs, everyday! From sharing production secrets through insecure channels, to disregarding TLS server certificate validation. These are symptoms of a larger issue - 'Security at the expense of usability comes at the expense of security'. In this talk we will delve into the heart of this issue and show why adopting a developer-first approach is paramount when designing a secure system. We will distill design best-practices, from prominent and successful opensource projects such as Let's Encrypt and Sigstore. We contrast these with real-world scenarios, observed during security assessments in the industry, and show how the same best-practices could have lead to a system with higher adoption and therefore better security posture. Participants will be equipped with actionable strategies suited for simple scripts as well as complex CI/CD systems.

## Problems

What are the problems we see today?

### 1. Self-Signed Certificates

TODO: Add pfsense.home example

### 2. Bad Password Hygiene

TODO: Add sticky note example

### 3. Code Attestation

TODO: `curl | sh -` example in production server

## Solutions

1. **Let's Encrypt** (ACME)
2. Bitwarden
3. **Sigstore**

We will dive into 1 & 3, but I highly recommend using Bitwarden for password management, as it is open-source, has great community and is super hackable!

## Let's Encrypt

What are limitations we see at enterprises, today?
1. Manual certificate generation & renewal
1. Difficult revocation process
1. Missing trust in self-signed certificates
1. Complex certificate chains

So what's the way forward?

1. Who is familiar with Let's Encrypt?
1. Who is familiar with ACME protocol?

### ACME Protocol

**A**utomated **C**ertificate **M**anagement **E**nvironment

1. **Challenge Types**
    1. HTTP-01
    1. DNS-01
    1. TLS-ALPN-01

1. **Client Implementations**
    1. Certbot
    1. acme.sh
    1. lego


## Sigstore

1. Who is familiar with Sigstore?
1. Who is familiar with OAuth2?
1. Who is familiar with OpenID Connect?
