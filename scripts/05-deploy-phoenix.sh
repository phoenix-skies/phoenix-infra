#!/usr/bin/env bash
# Hands Phoenix to Argo CD. TRACK=helm (default: App of Apps + ApplicationSet, Day 6+)
#                           TRACK=kustomize (Day 4/5 Applications)
set -euo pipefail
source "$(dirname "$0")/env.sh"
GITOPS_DIR="${GITOPS_DIR:-$(cd "$(dirname "$0")/../.." && pwd)/phoenix-gitops}"
TRACK="${TRACK:-helm}"
kubectl apply -f "$GITOPS_DIR/argocd/project.yaml"
if [ "$TRACK" = kustomize ]; then
  kubectl apply -f "$GITOPS_DIR/argocd/kustomize-apps/"
else
  kubectl apply -f "$GITOPS_DIR/argocd/root-app.yaml"
fi
sleep 10
kubectl -n argocd get applications
