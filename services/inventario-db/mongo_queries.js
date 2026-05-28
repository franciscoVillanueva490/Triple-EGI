// ============================================================
//  EGI Inventario — Operaciones MongoDB
//  Ejecutar desde el shell del contenedor:
//  kubectl exec -it <pod-mongo> -- mongosh < mongo_queries.js
//  Archivo: mongo_queries.js
// ============================================================

// Conexión a la base de datos
use("inventario_hardware");

// ── 1. INSERTAR documentos (importar el JSON completo) ──────
// Normalmente se hace con mongoimport, pero también se puede
// insertar individualmente:
db.equipos_hardware.insertMany([
  {
    _id: "EQ-001",
    fabricante: "Dell",
    modelo: "OptiPlex 7010",
    tipo: "desktop",
    cpu: { marca: "Intel", modelo: "Core i5-12500", nucleos: 6, frecuencia_ghz: 3.0 },
    ram_gb: 16,
    disco: { tipo: "SSD", capacidad_gb: 512 },
    sistema_operativo: "Ubuntu 22.04 LTS",
    monitor: { marca: "Dell", modelo: "P2422H", pulgadas: 24 },
    mouse: "Dell MS116",
    teclado: "Dell KB216",
    bateria: null
  },
  {
    _id: "EQ-004",
    fabricante: "Lenovo",
    modelo: "ThinkPad E15 Gen4",
    tipo: "laptop",
    cpu: { marca: "AMD", modelo: "Ryzen 5 5625U", nucleos: 6, frecuencia_ghz: 2.3 },
    ram_gb: 16,
    disco: { tipo: "NVMe", capacidad_gb: 512 },
    sistema_operativo: "Ubuntu 22.04 LTS",
    monitor: null,
    mouse: null,
    teclado: "integrado",
    bateria: { capacidad_mwh: 57000, ciclos: 142 }
  }
]);

// ── 2. BÚSQUEDAS filtradas ───────────────────────────────────

// Todos los desktops
db.equipos_hardware.find({ tipo: "desktop" });

// Laptops con más de 8 GB de RAM
db.equipos_hardware.find(
  { tipo: "laptop", ram_gb: { $gt: 8 } },
  { fabricante: 1, modelo: 1, ram_gb: 1, sistema_operativo: 1 }
);

// Equipos con disco SSD o NVMe
db.equipos_hardware.find(
  { "disco.tipo": { $in: ["SSD", "NVMe"] } }
);

// Equipos con CPU Intel y 6+ núcleos
db.equipos_hardware.find({
  "cpu.marca": "Intel",
  "cpu.nucleos": { $gte: 6 }
});

// Buscar por ID específico (el que viene del frontend)
db.equipos_hardware.findOne({ _id: "EQ-001" });

// ── 3. ACTUALIZAR registros ──────────────────────────────────

// Actualizar sistema operativo de un equipo
db.equipos_hardware.updateOne(
  { _id: "EQ-001" },
  { $set: { sistema_operativo: "Ubuntu 24.04 LTS" } }
);

// Agregar GPU a un equipo (campo opcional nuevo)
db.equipos_hardware.updateOne(
  { _id: "EQ-008" },
  { $set: { gpu: { marca: "NVIDIA", modelo: "RTX A2000", vram_gb: 12 } } }
);

// Incrementar ciclos de batería en todos los laptops
db.equipos_hardware.updateMany(
  { tipo: "laptop" },
  { $inc: { "bateria.ciclos": 1 } }
);

// ── 4. ELIMINAR datos específicos ────────────────────────────

// Dar de baja un equipo específico
db.equipos_hardware.deleteOne({ _id: "EQ-007" });

// Eliminar todos los equipos dados de baja (si tuvieran campo estado)
// db.equipos_hardware.deleteMany({ estado: "baja" });

// ── 5. AGREGACIONES útiles ───────────────────────────────────

// Contar equipos por tipo
db.equipos_hardware.aggregate([
  { $group: { _id: "$tipo", total: { $sum: 1 } } }
]);

// RAM promedio por fabricante
db.equipos_hardware.aggregate([
  { $group: {
    _id: "$fabricante",
    ram_promedio: { $avg: "$ram_gb" },
    cantidad: { $sum: 1 }
  }},
  { $sort: { ram_promedio: -1 } }
]);
