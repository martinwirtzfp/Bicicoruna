# Arquitectura del Proyecto - BiciCoruña

## Patrón MVVM (Model-View-ViewModel)

Este proyecto implementa el patrón MVVM para mantener una separación clara entre la lógica de negocio y la interfaz de usuario.

### Flujo de datos

```
API → Repository → ViewModel → View
```

## Estructura de carpetas

```
lib/
├── models/              # Modelos de datos (Model)
├── repositories/        # Acceso a datos
├── viewmodels/         # Lógica de negocio (ViewModel)
├── views/              # Pantallas de la UI (View)
├── widgets/            # Componentes reutilizables
└── main.dart           # Punto de entrada
```

## Componentes principales

### 1. Models (Modelos de datos)

#### `station_info.dart`
- Representa la información estática de una estación
- Datos: ID, nombre, capacidad
- Se obtiene del endpoint `station_information`

#### `station_status.dart`
- Representa el estado dinámico de una estación
- Datos: bicis disponibles, anclajes libres, tipos de bicis, última actualización
- Se obtiene del endpoint `station_status`

#### `station.dart`
- Modelo completo que combina `StationInfo` y `StationStatus`
- Es el modelo principal usado en las vistas

### 2. Repository (Acceso a datos)

#### `station_repository.dart`
- Responsabilidad única: comunicarse con la API GBFS
- Métodos principales:
  - `getStationInfo()`: Obtiene información de estaciones
  - `getStationStatus()`: Obtiene estado de estaciones
  - `getAllStations()`: Combina ambos endpoints
- Maneja errores de red y parsing de JSON

### 3. ViewModel (Lógica de negocio)

#### `station_viewmodel.dart`
- Extiende `ChangeNotifier` para notificar cambios a la UI
- Gestiona el estado de la aplicación:
  - `initial`: Estado inicial
  - `loading`: Cargando datos
  - `loaded`: Datos cargados correctamente
  - `error`: Error al cargar
- Funciones principales:
  - `loadStations()`: Carga las estaciones desde el repository
  - `searchStations(query)`: Filtra estaciones por nombre
  - `refreshStations()`: Recarga los datos
- No conoce detalles de la UI (widgets, contextos, etc.)

### 4. Views (Interfaz de usuario)

#### `station_list_view.dart`
- Pantalla principal de la aplicación
- Muestra lista de estaciones con barra de búsqueda
- Usa `Consumer<StationViewModel>` para reaccionar a cambios de estado
- Implementa diferentes estados visuales (loading, error, loaded)
- Navegación a la vista de detalle

#### `station_detail_view.dart`
- Pantalla de detalle de una estación
- Recibe un objeto `Station` como parámetro
- Muestra información visual usando widgets personalizados
- No depende del ViewModel (datos pasados por navegación)

### 5. Widgets (Componentes reutilizables)

#### `station_widgets.dart`
- `MetricCard`: Tarjeta que muestra una métrica con icono y color
- `ProgressIndicatorWidget`: Barra de progreso con etiqueta
- `BikeTypeCard`: Tarjeta que muestra bicis eléctricas vs mecánicas

## Gestión de estado

### Provider
- Se usa `provider` para la gestión de estado
- `StationViewModel` se provee en la raíz de la app (`main.dart`)
- Las vistas consumen el estado usando `Consumer` o `context.read`

### Flujo de actualización
1. Usuario abre la app
2. `StationListView` llama a `viewModel.loadStations()`
3. ViewModel cambia estado a `loading` → UI muestra spinner
4. Repository hace peticiones HTTP a la API
5. Repository parsea JSON y devuelve lista de `Station`
6. ViewModel cambia estado a `loaded` → UI muestra lista
7. Si hay error, estado cambia a `error` → UI muestra mensaje de error

## Ventajas de esta arquitectura

### ✅ Separación de responsabilidades
- Models: Solo estructura de datos
- Repository: Solo acceso a datos
- ViewModel: Solo lógica de negocio
- Views: Solo presentación

### ✅ Testeable
- Cada capa se puede testear independientemente
- El ViewModel no depende de Flutter, solo de Dart

### ✅ Mantenible
- Cambios en la UI no afectan la lógica de negocio
- Cambios en la API solo afectan al Repository
- Código organizado y fácil de encontrar

### ✅ Escalable
- Fácil añadir nuevas funcionalidades
- Se pueden añadir más ViewModels para otras pantallas
- Widgets reutilizables reducen código duplicado

## Dependencias principales

- `provider: ^6.1.2` - Gestión de estado reactiva
- `http: ^1.2.2` - Peticiones HTTP
- `intl: ^0.19.0` - Formateo de fechas

## Ejemplo de flujo completo

```
Usuario busca "Riazor"
  ↓
StationListView detecta cambio en TextField
  ↓
Llama a viewModel.searchStations("Riazor")
  ↓
ViewModel filtra _stations y actualiza _filteredStations
  ↓
ViewModel llama a notifyListeners()
  ↓
Consumer<StationViewModel> se reconstruye
  ↓
ListView muestra solo estaciones que contienen "Riazor"
```

## Posibles mejoras futuras

- Implementar caché local (SharedPreferences, Hive)
- Añadir favoritos de estaciones
- Implementar notificaciones cuando una estación tenga bicis
- Añadir tests unitarios y de integración
- Implementar mapa interactivo con las estaciones
- Modo offline con datos guardados
