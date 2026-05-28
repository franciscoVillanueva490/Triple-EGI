#!/bin/bash
# ============================================================
#  EGI Inventario — Seed de bases de datos
#  Uso: bash scripts/seed-databases.sh
# ============================================================

set -e

NAMESPACE="inventario"

echo "🗄️  [1/2] Cargando datos en SQL Server (ubicacion-db)..."
SQL_POD=$(kubectl get pod -l app=ubicacion-db -n $NAMESPACE -o jsonpath='{.items[0].metadata.name}')

kubectl cp services/ubicacion-db/01_schema.sql \
  $NAMESPACE/$SQL_POD:/tmp/01_schema.sql
kubectl cp services/ubicacion-db/02_seed_data.sql \
  $NAMESPACE/$SQL_POD:/tmp/02_seed_data.sql

kubectl exec -n $NAMESPACE $SQL_POD -- \
  /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD" \
  -i /tmp/01_schema.sql

kubectl exec -n $NAMESPACE $SQL_POD -- \
  /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD" \
  -i /tmp/02_seed_data.sql

echo "🍃 [2/2] Cargando datos en MongoDB (inventario-db)..."
MONGO_POD=$(kubectl get pod -l app=inventario-db -n $NAMESPACE -o jsonpath='{.items[0].metadata.name}')

kubectl cp services/inventario-db/mongo_queries.js \
  $NAMESPACE/$MONGO_POD:/tmp/mongo_queries.js

kubectl exec -n $NAMESPACE $MONGO_POD -- \
  mongosh < services/inventario-db/mongo_queries.js

echo "✅ Seed completado."
