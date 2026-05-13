Este es el Prompt Maestro Final Ultra-Extendido. He expandido cada fase del
desarrollo, detallado las reglas de negocio específicas de la franquicia y
estructurado las tablas de base de datos con un nivel de detalle técnico
superior.

```
lib/
├── core/
│   ├── constants/             # AppColors, AppStrings, AssetsPath
│   ├── theme/                 # SimiTheme (Configuración Material 3)
│   ├── utils/                 # Formateadores (MXN, fechas) y validadores
│   └── network/               # Configuración inicial de Firebase
├── data/                      # CAPA DE DATOS (Implementación)
│   ├── models/                # DTOs (MedicamentoModel, VentaModel, etc.)
│   │   └── mappers/           # Conversores Entity <-> Model
│   ├── repositories_impl/     # Implementación real de Firestore
│   └── sources/               # RemoteDataSource (Llamadas a Firebase SDK)
├── domain/                    # CAPA DE NEGOCIO (Reglas puras)
│   ├── entities/              # Clases puras (Medicamento, Cliente)
│   ├── repositories/          # Interfaces (Contratos)
│   └── usecases/              # Lógica: (RealizarVenta, CalcularPuntos)
├── presentation/              # CAPA DE INTERFAZ (UI)
│   ├── providers/             # Estado global (CartProvider, AuthProvider)
│   ├── screens/               # Vistas por módulo:
│   │   ├── auth/              # Login y Registro
│   │   ├── pos/               # Punto de Venta (Caja)
│   │   ├── inventory/         # Medicamentos y Souvenirs
│   │   └── staff/             # Gestión de Empleados y Proveedores
│   └── widgets/               # SimiButton, SimiTextField, ProductCard
└── main.dart                  # Punto de entrada y Firebase setup
```

Este documento está listo para ser pegado en un README.md de GitHub o entregado
a una IA de alto nivel para generar el código.

🏥 SimiApp Pro: Especificación Técnica y Roadmap de Desarrollo

Sistema de Gestión Integral para Franquicias de Farmacias Similares

Este documento detalla la arquitectura, el modelo de datos y el flujo de trabajo
para construir una aplicación de nivel empresarial utilizando Flutter y
Firebase.

🎨 1. Manual de Identidad Visual (UI/UX)

Para garantizar el reconocimiento de marca, la aplicación debe adherirse
estrictamente a la siguiente paleta:

| Elemento                | Hex Code  | Uso en la Interfaz                                                         |
| :---------------------- | :-------- | :------------------------------------------------------------------------- |
| **Verde Institucional** | `#009640` | Color primario, AppBars, botones de "Finalizar Venta", estados activos.    |
| **Azul Simi**           | `#00468C` | Color secundario, iconos de categorías médicas, botones de "Ver Detalles". |
| **Amarillo Similandia** | `#FFD100` | Acento, banners de "Lunes de Descuento", badges de stock bajo, alertas.    |
| **Blanco Clínico**      | `#FFFFFF` | Fondos de tarjetas, diálogos y superficies limpias.                        |
| **Gris Neutro**         | `#F8F9FA` | Fondo de la aplicación para reducir la fatiga visual.                      |
| **Rojo Alerta**         | `#D32F2F` | Errores críticos, eliminación de registros, caducidad vencida.             |

Principios de Diseño:

  - Material 3: Uso de componentes modernos con elevaciones sutiles.
  - Tipografía: GoogleFonts.montserrat() para títulos y GoogleFonts.roboto()
    para cuerpos de texto.
  - Micro-interacciones: Animaciones suaves al agregar productos al carrito.

📂 2. Arquitectura de Software (Estructura de Carpetas)

Se implementa Clean Architecture para separar las preocupaciones y facilitar el
testing unitario.



🗄️ 3. Arquitectura de Datos (Cloud Firestore)

Estructura de colecciones diseñada para consultas rápidas y consistencia de
datos.

A. Colección: medicamentos

| Campo              | Tipo      | Índice | Descripción                        |
| :----------------- | :-------- | :----- | :--------------------------------- |
| `id`               | String    | PK     | UUID generado automáticamente      |
| `codigo_barras`    | String    | Unique | EAN-13 del producto                |
| `nombre_comercial` | String    | Search | Nombre visible al cliente          |
| `nombre_generico`  | String    | Search | Compuesto activo (Ej: Paracetamol) |
| `precio_venta`     | Double    | \-     | Precio actual (MXN)                |
| `stock_actual`     | Int       | \-     | Cantidad en almacén                |
| `stock_minimo`     | Int       | \-     | Gatillo para alerta de resurtido   |
| `requiere_receta`  | Bool      | \-     | Restricción legal de venta         |
| `fecha_caducidad`  | Timestamp | Index  | Para control de mermas             |

