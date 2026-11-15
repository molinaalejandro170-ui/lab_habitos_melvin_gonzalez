# Panel de hábitos del día

Aplicación desarrollada en Flutter para registrar hábitos diarios, consultar el progreso, definir una meta, activar el modo enfoque y guardar una nota.

## Funcionalidades
- Marcar y desmarcar cinco hábitos.
- Consultar el progreso diario.
- Establecer una meta.
- Activar el modo enfoque.
- Guardar una nota.
- Abrir una pantalla de resumen.

## Requisitos
- Flutter SDK compatible con Dart 3.13.1 o superior.
- Dart SDK.

## Ejecutar
```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

## Documentación
Los documentos de pruebas y alcance se encuentran en `docs/`.

## Integración con Firebase

La aplicación integra Firebase Core y Cloud Firestore.
Firebase se inicializa mediante `firebase_options.dart` y permite guardar, consultar y actualizar el estado de los hábitos en la colección `habitos`.

Se realizaron pruebas de lectura y escritura en Firestore para verificar la persistencia de los cambios.