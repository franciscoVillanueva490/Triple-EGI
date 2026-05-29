#!/bin/bash
# ============================================================
#  EGI Inventario — Seed de bases de datos
#  Uso: bash scripts/seed-databases.sh
# ============================================================
 
set -e
 
NAMESPACE="inventario"
 
# Lee passwords desde los Secrets de Kubernetes
SA_PASSWORD=$(kubectl get secret ubicacion-db-secret \
  -n $NAMESPACE -o jsonpath='{.data.password}' | base64 --decode)
 
MONGO_USER=$(kubectl get secret inventario-db-secret \
  -n $NAMESPACE -o jsonpath='{.data.username}' | base64 --decode)
 
MONGO_PASSWORD=$(kubectl get secret inventario-db-secret \
  -n $NAMESPACE -o jsonpath='{.data.password}' | base64 --decode)
 
echo " [1/2] Cargando datos en SQL Server (ubicacion-db) "
SQL_POD=$(kubectl get pod -l app=ubicacion-db \
  -n $NAMESPACE -o jsonpath='{.items[0].metadata.name}')
 
echo "  Esperando que SQL Server esté disponible "
kubectl exec -n $NAMESPACE $SQL_POD -- \
  /bin/bash -c "until /opt/mssql-tools18/bin/sqlcmd -S localhost \
  -U sa -P '$SA_PASSWORD' -C -Q 'SELECT 1' &>/dev/null; \
  do sleep 3; done"
 
kubectl cp services/ubicacion-db/01_schema.sql \
  $NAMESPACE/$SQL_POD:/tmp/01_schema.sql
 
kubectl cp services/ubicacion-db/02_seed_data.sql \
  $NAMESPACE/$SQL_POD:/tmp/02_seed_data.sql
 
kubectl exec -n $NAMESPACE $SQL_POD -- \
  /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD" \
  -C -i /tmp/01_schema.sql
 
kubectl exec -n $NAMESPACE $SQL_POD -- \
  /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD" \
  -C -i /tmp/02_seed_data.sql
 
echo " SQL Server cargado."
 
echo "[2/2] Cargando datos en MongoDB (inventario-db)"
MONGO_POD=$(kubectl get pod -l app=inventario-db \
  -n $NAMESPACE -o jsonpath='{.items[0].metadata.name}')
 
# Copiar JSON y script de queries
kubectl cp services/inventario-db/equipos_hardware.json \
  $NAMESPACE/$MONGO_POD:/tmp/equipos_hardware.json
 
kubectl cp services/inventario-db/mongo_queries.js \
  $NAMESPACE/$MONGO_POD:/tmp/mongo_queries.js
 
# Importar los 8 documentos con mongoimport
kubectl exec -n $NAMESPACE $MONGO_POD -- \
  mongoimport \
    --username "$MONGO_USER" \
    --password "$MONGO_PASSWORD" \
    --authenticationDatabase admin \
    --db inventario_hardware \
    --collection equipos_hardware \
    --file /tmp/equipos_hardware.json \
    --jsonArray
 
echo " MongoDB cargado."
echo ""
echo "Seed completado correctamente."
