# inventario-web — Frontend

Aplicación web Node.js + React. Expone la interfaz de gestión del inventario.

## Variables de entorno requeridas

```env
SQL_HOST=ubicacion-db
SQL_PORT=1433
SQL_USER=sa
SQL_PASSWORD=<secret>
SQL_DATABASE=inventario_ubicacion

MONGO_URI=mongodb://inventario-db:27017/inventario_hardware

LDAP_URL=ldap://ldap-service:389
LDAP_BASE_DN=dc=itu,dc=edu
```

## Desarrollo local

```bash
npm install
npm run dev
```

## Docker

```bash
docker build -t inventario-web .
docker run -p 3000:3000 inventario-web
```
