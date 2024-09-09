# Cosign Demo

## Create an example image

```bash
NAME="ttl.sh/cosign-demo"
TAG="2h"
IMAGE_TAG="${NAME}:${LABEL}"

DIGEST=$(docker build -q -t ${IMAGE_TAG} .)
IMAGE_DIGEST="${NAME}@${DIGEST}"

echo "IMAGE_TAG=$IMAGE_TAG"
echo "IMAGE_SHA=$IMAGE_DIGEST"
docker run ${IMAGE_TAG}
docker push ${IMAGE_TAG}
```

## Sign the image

Make sure to fetch the remote reference for the image.

Signing by tag (mutable reference) could lead to a mistake (sign the wrong content)
or even a security issue where an attacker purposefully changes the content of
the image before signing it.

```bash
REMOTE_REF=$(docker inspect --format='{{index .RepoDigests 0}}' $IMAGE_TAG)
echo "REMOTE_REF=$REMOTE_REF"
cosign sign $REMOTE_REF
```

## Verify the signature

```bash
IDENTITY="fabian.kammel@control-plane.io"
OIDC_ISSUER="https://accounts.google.com"
cosign verify $REMOTE_REF --certificate-identity=$IDENTITY --certificate-oidc-issuer=$OIDC_ISSUER
```
