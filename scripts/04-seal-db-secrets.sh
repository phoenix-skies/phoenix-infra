#!/usr/bin/env bash
# Day 8 — encrypts a DB password per environment with the cluster's Sealed Secrets key and
# writes the ciphertext into phoenix-gitops/helm/phoenix/values-<env>.yaml. Commit + push after.
# The plain password never touches Git.
set -euo pipefail
source "$(dirname "$0")/env.sh"
GITOPS_DIR="${GITOPS_DIR:-$(cd "$(dirname "$0")/../.." && pwd)/phoenix-gitops}"
for env in dev qa prod; do
  pw=$(openssl rand -base64 18 | tr -d '/+=')
  sealed=$(echo -n "$pw" | kubeseal --raw \
    --controller-name sealed-secrets-controller --controller-namespace kube-system \
    --namespace "phoenix-$env" --name phoenix-db)
  SEALED="$sealed" yq -i '.database.sealedPassword = strenv(SEALED)' "$GITOPS_DIR/helm/phoenix/values-$env.yaml"
  echo "sealed password written for $env"
done
echo
echo "Now:  cd $GITOPS_DIR && git checkout -b secrets/sealed-db && git commit -am 'feat(security): sealed DB secrets' && git push -u origin HEAD"
echo "Then open a PR. NOTE: a sealed secret only decrypts on THIS cluster. Re-run after recreating the cluster."
