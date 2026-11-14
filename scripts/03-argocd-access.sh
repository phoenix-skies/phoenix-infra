#!/usr/bin/env bash
# Day 8 — Argo CD RBAC + local users (student, release-manager) and the phoenix AppProject.
# Usage: STUDENT_PW=... RM_PW=... ./03-argocd-access.sh   (run from a folder next to phoenix-gitops)
set -euo pipefail
source "$(dirname "$0")/env.sh"
GITOPS_DIR="${GITOPS_DIR:-$(cd "$(dirname "$0")/../.." && pwd)/phoenix-gitops}"
STUDENT_PW="${STUDENT_PW:-Student@Phoenix1}"
RM_PW="${RM_PW:-Release@Phoenix1}"

kubectl apply -f "$GITOPS_DIR/argocd/argocd-rbac-cm.yaml"
kubectl -n argocd patch cm argocd-cm --type merge --patch-file "$GITOPS_DIR/argocd/argocd-cm-accounts.yaml"
kubectl apply -f "$GITOPS_DIR/argocd/project.yaml"
kubectl -n argocd rollout restart deploy/argocd-server
kubectl -n argocd rollout status deploy/argocd-server --timeout=3m

ADMIN_PW=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d)
SERVER=$(kubectl -n argocd get svc argocd-server -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
argocd login "$SERVER" --username admin --password "$ADMIN_PW" --insecure --grpc-web
argocd account update-password --account student --new-password "$STUDENT_PW" --current-password "$ADMIN_PW" --grpc-web
argocd account update-password --account release-manager --new-password "$RM_PW" --current-password "$ADMIN_PW" --grpc-web
echo "Users ready: student / $STUDENT_PW   release-manager / $RM_PW"
