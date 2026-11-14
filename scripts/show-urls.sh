#!/usr/bin/env bash
# Prints every URL and login you need for the demo.
ip () { kubectl -n "$1" get svc "$2" -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null; }
echo
echo "Argo CD : https://$(ip argocd argocd-server)   user: admin  pass: $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' 2>/dev/null | base64 -d)"
echo "Grafana : http://$(ip monitoring kube-prometheus-stack-grafana)   user: admin  pass: phoenix-grafana"
for env in dev qa prod; do
  echo "Phoenix $env : http://$(ip phoenix-$env phoenix-frontend)"
done
echo "(blank IP = LoadBalancer still provisioning; re-run in a minute)"
