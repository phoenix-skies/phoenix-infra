#!/usr/bin/env bash
# Installs the CLIs Google Cloud Shell doesn't ship with: argocd, kubeseal, kubectl-argo-rollouts, yq.
# (Cloud Shell already has gcloud, kubectl, helm, git, docker.)
set -euo pipefail
mkdir -p "$HOME/bin"; cd "$HOME/bin"
curl -sSL -o argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
curl -sSL -o kubectl-argo-rollouts https://github.com/argoproj/argo-rollouts/releases/latest/download/kubectl-argo-rollouts-linux-amd64
curl -sSL -o yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
KS=0.27.1
curl -sSL https://github.com/bitnami-labs/sealed-secrets/releases/download/v${KS}/kubeseal-${KS}-linux-amd64.tar.gz | tar xz kubeseal
chmod +x argocd kubectl-argo-rollouts yq kubeseal
grep -q 'HOME/bin' ~/.bashrc || echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
export PATH="$HOME/bin:$PATH"
argocd version --client --short; kubectl-argo-rollouts version --short; yq --version; kubeseal --version
