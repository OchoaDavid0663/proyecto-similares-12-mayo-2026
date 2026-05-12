# 📋 Plan de Implementación: App "Similares" (Flutter + Firebase)

> **Nota preliminar:** No existe un IDE llamado *Antigravity*. Para este plan se asume **VS Code** (recomendado por ligereza y ecosistema Flutter) como entorno principal. Si te refieres a otra herramienta, el flujo de trabajo sigue siendo compatible.

---

## 🔹 1. Preparación del Entorno de Desarrollo
1. **Instalar SDK y Herramientas Base**
   - Instalar Flutter SDK estable (≥3.19) y Dart SDK.
   - Instalar VS Code con extensiones oficiales: `Flutter`, `Dart`, `Error Lens`, `Pubspec Assist`.
   - Configurar emuladores/dispositivos físicos (Android, iOS, Web opcional).
   - Instalar Firebase CLI y autenticar con `firebase login`.

2. **Inicializar Proyecto**
   - Ejecutar `flutter create similares_app` con plantilla `--platforms=android,ios,web`.
   - Configurar `pubspec.yaml` base (sin dependencias aún).
   - Verificar ejecución en al menos dos plataformas objetivo.

---

## 🔹 2. Arquitectura y Estructura del Proyecto
Se recomienda arquitectura **Feature-First + Clean Layers** para escalabilidad:
```
lib/
├── core/              # Constantes, temas, utilidades, routing base
├── features/
│   ├── auth/          # Login, registro, recuperación
│   ├── home/          # Dashboard, categorías destacadas
│   ├── products/      # Medicamentos + Souvenirs (listas, filtros, detalle)
│   ├── cart/          # Carrito, checkout, historial
│   └── profile/       # Datos usuario, direcciones, pedidos
├── providers/         # ChangeNotifiers globales y por feature
├── services/          # Firebase, validación, almacenamiento local
├── models/            # Entidades (User, Medication, Souvenir, Order)
├── widgets/           # Componentes reutilizables (botones, cards, loaders)
└── main.dart          # Punto de entrada + MultiProvider + routing
```

---

## 🔹 3. Dependencias Clave (`pubspec.yaml`)
*(Agrega solo las necesarias, evita sobrecarga)*

| Categoría | Dependencia | Propósito |
|-----------|-------------|-----------|
| **Firebase** | `firebase_core`, `firebase_auth`, `cloud_firestore` | Backend, auth, BD |
| **Estado** | `provider` | Gestión reactiva sin boilerplate excesivo |
| **Navegación** | `go_router` | Rutas declarativas, deep linking, protección |
| **UI/UX** | `google_fonts`, `flutter_svg`, `cached_network_image`, `shimmer` | Tipografía, íconos, imágenes, estados de carga |
| **Utilidades** | `intl`, `uuid`, `logger`, `formz` | Formato fechas/moneda, IDs, logs, validación |
| **Testing** | `mockito`, `flutter_test` | Unit/widget tests |
| **Analítica** | `firebase_analytics`, `firebase_crashlytics` | Monitoreo en producción |

> ✅ **Nota:** Ejecuta `flutter pub get` después de agregar cada bloque. Mantén versiones compatibles con tu SDK.

---

