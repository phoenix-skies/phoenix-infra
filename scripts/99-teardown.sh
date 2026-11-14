#!/usr/bin/env bash
# Deletes the GKE cluster (stops credit usage). Sealed secrets must be re-created on a new cluster.
set -euo pipefail
source "$(dirname "$0")/env.sh"
gcloud container clusters delete "$CLUSTER" --zone "$ZONE" --quiet