B. Colección: ventas (Estructura Maestro-Detalle)

| Campo         | Tipo        | Descripción                                   |
| :------------ | :---------- | :-------------------------------------------- |
| `id`          | String      | Folio de venta único                          |
| `fecha`       | Timestamp   | Fecha y hora del servidor                     |
| `items`       | List<Map>   | `[{prod_id, cant, precio_unit, subtotal}]`    |
| `total`       | Double      | Monto final después de descuentos e impuestos |
| `metodo_pago` | String      | `Efectivo`, `Tarjeta`, `Transferencia`        |
| `cliente_id`  | DocumentRef | Relación con la colección de Clientes         |
| `vendedor_id` | DocumentRef | Relación con la colección de Empleados        |

C. Colección: clientes (Fidelización)

| Campo               | Tipo      | Descripción                               |
| :------------------ | :-------- | :---------------------------------------- |
| `telefono`          | String    | ID principal para búsqueda en caja        |
| `nombre`            | String    | Nombre del beneficiario                   |
| `simipuntos`        | Int       | Acumulación de lealtad (1 pto x cada $10) |
| `historial_compras` | List<Ref> | Referencias a sus últimas 10 ventas       |

📦 4. Stack Tecnológico (Dependencias)

Añadir estas líneas al archivo pubspec.yaml:

dependencies:


🗃️ ESQUEMA DE BASE DE DATOS (COLECCIONES FIRESTORE):
Firestore es NoSQL. Usa referencias documentales (`DocumentReference`) o strings de ID para relaciones. Genera las siguientes tablas en formato Markdown. Para cada colección, especifica: Campo, Tipo, PK/Índice, Relación, Restricción/Nota.

