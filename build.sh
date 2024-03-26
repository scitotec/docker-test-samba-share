#!/usr/bin/env bash

version=$1
if [ -z "$version" ]; then
  echo "Usage $0 <version>"
  exit 2
fi

docker buildx build \
  --platform linux/amd64,linux/arm64,linux/arm \
  --pull \
  --push \
  --cache-from=scitotec/test-samba-share:latest \
  -t scitotec/test-samba-share:$version \
  -t scitotec/test-samba-share:latest \
  .