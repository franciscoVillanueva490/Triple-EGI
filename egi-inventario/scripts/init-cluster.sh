#!/bin/bash
# ============================================================
#  EGI Inventario — Script de inicialización del clúster
#  Uso: bash scripts/init-cluster.sh
# ============================================================

set -e

echo "🚀 [1/5] Iniciando Minikube con CNI Calico..."
minikube start --cni=calico --memory=4096 --cpus=2

echo "⏳ [2/5] Esperando que Calico esté listo..."
kubectl wait --for=condition=ready pod -l k8s-app=calico-node \
  -n kube-system --timeout=120s

echo "📦 [3/5] Aplicando manifiestos base..."
kubectl apply -f kubernetes/base/

echo "🔒 [4/5] Aplicando Network Policies..."
kubectl apply -f kubernetes/network-policies/

echo "⏳ [5/5] Esperando pods en namespace inventario..."
kubectl wait --for=condition=ready pod --all \
  -n inventario --timeout=180s

echo ""
echo "✅ Ecosistema desplegado correctamente."
echo ""
echo "🌐 URL del frontend:"
minikube service inventario-web -n inventario --url
