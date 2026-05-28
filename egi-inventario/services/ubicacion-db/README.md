# ubicacion-db — SQL Server 2022

Almacena la ubicación de los equipos (aula, banco, estado) y las asignaciones a usuarios.

## Archivos

| Archivo | Descripción |
|---------|-------------|
| `01_schema.sql` | Creación de tablas: aulas, usuarios, equipos, asignaciones |
| `02_seed_data.sql` | Datos de ejemplo + queries de verificación |

## Ejecución manual

```bash
# Acceder al pod
kubectl exec -it <pod-ubicacion-db> -n inventario -- /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $SA_PASSWORD

# Ejecutar scripts
kubectl exec -i <pod-ubicacion-db> -n inventario -- /opt/mssql-tools/bin/sqlcmd \
  -S localhost -U sa -P $SA_PASSWORD < 01_schema.sql
```

## Modelo de datos

- **aulas**: espacios físicos (nombre, edificio, capacidad)
- **usuarios**: sincronizados desde LDAP (username, email, rol, ldap_dn)
- **equipos**: cada computadora, vinculada a un aula y con `mongo_id` para cruzar con MongoDB
- **asignaciones**: relación equipo ↔ usuario con período de tiempo
