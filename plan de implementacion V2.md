¡Claro que sí! Aquí tienes el Prompt Maestro Definitivo. He consolidado todo lo
que hemos trabajado: la arquitectura, el diseño institucional, la lógica de
negocio de Farmacias Similares y la configuración técnica de Firebase.

Este documento está diseñado para que lo guardes como tu "Biblia del Proyecto" o
lo pegues en una IA para regenerar el código base.

🚀 PROMPT MAESTRO: SIMIAPP PRO - SISTEMA DE GESTIÓN DE FARMACIA

Rol: Actúa como un Arquitecto de Software Senior y Desarrollador Fullstack
experto en Flutter y Firebase. Objetivo: Desarrollar una aplicación profesional
para la gestión de sucursales de "Farmacias Similares", con conexión a Firebase
(Auth y Firestore), arquitectura escalable y una interfaz vibrante basada en la
identidad de la marca.

🎨 1. IDENTIDAD VISUAL Y UI (BRANDING)

La aplicación debe ser visualmente impactante y profesional.

| Elemento               | Código HEX | Aplicación en la App                                           |
| :--------------------- | :--------- | :------------------------------------------------------------- |
| **Verde Primario**     | `#009640`  | AppBars, botones de éxito, headers y botones de "Registrarme". |
| **Azul Institucional** | `#00468C`  | Iconografía médica, botones de navegación, textos de títulos.  |
| **Amarillo Simi**      | `#FFD100`  | Alertas de stock bajo, banners de "Lunes de Descuento".        |
| **Fondo**              | `#F8F9FA`  | Color base de la aplicación para limpieza visual.              |
| **Blanco**             | `#FFFFFF`  | Tarjetas (Cards) y campos de entrada de texto.                 |

📂 2. ESTRUCTURA DE CARPETAS (CLEAN ARCHITECTURE)

El proyecto se organiza en capas para permitir el mantenimiento a largo plazo:
```
lib/
├── core/
│   ├── constants/             # Rutas de imágenes y textos fijos
│   ├── theme/                 # AppColors y configuración de ThemeData
│   └── utils/                 # Formateadores de moneda y validadores
├── data/                      # CAPA DE DATOS
│   ├── models/                # DTOs (MedicamentoModel, VentaModel, ClienteModel)
│   └── repositories/          # Implementación de AuthService y FirestoreService
├── domain/                    # CAPA DE NEGOCIO
│   ├── entities/              # Clases puras de datos (Medicamento, Venta)
│   └── usecases/              # Lógica: (CalcularDescuentoLunes, SumarPuntos)
├── presentation/              # CAPA DE INTERFAZ
│   ├── providers/             # Manejo de estado (Carrito, AuthState)
│   ├── screens/               # Pantallas (Welcome, Login, Register, Home, POS)
│   └── widgets/               # Componentes reutilizables (SimiButtons, Inputs)
└── main.dart                  # Inicialización de Firebase y Rutas
```
🗄️ 3. ESQUEMA DE BASE DE DATOS (FIRESTORE)

Módulo A: Catálogo y Stock

1.  medicamentos:
      - id (String), nombre (String), compuesto (String), precio (Double), stock
        (Int), stock_min (Int), requiereReceta (Bool).
2.  souvenirs:
      - id (String), nombre (String), precio (Double), stock (Int), img_url
        (String).

Módulo B: Transacciones

3.  ventas:
      - folio (String), fecha (Timestamp), total (Double), metodo_pago (String),
        items (List), cliente_id (Ref), empleado_id (Ref). Lógica: Al vender, se
        debe restar automáticamente el stock de la tabla de medicamentos.

Módulo C: Personal y Clientes

4.  empleados:
      - uid (Auth), nombre (String), rol (admin/vendedor/doctor), sucursal_id
        (Ref).
5.  clientes:
      - id (Telefono), nombre (String), simipuntos (Int), correo (String).
6.  proveedores:
      - id (RFC), empresa (String), contacto (String), telefono (String).

Módulo D: Servicios Médicos

7.  consultas:
      - id (String), paciente_id (Ref), doctor_id (Ref), diagnostico (String),
        costo (Double).

🛠️ 4. PASOS DE IMPLEMENTACIÓN (ROADMAP)

Paso 1: Configuración de Firebase

  - Crear proyecto en Firebase Console.
  - Descargar google-services.json para Android.
  - Configurar el archivo web/index.html con las claves de la App Web para que
    Chrome no se vea blanco.

Paso 2: Autenticación Completa

  - Implementar Login con Email y Contraseña.
  - Implementar Registro de nuevos usuarios.
  - Implementar Acceso con Google (requiere configurar SHA-1 en la consola).
  - Implementar Recuperación de contraseña vía email.

