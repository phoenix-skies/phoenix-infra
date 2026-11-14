#!/usr/bin/env bash
# Installs the platform: Argo CD, Argo Rollouts, Sealed Secrets, Prometheus + Grafana.
# Idempotent: safe to re-run.
set -euo pipefail
source "$(dirname "$0")/env.sh"

echo "==> Argo CD"
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -n argocd --server-side --force-conflicts -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl -n argocd patch svc argocd-server -p '{"spec":{"type":"LoadBalancer"}}'

echo "==> Argo Rollouts"
kubectl create namespace argo-rollouts --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml

echo "==> Sealed Secrets"
helm repo add sealed-secrets https://bitnami-labs.github.io/sealed-secrets >/dev/null
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts >/dev/null
helm repo update >/dev/null
helm upgrade --install sealed-secrets sealed-secrets/sealed-secrets \
  -n kube-system --set fullnameOverride=sealed-secrets-controller --wait

echo "==> Prometheus + Grafana (kube-prometheus-stack)"
helm upgrade --install kube-prometheus-stack prometheus-community/kube-prometheus-stack \
  -n monitoring --create-namespace \
  --set prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues=false \
  --set prometheus.prometheusSpec.podMonitorSelectorNilUsesHelmValues=false \
  --set prometheus.prometheusSpec.retention=2d \
  --set grafana.service.type=LoadBalancer \
  --set grafana.adminPassword=phoenix-grafana \
  --set grafana.sidecar.dashboards.enabled=true \
  --set grafana.sidecar.dashboards.searchNamespace=ALL \
  --set alertmanager.enabled=false \
  --wait --timeout 10m

echo "==> Waiting for Argo CD"
kubectl -n argocd rollout status deploy/argocd-server --timeout=5m
kubectl -n argocd rollout status deploy/argocd-repo-server --timeout=5m
kubectl -n argocd rollout status deploy/argocd-applicationset-controller --timeout=5m
"$(dirname "$0")/show-urls.sh"
