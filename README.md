# phoenix-infra
# Phoenix-infra
Terraform for the Phoenix Skies platform on Google Cloud (Mumbai, `asia-south1`).
Owned by the `devops` team; every change goes through a pull request.

## Layout

```
bootstrap/bootstrap.sh       one-time: projects, billing, Terraform state bucket
modules/project-services/    enables Google Cloud APIs
modules/network/             VPC, GKE subnet, Cloud NAT, private service access
envs/nonprod/                dev + staging (one GCP project, one cluster)
envs/prod/                   production (separate GCP project)
```

Coming next: `modules/gke`, `modules/cloudsql`, `modules/redis`, `modules/pubsub`,
`modules/storage`, `modules/registry`.

## Network plan

| Environment | Nodes          | Pods           | Services       |
|-------------|----------------|----------------|----------------|
| nonprod     | 10.10.0.0/20   | 10.20.0.0/16   | 10.30.0.0/20   |
| prod        | 10.40.0.0/20   | 10.50.0.0/16   | 10.60.0.0/20   |

## First run

```bash
# 1. Log in (Terraform uses the application-default credentials)
gcloud auth login
gcloud auth application-default login

# 2. Bootstrap: projects, billing, state bucket
gcloud billing accounts list
BILLING_ACCOUNT=XXXXXX-XXXXXX-XXXXXX ./bootstrap/bootstrap.sh

# 3. Put the printed project IDs into envs/*/terraform.tfvars

# 4. Non-prod first
cd envs/nonprod
terraform init -backend-config="bucket=phoenix-tfstate-<suffix>"
terraform fmt -check -recursive ../..
terraform validate
terraform plan -out=tfplan
terraform apply tfplan

# 5. Then prod, the same way, from envs/prod
```

## Rules

- Never apply from a laptop to prod once CI is in place; plans run on pull requests.
- Commit `.terraform.lock.hcl` so everyone uses the same provider versions.
- No secrets in this repo. Secrets live in Secret Manager.

## Cost note

This step (APIs, VPC, subnet, Cloud NAT) costs very little; Cloud NAT is the
only item billed by the hour. The GKE clusters and Cloud SQL in the next steps
are where real cost starts. Destroy non-prod when you are not using it.
