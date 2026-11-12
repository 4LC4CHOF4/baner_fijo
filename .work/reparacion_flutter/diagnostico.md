# Diagnóstico de reparación

- La captura muestra un test antiguo (`package:Baner_Fijo/main.dart`, `MyApp`). El archivo actual en disco ya importa `package:baner_fijo/main.dart` e instancia `BannerFijoApp`.
- `analysis_options.yaml` incluye `flutter_lints`, pero `pubspec.yaml` no tenía dicha dependencia. Se agrega `flutter_lints: ^6.0.0`.
- Plugins actuales: AGP 8.11.1 y Kotlin 2.2.20. El wrapper apuntaba a Gradle 9.7.1, con un timeout por acceso exclusivo a su descarga.
- AGP 8.11 tiene Gradle mínimo y predeterminado 8.13: https://developer.android.com/build/releases/agp-8-11-0-release-notes
- Kotlin 2.2.20–2.2.21 soporta completamente Gradle 7.6.3–8.14 y AGP 7.3.1–8.11.1: https://kotlinlang.org/docs/gradle-configure-project.html
- Se fija Gradle 8.13 sin cambiar AGP, Kotlin ni la instalación de Java. Se amplía networkTimeout a 120000 ms.
- Flutter instalado, según bin/cache/flutter.version.json: 3.47.9 stable, Dart 3.13.7.
- La consulta CIM de procesos y la lectura de la caché global de Gradle fueron denegadas; no se han detenido procesos del usuario ni eliminado cachés.
