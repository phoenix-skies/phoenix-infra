#!/usr/bin/env bash
# Creates a small zonal GKE Standard cluster that fits the $300 free trial (~6 vCPU).
# Takes 5-8 minutes. Delete it with 99-teardown.sh when you're done to save credits.
set -euo pipefail
source "$(dirname "$0")/env.sh"
gcloud config set project "$PROJECT_ID"
gcloud services enable container.googleapis.com
gcloud container clusters create "$CLUSTER" \
  --zone "$ZONE" \
  --num-nodes 3 \
  --machine-type e2-standard-2 \
  --disk-size 40 \
  --release-channel regular \
  --enable-ip-alias \
  --labels course=gitops-mastery,project=phoenix
gcloud container clusters get-credentials "$CLUSTER" --zone "$ZONE"
kubectl get nodes -o wide