Paso 3: Lógica de "Lunes de Simi"

  - Programar un UseCase que detecte mediante la librería intl si el día actual
    es DateTime.monday.
  - Si es verdadero, aplicar un descuento del 25% a todos los medicamentos en el
    carrito.

Paso 4: Programa de Fidelización (Simipuntos)

  - Configurar que por cada $10 MXN de compra, el sistema actualice el campo
    simipuntos del cliente en un +1.

Paso 5: Dashboard e Inventario

  - Crear el menú principal con botones tipo Grid (Cuadrícula).
  - Crear el sistema de "Punto de Venta" (POS) que descuente stock en tiempo
    real usando transacciones de Firestore.

📦 5. DEPENDENCIAS (PUBSPEC.YAML)

1.  firebase_core: ^2.24.2
2.  cloud_firestore: ^4.14.0
3.  firebase_auth: ^4.16.0
4.  google_sign_in: ^6.2.1
5.  provider: ^6.1.1
6.  google_fonts: ^6.1.0
7.  intl: ^0.18.1
8.  uuid: ^4.2.2

🚩 REGLA DE ORO PARA EL DESARROLLO (main.dart)

Para evitar el error [core/no-app], la aplicación debe inicializarse en el main
pasando las opciones de Firebase Web explícitamente:

await Firebase.initializeApp(
  options: const FirebaseOptions(
    apiKey: "TU_API_KEY",
    authDomain: "TU_PROYECTO.firebaseapp.com",
    projectId: "TU_PROYECTO",
    storageBucket: "TU_PROYECTO.firebasestorage.app",
    messagingSenderId: "TU_ID",
    appId: "TU_APP_ID",
  ),
);

¿Qué sigue ahora? Con este prompt, ya tienes el control total del proyecto. ¿Te
gustaría que comenzáramos a desarrollar la Pantalla de Inventario de
Medicamentos para que puedas empezar a agregar productos a tu base de datos?

Aquí tienes el desglose técnico y detallado de las 8 tablas (colecciones) que
requiere tu proyecto de Farmacias Similares. Esta estructura está diseñada para
funcionar perfectamente en Cloud Firestore (NoSQL) y permitirte escalar el
trabajo de forma profesional.

🗄️ Diccionario de Datos: SimiApp Pro

1. Colección: medicamentos (Inventario Farmacéutico)

Controla el catálogo principal de medicinas.

| Campo               | Tipo de Dato | Relación / Validación | Descripción                                            |
| :------------------ | :----------- | :-------------------- | :----------------------------------------------------- |
| `id`                | String       | PK (Código de barras) | Identificador único del producto.                      |
| `nombre_comercial`  | String       | \-                    | Nombre de marca (ej: Simiparatol).                     |
| `nombre_generico`   | String       | \-                    | Sustancia activa (ej: Paracetamol).                    |
| `categoria`         | String       | \-                    | Analgésicos, Antibióticos, etc.                        |
| `precio`            | Double       | Min: 0.0              | Precio base de venta.                                  |
| `stock`             | Int          | Min: 0                | Cantidad física en anaquel.                            |
| `stock_minimo`      | Int          | \-                    | Si `stock` \< `stock_minimo`, mostrar alerta amarilla. |
| `requiere_receta`   | Boolean      | \-                    | Bloquea la venta si el cliente no trae receta.         |
| `fecha_vencimiento` | Timestamp    | \-                    | Para alertas de caducidad.                             |

2. Colección: productos_souvenirs (Similandia)

Gestión de peluches y mercancía del Dr. Simi.

| Campo          | Tipo de Dato | Relación / Validación | Descripción                              |
| :------------- | :----------- | :-------------------- | :--------------------------------------- |
| `id`           | String       | PK                    | SKU del souvenir.                        |
| `nombre`       | String       | \-                    | Ej: Dr. Simi Astronauta.                 |
| `precio`       | Double       | \-                    | Precio fijo.                             |
| `stock`        | Int          | \-                    | Existencias.                             |
| `img_url`      | String       | \-                    | Link a la imagen en Firebase Storage.    |
| `es_coleccion` | Boolean      | \-                    | Flag para productos de edición limitada. |

3. Colección: clientes (Fidelización)

Base de datos para el programa de Simipuntos.