| Colección | Campo | Tipo | PK/Índice | Relación | Restricción / Nota |
|---|---|---|---|---|---|
| `empleados` | `uid` | String | PK | - | Vinculado a Firebase Auth |
| `empleados` | `nombre` | String | Índice texto | - | Requerido |
| `empleados` | `email` | String | Índice único | - | Formato email válido |
| `empleados` | `rol` | String | Índice | - | `admin`, `farmacia`, `cajero` |
| `empleados` | `telefono` | String | - | - | Máscara +52 |
| `empleados` | `activo` | Bool | Índice | - | `false` bloquea acceso |
| `empleados` | `created_at` | Timestamp | - | - | Automático |
| `clientes` | `id` | String | PK | - | UUID v4 |
| `clientes` | `nombre` | String | Índice texto | - | Requerido |
| `clientes` | `email` | String | - | - | Opcional |
| `clientes` | `telefono` | String | Índice | - | Búsqueda principal |
| `clientes` | `rfc` | String | - | - | 12-13 caracteres |
| `clientes` | `direccion` | String | - | - | Texto libre |
| `clientes` | `puntos` | Int | - | - | Programa fidelidad |
| `clientes` | `activo` | Bool | Índice | - | `true` por defecto |
| `clientes` | `created_at` | Timestamp | - | - | Automático |
| `proveedores` | `id` | String | PK | - | UUID v4 |
| `proveedores` | `razon_social` | String | Índice | - | Requerido |
| `proveedores` | `contacto` | String | - | - | Persona física |
| `proveedores` | `email` | String | - | - | Validado |
| `proveedores` | `telefono` | String | Índice | - | Requerido |
| `proveedores` | `rfc` | String | Índice único | - | Fiscal |
| `proveedores` | `activo` | Bool | Índice | - | Control de compras |
| `medicamentos` | `id` | String | PK | - | UUID v4 |
| `medicamentos` | `nombre` | String | Índice texto | - | Comercial/Genérico |
| `medicamentos` | `codigo_barras` | String | Índice único | - | EAN13/UPC |
| `medicamentos` | `categoria_id` | String | Índice | 1:N `categorias` | Clasificación |
| `medicamentos` | `precio_compra` | Double | - | - | >= 0 |
| `medicamentos` | `precio_venta` | Double | - | - | > precio_compra |
| `medicamentos` | `stock` | Int | - | - | >= 0 |
| `medicamentos` | `stock_min` | Int | - | - | Alerta automática |
| `medicamentos` | `proveedor_id` | String | Índice | 1:N `proveedores` | Origen |
| `medicamentos` | `requiere_receta` | Bool | - | - | Control sanitario |
| `medicamentos` | `vencimiento` | Timestamp | Índice | - | Alerta si < 30 días |
| `medicamentos` | `activo` | Bool | Índice | - | Baja lógica |
| `productos_souvenirs` | `id` | String | PK | - | UUID v4 |
| `productos_souvenirs` | `nombre` | String | Índice texto | - | Requerido |
| `productos_souvenirs` | `codigo_barras` | String | Índice único | - | EAN13/UPC |
| `productos_souvenirs` | `categoria_id` | String | Índice | 1:N `categorias` | Clasificación |
| `productos_souvenirs` | `precio_compra` | Double | - | - | >= 0 |
| `productos_souvenirs` | `precio_venta` | Double | - | - | > precio_compra |
| `productos_souvenirs` | `stock` | Int | - | - | >= 0 |
| `productos_souvenirs` | `stock_min` | Int | - | - | Alerta automática |
| `productos_souvenirs` | `proveedor_id` | String | Índice | 1:N `proveedores` | Origen |
| `productos_souvenirs` | `activo` | Bool | Índice | - | Baja lógica |
| `ventas` | `id` | String | PK | - | UUID v4 o folio autoincremental |
| `ventas` | `cliente_id` | String | Índice | 1:N `clientes` | Nullable para venta anónima |
| `ventas` | `empleado_id` | String | Índice | 1:N `empleados` | Cajero/Farmacéutico |
| `ventas` | `fecha` | Timestamp | Índice | - | Zona horaria local |
| `ventas` | `subtotal` | Double | - | - | Suma items |
| `ventas` | `iva` | Double | - | - | 16% fijo |
| `ventas` | `total` | Double | - | - | subtotal + iva |
| `ventas` | `metodo_pago` | String | Índice | - | `efectivo`, `tarjeta`, `transferencia` |
| `ventas` | `estado` | String | Índice | - | `completada`, `cancelada`, `pendiente` |
| `ventas` | `items` | Array<Map> | - | - | `{item_id, tipo, cantidad, precio_unit, subtotal}` |
| `ventas` | `created_at` | Timestamp | - | - | Inmutable |
| `inventario_movimientos` | `id` | String | PK | - | UUID v4 |
| `inventario_movimientos` | `producto_id` | String | Índice | - | Medicamento o Souvenir |
| `inventario_movimientos` | `tipo` | String | Índice | - | `entrada`, `salida`, `ajuste`, `merma` |
| `inventario_movimientos` | `cantidad` | Int | - | - | Positivo o negativo |
| `inventario_movimientos` | `motivo` | String | - | - | Texto libre |
| `inventario_movimientos` | `empleado_id` | String | Índice | 1:N `empleados` | Responsable |
| `inventario_movimientos` | `fecha` | Timestamp | Índice | - | Timestamp |
| `alertas_stock` | `id` | String | PK | - | UUID v4 |
| `alertas_stock` | `producto_id` | String | Índice | - | Referencia |
| `alertas_stock` | `tipo_producto` | String | Índice | - | `medicamento` o `souvenir` |
| `alertas_stock` | `umbral` | Int | - | - | `stock_min` original |
| `alertas_stock` | `stock_actual` | Int | - | - | Captura al momento |
| `alertas_stock` | `leido` | Bool | Índice | - | `false` por defecto |
| `alertas_stock` | `created_at` | Timestamp | - | - | Automático |
| `categorias` | `id` | String | PK | - | UUID v4 |
| `categorias` | `nombre` | String | Índice único | - | Ej: `Analgésicos`, `Juguetes` |
| `categorias` | `tipo` | String | Índice | - | `medicamento` o `souvenir` |
| `categorias` | `activo` | Bool | Índice | - | `true` |
| `configuracion_tienda` | `id` | String | PK (único doc) | - | `global_config` |
| `configuracion_tienda` | `nombre_sucursal` | String | - | - | Identificador |
| `configuracion_tienda` | `rfc` | String | - | - | Fiscal |
| `configuracion_tienda` | `iva_porcentaje` | Double | - | - | `0.16` |
| `configuracion_tienda` | `logo_url` | String | - | - | Firebase Storage |
| `configuracion_tienda` | `updated_at` | Timestamp | - | - | Última modificación |

🎨 IDENTIDAD VISUAL & UI (FARMACIAS SIMILARES):
- Primary: `#009640` (Verde institucional)
- Secondary/Acento: `#FFD100` (Amarillo/Dorado)
- Background: `#F8F9FA` | Surface: `#FFFFFF`
- Text/OnPrimary: `#1A1A1A` | Error: `#E53935` | Success: `#4CAF50`
- Implementar Material 3: `ColorScheme.fromSeed(seedColor: Color(0xFF009640))`
- Overrides: AppBar verde sólido, botones primarios verdes, secundarios amarillos, cards con `elevation: 2`, badges de alerta en rojo/amarillo, inputs con `border: OutlineInputBorder`
- Tipografía: `GoogleFonts.inter()` (fallback `Roboto`), jerarquía clara H1→Caption
- Responsive: `LayoutBuilder` + `MediaQuery`, breakpoints: mobile ≤600, tablet 601-840, desktop ≥841
- Componentes obligatorios: `PrimaryButton`, `SecondaryButton`, `CustomTextField`, `DataTablePaginated`, `StatusBadge`, `EmptyStateWidget`, `LoadingOverlay`, `SnackbarManager`

