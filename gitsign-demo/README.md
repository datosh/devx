# Gitsign Demo

## Commit in some else's name

> [!WARNING]
> All excercises are intended for educational purposes only. Users are strictly advised not to employ the acquired knowledge for any malicious activities or unauthorized access.

```sh
# Set username and email
git config user.name "Kelsey Hightower"
git config user.email "kelsey.hightower@gmail.com"
# Commit as Kelsey
git commit --allow-empty --no-gpg-sign -m "awesome change"
git push origin HEAD
```

<details>
  <summary>Revert config & push.</summary>

  ```sh
  # Use global config values
  git config --unset user.name
  git config --unset user.email
  # Revert commit locally and remote
  git reset --hard HEAD~1
  git push origin HEAD --force-with-lease
  ```

</details>


## Signing to the rescure

To mitigate the risk that someone impersonates other users on GitHub, we should sign and verify commits to our repositories, i.e., cryptographically bind the content of the commit to the signer's identity.

git commit signing is supported, since [git v1.7.9 (January 2012)](https://github.com/git/git/blob/master/Documentation/RelNotes/1.7.9.txt#L56-L57), and is based on GPG keys.

<details>
  <summary>GPG based commit signing (example).</summary>
  GitHub provides great documentation on how to sign your commits with GPG.

  1. [Generate your key](https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key)
      ```sh
      gpg --full-generate-key
      ```
  2. [Add public key to your profile](https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-gpg-key-to-your-github-account)
      ```sh
      # List keys
      gpg --list-secret-keys --keyid-format=long
      # Export public key
      gpg --armor --export 3AA5C34371567BD2
      ```
  3. [Configure git](https://docs.github.com/en/authentication/managing-commit-signature-verification/telling-git-about-your-signing-key)
      ```sh
      # Enable commit signing
      git config --global commit.gpgsign true
      # Configure key
      git config --global user.signingkey 3AA5C34371567BD2
      ```
  4. Sign and push
      ```sh
      # Our settings will automatically sign, otherwise use -S
      git commit -m "awesome change"
      git push
      ```
  5. Verification
      ```sh
      git verify-commit HEAD
      ```

  Read more about [git commit signature verification support on GitHub](https://docs.github.com/en/authentication/managing-commit-signature-verification/about-commit-signature-verification).
</details>

### gitsign

Download and install [sigstore/gitsign](https://github.com/sigstore/gitsign).

<details>
  <summary>Installation script</summary>

  ```sh
  VERSION=0.8.0
  cd $(mktemp -d)
  curl -LO https://github.com/sigstore/gitsign/releases/download/v${VERSION}/gitsign_${VERSION}_linux_amd64
  curl -LO https://github.com/sigstore/gitsign/releases/download/v${VERSION}/gitsign-credential-cache_${VERSION}_linux_amd64
  sudo install gitsign_${VERSION}_linux_amd64 /usr/local/bin/gitsign
  sudo install gitsign-credential-cache_${VERSION}_linux_amd64 /usr/local/bin/gitsign-credential-cache
  cd -
  ```
</details>

Configure git to sign using `gitsign`.

```sh
git config commit.gpgsign true  # Sign all commits
git config tag.gpgsign true  # Sign all tags
git config gpg.x509.program gitsign  # Use gitsign for signing
git config gpg.format x509  # gitsign expects x509 args
```

Optional:
```sh
# Static port for OIDC callback. This is helpful when you need to whitelist
# or proxy the callback, e.g., when working with remote dev environments.
git config gitsign.redirecturl http://localhost:39807/auth/callback
# Pre-select GitHub as default OIDC provider.
git config gitsign.connectorid https://github.com/login/oauth
```

> [!NOTE]
> Add `--global` to previous `git config` commands, so they apply for all repositories.

Verify & inspect:

```sh
# Using git (partial verification)
git verify-commit HEAD
# Using gitsign
gitsign verify \
  --certificate-identity=datosh18@gmail.com \
  --certificate-oidc-issuer=https://github.com/login/oauth
# Show actual signature value
git log --pretty=raw
# Show (partial) signature validation
git log --show-signature
```

<details>
  <summary>Helpful debug commands</summary>

  ```sh
  # Check your git config
  git config --list --show-origin --show-scope
  # Remove a config paramter
  git config --unset gitsign.connectorid
  # Create unsigned, empty commit
  git commit --allow-empty --no-gpg-sign -m "nothing, unsigned"
  # Parse git signature
  git cat-file commit HEAD | sed -n '/-BEGIN/, /-END/p' | sed 's/^ //g' | sed 's/gpgsig //g' | sed 's/SIGNED MESSAGE/PKCS7/g' | openssl pkcs7 -print -print_certs -text
  ```
</details>

> [!NOTE]
> [GitHub does not recognize gitsign signatures as verified at the moment](https://github.com/sigstore/gitsign#why-doesnt-github-show-commits-as-verified).

<details>
  <summary>Configure gitsign credential cache</summary>

  When doing multiple git commits in a short period of time, it might become
  annoying to do the OIDC dance for every commit.

  The gitsign credential cache binary enables users to re-use the key during
  its 10 minutes lifetime.

  Check the [official documentation](https://github.com/sigstore/gitsign/blob/main/cmd/gitsign-credential-cache/README.md)
  as the configuration is highly platform dependent.

  ```sh
  gitsign-credential-cache &
  export GITSIGN_CREDENTIAL_CACHE="$HOME/.cache/sigstore/gitsign/cache.sock"
  ```

  > [!WARNING]
  > Users should consider that caching the key [introduces a security risk](https://github.com/sigstore/gitsign/blob/main/cmd/gitsign-credential-cache/README.md), as
  > the key is exposed via unix sockets.

</details>
