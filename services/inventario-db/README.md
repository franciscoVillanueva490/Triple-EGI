# inventario-db — MongoDB 7

Almacena los datos de hardware de cada equipo (CPU, RAM, disco, periféricos, SO).

## Archivos

| Archivo | Descripción |
|---------|-------------|
| `mongo_queries.js` | CRUD completo + agregaciones sobre la colección `equipos_hardware` |
| `seed/equipos.json` | Documentos de ejemplo para importar con `mongoimport` |

## Ejecución manual

```bash
# Acceder al shell de MongoDB
kubectl exec -it <pod-inventario-db> -n inventario -- mongosh

# Ejecutar el archivo de queries
kubectl exec -it <pod-inventario-db> -n inventario -- mongosh < mongo_queries.js

# Importar JSON con mongoimport
kubectl exec -it <pod-inventario-db> -n inventario -- \
  mongoimport --db inventario_hardware --collection equipos_hardware \
  --file /seed/equipos.json --jsonArray
```

## Estructura del documento

```json
{
  "_id": "EQ-001",
  "fabricante": "Dell",
  "modelo": "OptiPlex 7010",
  "tipo": "desktop | laptop",
  "cpu": { "marca", "modelo", "nucleos", "frecuencia_ghz" },
  "ram_gb": 16,
  "disco": { "tipo", "capacidad_gb" },
  "sistema_operativo": "...",
  "monitor": { ... } | null,
  "mouse": "..." | null,
  "teclado": "...",
  "bateria": { "capacidad_mwh", "ciclos" } | null
}
```
