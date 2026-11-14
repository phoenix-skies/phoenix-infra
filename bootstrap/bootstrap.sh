#!/usr/bin/env bash
# =============================================================================
# One-time bootstrap for Phoenix Skies on Google Cloud.
# Creates what Terraform itself needs before it can run:
#   - two GCP projects: phoenix-nonprod-<suffix> and phoenix-prod-<suffix>
#   - billing linked to both
#   - a versioned GCS bucket for Terraform state
#
# Usage:
#   gcloud auth login
#   gcloud auth application-default login      # Terraform uses these credentials
#   gcloud billing accounts list               # copy your billing account ID
#   BILLING_ACCOUNT=XXXXXX-XXXXXX-XXXXXX ./bootstrap/bootstrap.sh
#
# Optional: SUFFIX=dq01 to choose the suffix (project IDs are globally unique).
# =============================================================================
set -euo pipefail

: "${BILLING_ACCOUNT:?Set BILLING_ACCOUNT, e.g. BILLING_ACCOUNT=XXXXXX-XXXXXX-XXXXXX}"
SUFFIX="${SUFFIX:-$(openssl rand -hex 2)}"
REGION="asia-south1"

NONPROD="phoenix-nonprod-${SUFFIX}"
PROD="phoenix-prod-${SUFFIX}"
STATE_BUCKET="phoenix-tfstate-${SUFFIX}"

for project in "$NONPROD" "$PROD"; do
  echo ">> Creating project $project"
  gcloud projects create "$project" --name="$project"
  gcloud billing projects link "$project" --billing-account="$BILLING_ACCOUNT"
done

echo ">> Creating Terraform state bucket gs://$STATE_BUCKET (in $NONPROD)"
gcloud services enable storage.googleapis.com --project="$NONPROD"
gcloud storage buckets create "gs://$STATE_BUCKET" \
  --project="$NONPROD" \
  --location="$REGION" \
  --uniform-bucket-level-access \
  --public-access-prevention
gcloud storage buckets update "gs://$STATE_BUCKET" --versioning

cat <<EOF

Bootstrap complete. Put these values in envs/*/terraform.tfvars:

  nonprod project_id = "$NONPROD"
  prod    project_id = "$PROD"

Initialise each environment with:

  cd envs/nonprod && terraform init -backend-config="bucket=$STATE_BUCKET"
  cd envs/prod    && terraform init -backend-config="bucket=$STATE_BUCKET"
EOF
