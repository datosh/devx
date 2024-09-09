# Learning from Open Source: A Developer-First Approach to Security

## Abstract

Everyone is all too familiar with the stereotypical sticky-note with a password attached to a monitor, but we see equivalent security risks in our jobs, everyday! From sharing production secrets through insecure channels, to disregarding TLS server certificate validation. These are symptoms of a larger issue - 'Security at the expense of usability comes at the expense of security'. In this talk we will delve into the heart of this issue and show why adopting a developer-first approach is paramount when designing a secure system. We will distill design best-practices, from prominent and successful opensource projects such as Let's Encrypt and Sigstore. We contrast these with real-world scenarios, observed during security assessments in the industry, and show how the same best-practices could have lead to a system with higher adoption and therefore better security posture. Participants will be equipped with actionable strategies suited for simple scripts as well as complex CI/CD systems.

## UX/DX & Security

"Security at the expense of usability comes at the expense of security"

Security issues are not just about poorly implemented security, but also about usability. If we make security too hard, people will find ways around it.

Picking the password example, if we make it too hard to remember, people will write it down. If we make it too easy, people will use `password123`. If we make it too hard to change, people will never change it.

So how does password management changed over the last couple of years?
+ Who used a password manager 10 years ago?
+ Who is using a password manager today, personally ?
+ Who is using a password manager today, at work ?
+ Who is aware of the work on FIDO2 and WebAuthn ?

Alternatives to passwords managers are central user databases and single-sign on, where I also just have a single password to remember. But when did single sign on become to mean: "sign on every single time"?

## Demos

This repository contains the demos for the talk. Each demo is a self-contained directory with a `README.md` file that explains the demo and how to run it.

1. [Let's Encrypt Demo](letsencrypt-demo/README.md)
1. [Cosign Demo](cosign-demo/README.md)
1. [Gitsign Demo](gitsign-demo/README.md)