| Campo            | Tipo de Dato | Relación / Validación | Descripción                               |
| :--------------- | :----------- | :-------------------- | :---------------------------------------- |
| `telefono`       | String       | PK                    | Usado como ID único del cliente.          |
| `nombre`         | String       | \-                    | Nombre completo.                          |
| `correo`         | String       | Formato Email         | Para envío de promociones.                |
| `simipuntos`     | Int          | \-                    | Acumulados (1 punto por cada $10.00 MXN). |
| `fecha_registro` | Timestamp    | \-                    | Fecha de alta en el sistema.              |

4. Colección: empleados (Personal)

Gestión de accesos y roles.

| Campo    | Tipo de Dato | Relación / Validación         | Descripción                                        |
| :------- | :----------- | :---------------------------- | :------------------------------------------------- |
| `uid`    | String       | PK (Firebase Auth)            | Vinculado al correo del login.                     |
| `nombre` | String       | \-                            | Nombre del trabajador.                             |
| `rol`    | String       | `admin`, `vendedor`, `doctor` | Define qué pantallas puede ver.                    |
| `correo` | String       | \-                            | Email corporativo.                                 |
| `activo` | Boolean      | \-                            | Permite bloquear el acceso sin borrar al empleado. |

5. Colección: ventas (Maestro-Detalle)

Registro histórico de cada transacción.

| Campo         | Tipo de Dato | Relación / Validación | Descripción                                   |
| :------------ | :----------- | :-------------------- | :-------------------------------------------- |
| `folio`       | String       | PK (Auto-gen)         | ID de la transacción.                         |
| `fecha`       | Timestamp    | \-                    | Fecha y hora exacta.                          |
| `cliente_id`  | DocumentRef  | `clientes`            | Referencia al cliente que compró.             |
| `vendedor_id` | DocumentRef  | `empleados`           | Quién realizó la venta.                       |
| `total`       | Double       | \-                    | Monto final cobrado.                          |
| `metodo_pago` | String       | `efectivo`, `tarjeta` | Método utilizado.                             |
| `items`       | List<Map>    | \-                    | Lista de `{prod_id, cant, precio, subtotal}`. |

6. Colección: proveedores (Logística)

Directorio de laboratorios y distribuidores.

| Campo      | Tipo de Dato | Relación / Validación | Descripción                    |
| :--------- | :----------- | :-------------------- | :----------------------------- |
| `id`       | String       | PK (RFC)              | Registro fiscal del proveedor. |
| `empresa`  | String       | \-                    | Nombre (Bayer, Genomma, etc.). |
| `contacto` | String       | \-                    | Nombre del agente de ventas.   |
| `telefono` | String       | \-                    | Teléfono de pedidos.           |
| `correo`   | String       | \-                    | Email para órdenes de compra.  |

7. Colección: consultas (Servicios Médicos)

Registro del consultorio adjunto.

| Campo          | Tipo de Dato | Relación / Validación | Descripción                          |
| :------------- | :----------- | :-------------------- | :----------------------------------- |
| `id`           | String       | PK                    | Folio médico.                        |
| `paciente_id`  | DocumentRef  | `clientes`            | Referencia al paciente atendido.     |
| `doctor_id`    | DocumentRef  | `empleados`           | El médico que atendió (Rol: Doctor). |
| `diagnostico`  | String       | \-                    | Resumen clínico.                     |
| `prescripcion` | List<String> | \-                    | Lista de medicamentos recetados.     |
| `costo`        | Double       | \-                    | Costo de la consulta ($50.00 MXN).   |

8. Colección: sucursales (Ubicación)

Control de la unidad de negocio.

| Campo        | Tipo de Dato | Relación / Validación | Descripción                               |
| :----------- | :----------- | :-------------------- | :---------------------------------------- |
| `id`         | String       | PK                    | Clave de sucursal.                        |
| `nombre`     | String       | \-                    | Nombre de la zona (ej: Sucursal Reforma). |
| `direccion`  | String       | \-                    | Dirección completa.                       |
| `gerente_id` | DocumentRef  | `empleados`           | Quién es el responsable de la tienda.     |

⚙️ Reglas de Negocio (Lógica de las Tablas)

1.  Lunes de Simi: Cada vez que se genere un registro en la tabla ventas, el
    sistema debe revisar si la fecha es Lunes. Si lo es, el campo total debe
    reducirse un 25% automáticamente para los productos tipo medicamento.
2.  Sincronización de Stock: Al registrar una venta, un proceso (Transaction)
    debe buscar el id en la tabla medicamentos y restar la cantidad del campo
    stock.
3.  Generación de Puntos: Por cada $10.00 del campo total en ventas, se debe
    sumar +1 al campo simipuntos en el documento del cliente correspondiente.

¿Con estas tablas ya te sientes listo para que Entigravity te ayude a programar
la pantalla de "Punto de Venta" (Caja)?
