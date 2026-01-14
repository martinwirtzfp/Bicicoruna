# Guía de Ejecución - BiciCoruña App

## Requisitos previos
- Flutter SDK instalado (versión 3.9.2 o superior)
- Un emulador Android/iOS o dispositivo físico conectado
- Conexión a Internet (la app consume datos de la API en tiempo real)

## Pasos para ejecutar la aplicación

### 1. Instalar dependencias
```bash
flutter pub get
```

### 2. Verificar que no hay errores
```bash
flutter analyze
```

### 3. Verificar dispositivos disponibles
```bash
flutter devices
```

### 4. Ejecutar la aplicación
```bash
flutter run
```

O si tienes varios dispositivos:
```bash
flutter run -d <device-id>
```

## Probar en diferentes plataformas

### Android
```bash
flutter run -d android
```

### iOS (solo en Mac)
```bash
flutter run -d ios
```

### Web
```bash
flutter run -d chrome
```

### Windows
```bash
flutter run -d windows
```

## Compilar para producción

### Android (APK)
```bash
flutter build apk
```

### Android (App Bundle)
```bash
flutter build appbundle
```

### iOS
```bash
flutter build ios
```

### Web
```bash
flutter build web
```

## Características de la app

- Al abrir la app se carga automáticamente la lista de estaciones
- Puedes buscar estaciones por nombre usando la barra de búsqueda
- Toca cualquier estación para ver sus detalles
- Desliza hacia abajo en la lista para refrescar los datos
- Los indicadores de color muestran la disponibilidad:
  - 🟢 Verde: Buena disponibilidad (3+ bicis)
  - 🟠 Naranja: Poca disponibilidad (1-2 bicis)
  - 🔴 Rojo: Sin bicis disponibles

## Solución de problemas

### La app no carga datos
- Verifica tu conexión a Internet
- Comprueba que las URLs de la API estén accesibles:
  - https://acoruna.publicbikesystem.net/customer/gbfs/v2/gl/station_information
  - https://acoruna.publicbikesystem.net/customer/gbfs/v2/gl/station_status

### Error al compilar
- Ejecuta `flutter clean` y luego `flutter pub get`
- Verifica que tienes la versión correcta de Flutter con `flutter --version`

### La app se cierra al iniciar
- Revisa los logs con `flutter logs`
- Asegúrate de que el dispositivo tiene permisos de Internet
