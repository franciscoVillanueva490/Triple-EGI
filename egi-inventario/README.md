# 🖥️ EGI Inventario — Ecosistema de Inventario Seguro

Proyecto integrador para las materias **Computación en la Nube**, **Base de Datos Avanzadas** y **Sistemas Operativos Avanzados** — ITU.

## 📐 Arquitectura

```
Usuarios externos
      │ HTTP :80 / HTTPS :443
      ▼
Firewall perimetral (GUFW)  ←── ALLOW TCP :30080
      │
      ▼
┌─────────────────────────────────────────────┐
│  namespace: inventario  │  CNI: Calico       │
│                                             │
│  [inventario-web]  Node.js/React :3000      │
│       │TCP:1433    │TCP:27017   │TCP:389     │
│       ▼            ▼           ▼            │
│  [ubicacion-db] [inventario-db] [ldap-svc]  │
│  SQL Server:1433  MongoDB:27017  LDAP:389   │
└─────────────────────────────────────────────┘
```

## 📁 Estructura del Repositorio

```
egi-inventario/
├── docs/
│   ├── esquemas/          # Arquitectura, reglas de red, modelo de BD
│   └── diagramas/         # Flujograma de la aplicación
├── kubernetes/
│   ├── base/              # Deployments, Services, ConfigMaps, Secrets
│   └── network-policies/  # NetworkPolicies Zero-Trust (Calico)
├── services/
│   ├── inventario-web/    # Frontend Node.js + React
│   ├── ubicacion-db/      # SQL Server — schema + seed data
│   ├── inventario-db/     # MongoDB — queries + seed JSON
│   └── ldap-service/      # OpenLDAP — configuración + usuarios
├── scripts/               # Scripts de inicialización y utilidades
└── .github/
    └── ISSUE_TEMPLATE/    # Templates para issues de cada integrante
```

## 🚀 Inicio Rápido

```bash
# 1. Clonar el repositorio
git clone https://github.com/<org>/egi-inventario.git
cd egi-inventario

# 2. Iniciar Minikube con CNI Calico
minikube start --cni=calico

# 3. Aplicar todos los manifiestos
kubectl apply -f kubernetes/base/
kubectl apply -f kubernetes/network-policies/

# 4. Verificar pods
kubectl get pods -n inventario

# 5. Obtener URL del frontend
minikube service inventario-web -n inventario --url
```

## 👥 Equipo y Responsabilidades

| Integrante | Área |
|------------|------|
| Integrante 1 | Arquitectura Kubernetes + Network Policies |
| Integrante 2 | Base de datos SQL Server (ubicacion-db) |
| Integrante 3 | Base de datos MongoDB (inventario-db) |
| Integrante 4 | Frontend — inventario-web |
| Integrante 5 | LDAP + Firewall GUFW + Documentación |

## 📋 Entregables

- [x] Esquema de arquitectura de servicios
- [x] Diagrama de base de datos (SQL Server)
- [x] Flujograma de la aplicación
- [ ] Manifiestos Kubernetes completos
- [ ] Aplicación web funcional
- [ ] Ecosistema funcional en Minikube
- [ ] Presentación (.pptx)

## 🔗 Servicios y Puertos

| Servicio | Puerto ClusterIP | NodePort | Protocolo |
|----------|-----------------|----------|-----------|
| inventario-web | 3000 | 30080 | TCP |
| ubicacion-db | 1433 | — | TCP |
| inventario-db | 27017 | — | TCP |
| ldap-service | 389 / 636 | — | TCP |
