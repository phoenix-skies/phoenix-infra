# Shared settings — edit PROJECT_ID before running anything.
export PROJECT_ID="${PROJECT_ID:-your-gcp-project-id}"
export REGION="${REGION:-asia-south1}"
export ZONE="${ZONE:-asia-south1-a}"
export CLUSTER="${CLUSTER:-phoenix}"
export GITHUB_ORG="${GITHUB_ORG:-phoenix-skies}"
export GITOPS_REPO="https://github.com/${GITHUB_ORG}/phoenix-gitops.git"
export PATH="$HOME/bin:$PATH"
