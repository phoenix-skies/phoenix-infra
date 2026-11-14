# phoenix-infra

Bootstrap scripts for the Phoenix platform. Run them in **Google Cloud Shell**, in order:

| Script | What it does | Course day |
|---|---|---|
| `scripts/env.sh` | Project, zone, cluster name. **Edit `PROJECT_ID` first** | |
| `00-install-tools.sh` | argocd, kubeseal, kubectl-argo-rollouts, yq | 1 |
| `01-create-gke.sh` | 3 × e2-standard-2 zonal GKE cluster (fits free trial) | 1 |
| `02-bootstrap-platform.sh` | Argo CD, Argo Rollouts, Sealed Secrets, kube-prometheus-stack | 3, 8, 9 |
| `03-argocd-access.sh` | AppProject, RBAC, users `student` / `release-manager` | 8 |
| `04-seal-db-secrets.sh` | Seals a DB password per env into `values-<env>.yaml` | 8 |
| `05-deploy-phoenix.sh` | Applies the root app (Helm) or `TRACK=kustomize` apps | 3–6 |
| `show-urls.sh` | Argo CD / Grafana / storefront URLs and logins | |
| `99-teardown.sh` | Deletes the cluster | |

`kind/kind-config.yaml` gives you a local cluster for Days 1–5.

The scripts expect `phoenix-gitops` to be cloned next to this repo. Otherwise set `GITOPS_DIR=/path/to/phoenix-gitops`.

Only the platform is installed imperatively, once. Everything Phoenix-specific is reconciled by Argo CD from `phoenix-gitops`.
