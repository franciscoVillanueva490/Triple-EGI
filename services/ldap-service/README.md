# ldap-service — OpenLDAP

Centraliza la autenticación de usuarios (alumnos, docentes, técnicos, admins).

## Puertos

| Puerto | Protocolo | Uso |
|--------|-----------|-----|
| 389 | LDAP | Autenticación estándar (interna) |
| 636 | LDAPS | Autenticación TLS |

## Estructura del árbol LDAP

```
dc=itu,dc=edu
├── ou=alumnos
│   └── cn=jperez, cn=mgomez, ...
├── ou=docentes
│   └── cn=dlopez, cn=asmith, ...
├── ou=tecnicos
│   └── cn=cmartinez, ...
└── ou=admins
    └── cn=admin, ...
```

## Roles de la aplicación

| Rol LDAP | Permisos en la app |
|----------|--------------------|
| alumno | Solo lectura |
| docente | Solo lectura |
| tecnico | Panel completo |
| admin | Panel completo |