## 🔹 4. Diseño UI/UX y Flujo de Navegación
1. **Sistema de Diseño**
   - Paleta: Verde institucional (#00A650), blanco, grises neutros, acentos para promociones.
   - Tipografía: `Google Fonts` (ej. `Inter` o `Roboto` para legibilidad farmacéutica).
   - Componentes: Cards con sombra suave, botones primarios/redondeados, inputs con validación inline.

2. **Flujo de Pantallas**
   ```
   Splash → Onboarding (opcional) → Login/Registro → Home (BottomNav)
   ├── Medicamentos (list/grid + búsqueda/filtros)
   ├── Souvenirs/Bienestar (categorías similares)
   ├── Detalle Producto → Agregar al Carrito
   ├── Carrito → Checkout → Confirmación
   └── Perfil → Pedidos, Direcciones, Cerrar Sesión
   ```

3. **Principios UX**
   - Accesibilidad: Contraste ≥4.5:1, tamaños de texto adaptativos, labels claros.
   - Estados vacíos: Ilustraciones + CTA claros cuando no hay datos.
   - Offline básico: Cache de catálogo y carrito persistente.
   - Feedback inmediato: Toasts, snackbars, loaders contextuales.

---

## 🔹 5. Configuración de Firebase
1. Crear proyecto en Firebase Console → Registrar apps (Android, iOS, Web).
2. Descargar `google-services.json` (Android) y `GoogleService-Info.plist` (iOS) y colocarlos en rutas correctas.
3. Habilitar **Authentication** → Método: Email/Password. Activar verificación por email (opcional pero recomendado).
4. Crear base de datos **Firestore** en modo prueba → Configurar reglas de seguridad antes de producción.
5. Estructura de Colecciones sugerida:
   - `users`: `{uid, email, name, phone, role, createdAt}`
   - `categories`: `{id, name, type: 'medication'|'souvenir'}`
   - `products`: `{id, name, description, price, stock, images[], category, requiresPrescription: bool, isSouvenir: bool}`
   - `orders`: `{id, userId, items[], total, status, createdAt, shippingAddress}`

---

## 🔹 6. Desarrollo por Fases (Paso a Paso)
### 🟢 Fase 1: Configuración Inicial y Auth
1. Inicializar Firebase en `main.dart`.
2. Implementar `AuthProvider` (login, register, logout, stream de usuario).
3. Crear pantallas de Login/Registro con validación básica.
4. Configurar `go_router` con protección de rutas (redirect si no autenticado).

### 🟢 Fase 2: Modelos y Servicios de Datos
1. Definir clases modelo (`Medication`, `Souvenir`, `CartItem`) con `fromJson/toJson`.
2. Crear `FirestoreService` para operaciones CRUD básicas.
3. Implementar paginación y filtros por categoría/tipo.
4. Agregar manejo de errores y estados de carga en servicios.

### 🟢 Fase 3: UI Base y Navegación
1. Configurar tema global (colores, tipografía, elevaciones).
2. Implementar `BottomNavigationBar` con rutas a Home, Carrito, Perfil.
3. Crear widgets reutilizables: `ProductCard`, `LoadingShimmer`, `EmptyState`.
4. Integrar `CachedNetworkImage` para optimización de assets.

### 🟢 Fase 4: Módulo de Medicamentos
1. Listado con búsqueda por nombre, principio activo, categoría.
2. Filtro: `requiereReceta`, `precio`, `disponibilidad`.
3. Vista detalle: información farmacéutica, advertencias, botón "Agregar al carrito".
4. Validar que productos con receta muestren aviso claro.

### 🟢 Fase 5: Módulo de Souvenirs/Productos Complementarios
1. Replicar estructura de listado pero con campos diferenciados (ej. `material`, `uso`, `temporada`).
2. Permitir cruce de carrito entre medicamentos y souvenirs.
3. Etiquetado visual claro para distinguir tipo de producto.

### 🟢 Fase 6: Carrito y Checkout
1. `CartProvider` con `ChangeNotifier`: agregar, eliminar, actualizar cantidades.
2. Persistencia local del carrito (SharedPreferences o Hive) para recuperación offline.
3. Resumen de orden, cálculo de totales, simulación de pasarela (placeholder).
4. Guardar orden en `orders` colección con estado `pending`.

### 🟢 Fase 7: Perfil y Historial
1. Mostrar datos de usuario, editar nombre/teléfono.
2. Listar pedidos previos con estados (`pending`, `processing`, `delivered`).
3. Botón de cerrar sesión + limpieza de estado local.
4. Opción de soporte/contacto integrado.

---

## 🔹 7. Gestión de Estado con Provider
1. **Estructura de Providers**
   - `AuthProvider`: Controla sesión, stream de `User?`.
   - `ProductProvider`: Carga categorías, listas, filtros, búsqueda.
   - `CartProvider`: Estado del carrito, persistencia, cálculo.
   - `UIProvider`: Temas, loaders globales, snackbars.

2. **Patrones de Uso**
   - Usar `MultiProvider` en `main.dart`.
   - Evitar lógica de negocio en widgets; delegar a providers/services.
   - Usar `Consumer` o `Provider.of` solo donde se requiera re-render.
   - Implementar `notifyListeners()` de forma granular (no en setters innecesarios).

3. **Estados Estándar**
   - `loading`, `success`, `error`, `empty` → manejar en UI con widgets condicionales.

---

## 🔹 8. Pruebas y Optimización
1. **Unit Tests**: Modelos, validaciones, lógica de carrito, servicios Firebase mockeados.
2. **Widget Tests**: Cards, formularios, navegación básica, estados de carga.
3. **Integración**: Flujo auth → añadir producto → checkout → confirmación.
4. **Rendimiento**
   - Paginación con `limit()` + `startAfterDocument()` en Firestore.
   - Compresión de imágenes, uso de `CachedNetworkImage`.
   - Evitar rebuilds innecesarios con `Selector` o `Consumer` específicos.
5. **Seguridad**
   - Reglas Firestore restrictivas (solo dueño puede ver/editar sus datos).
   - Validación en frontend + backend (Firebase Rules o Cloud Functions si escalas).
   - No almacenar datos sensibles en texto plano.

---

## 🔹 9. Despliegue Multiplataforma
| Plataforma | Pasos Clave |
|------------|-------------|
| **Android** | `flutter build appbundle`, firmar con keystore, subir a Play Console |
| **iOS** | Configurar `Runner` en Xcode, certificados, `flutter build ipa`, App Store Connect |
| **Web** | `flutter build web --release`, optimizar assets, desplegar en Firebase Hosting |
| **CI/CD** | GitHub Actions + Fastlane para builds automáticos y releases |

- Configurar versiones semánticas en `pubspec.yaml`.
- Activar Crashlytics y Analytics antes de producción.
- Documentar changelog y política de privacidad.

---

## 🔹 10. Buenas Prácticas y Consideraciones Finales
- ✅ **Cumplimiento Legal**: Aviso de privacidad, términos de uso, manejo de datos de salud según normativas locales.
- ✅ **Accesibilidad**: Navegación por teclado/lector de pantalla, labels semánticos, contraste validado.
- ✅ **Escalabilidad**: Separar lógica de negocio, preparar estructura para Cloud Functions (notificaciones, pagos reales).
- ✅ **Mantenimiento**: Linter estricto (`flutter_lints`), commits semánticos, documentación de API Firestore.
- ✅ **UX Farmacéutica**: Claridad en dosis, contraindicaciones, y diferenciación visual entre medicamentos y souvenirs.

---

📌 **Próximo paso sugerido**: Una vez valides este plan, puedo proporcionarte:
- Esquema detallado de reglas de seguridad para Firestore
- Estructura exacta de `pubspec.yaml` con versiones compatibles 2026
- Wireframes de flujo UI en formato texto
- Guía de implementación del `AuthProvider` y `ProductProvider` paso a paso

¿Deseas que profundice en alguna fase o ajustemos el alcance antes de pasar a la codificación?