📦 DEPENDENCIAS (`pubspec.yaml`):
Entrega el bloque exacto. Usa versiones compatibles con Flutter 3.16+.
```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^2.24.0
  cloud_firestore: ^4.14.0
  firebase_auth: ^4.16.0
  firebase_storage: ^11.6.0
  provider: ^6.1.1
  go_router: ^13.2.0
  flutter_form_builder: ^9.1.1
  form_builder_validators: ^9.1.0
  intl: ^0.19.0
  mobile_scanner: ^4.0.0
  pdf: ^3.10.8
  printing: ^5.12.0
  uuid: ^4.2.2
  cached_network_image: ^3.3.1
  shared_preferences: ^2.2.2
  flutter_svg: ^2.0.9
  google_fonts: ^6.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
  mockito: ^5.4.4
  build_runner: ^2.4.8

  # Firebase Core
  firebase_core: ^2.24.2
  cloud_firestore: ^4.14.0
  firebase_auth: ^4.16.0
  firebase_storage: ^11.6.0

  # State Management & Architecture
  provider: ^6.1.1
  get_it: ^7.6.4 # Service Locator para Clean Architecture

  # UI & UX
  google_fonts: ^6.1.0
  font_awesome_flutter: ^10.6.0
  flutter_spinkit: ^5.2.0 # Loaders profesionales
  
  # Utils
  intl: ^0.18.1 # Formateo de moneda y fechas
  uuid: ^4.2.2 # Generación de folios
  cached_network_image: ^3.3.0 # Imágenes de souvenirs
```

🛠️ 5. Guía de Desarrollo Paso a Paso (Roadmap Extenso)

Fase 1: Configuración del Ecosistema (Backend)

1.  Firebase Setup: Crear proyecto en Firebase Console. Vincular Apps Android e
    iOS.
2.  Auth Setup: Configurar autenticación por Email/Password. Crear manualmente
    el primer usuario admin@simiapp.com.
3.  Firestore Security Rules: Implementar reglas que solo permitan escribir
    ventas a empleados autenticados.
4.  Storage: Crear carpetas para productos/ y empleados/ para almacenar
    fotografías.

Fase 2: Capa de Dominio y Modelado (La Lógica)

1.  Entidades: Crear clases Medicamento y Venta en la capa de dominio.
2.  Mappers: Escribir la lógica para convertir un QuerySnapshot de Firebase en
    un objeto de Dart usable.
3.  Regla de Negocio "Lunes de Simi": Crear un UseCase que obtenga el día de la
    semana y, si es lunes, aplique un -25% al subtotal de los productos
    seleccionados.

Fase 3: Integración de Datos (Repositories)

1.  Implementación de Firestore: Crear el FirestoreInventoryRepository para leer
    productos en tiempo real mediante Streams.
2.  Transacciones de Venta: Implementar runTransaction en Firestore. Al
    registrar una venta:
      - Se crea el documento en /ventas.
      - Se actualiza el campo stock_actual en /medicamentos.
      - Se suman los simipuntos al cliente en /clientes.
      - Todo esto ocurre en una sola operación atómica para evitar errores de
        inventario.

Fase 4: Desarrollo de la Interfaz de Usuario (UI)

1.  Pantalla POS (Punto de Venta):
      - Buscador de productos por nombre o escaneo de código de barras.
      - Lista lateral del carrito de compras.
      - Botón de "Cobrar" que abre un modal con el desglose de IVA y puntos
        ganados.
2.  Módulo de Inventario:
      - Vista de tabla con indicadores de color: Rojo (Agotado), Amarillo (Stock
        Bajo), Verde (Suficiente).
      - Formulario para agregar nuevos medicamentos con validación de campos
        obligatorios.
3.  Sección de Souvenirs: Galería de imágenes estilo e-commerce para los
    peluches y productos Similandia.

Fase 5: Testing y Pulido

1.  Pruebas Unitarias: Validar que el cálculo del IVA y los descuentos de los
    lunes funcionen correctamente.
2.  Modo Offline: Configurar la persistencia de Firestore para que los
    vendedores puedan seguir operando si se cae el internet de la sucursal.
3.  Generación de Tickets: Implementar una función para generar un PDF básico
    que sirva como comprobante de compra.

🚩 Instrucción Final para la IA Generadora:

"Utilizando esta especificación técnica detallada, genera el código del
VentaRepositoryImpl con soporte para transacciones atómicas de stock y la
pantalla de POSScreen que implemente la paleta de colores Verde y Azul
institucional, incluyendo la lógica del 'Lunes de Descuento'."

