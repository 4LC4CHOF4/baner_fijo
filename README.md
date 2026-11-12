# Banner fijo

Aplicación móvil de ejemplo hecha con Flutter para mostrar **un solo formato de anuncio: banner fijo estándar de 320 × 50 dp**, colocado en la parte inferior de la pantalla.

## Requisitos

- Flutter **3.38.1 o posterior** y Dart **3.10.0 o posterior**.
- Android SDK y un emulador o dispositivo Android.

## Ejecutar

```bash
flutter pub get
flutter run
```

La app inicializa Google Mobile Ads y carga el banner de demostración. Si no hay conexión o la solicitud falla, conserva el espacio fijo y muestra un mensaje de estado.

## Identificadores incluidos

El proyecto usa exclusivamente identificadores de prueba oficiales de Google para Android:

- App ID de demostración: `ca-app-pub-3940256099942544~3347511713` en `android/app/src/main/AndroidManifest.xml`.
- Unidad de anuncio de prueba para banner: `ca-app-pub-3940256099942544/6300978111` en `lib/main.dart`.

Estos IDs son de prueba y no corresponden a una cuenta de AdMob.

## Punto de demostración

Corresponde únicamente al punto 4 de la referencia: **“Banner de tamaño fijo”**. No se incluyen intersticiales, banners adaptables, anuncios nativos ni otros formatos.
