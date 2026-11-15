

# 03. Plantilla y resultados de pruebas

## Entorno
- Aplicación: Flutter.
- Plataforma de prueba: Microsoft Edge.
- Base de datos: Cloud Firestore.
- Pruebas automatizadas: flutter test.
- Análisis estático: flutter analyze.

## Casos de prueba

| N.º | Caso | Tipo | Resultado |
|---|---|---|---|
| 1 | Contar hábitos completados | Unitario | Aprobado |
| 2 | Calcular el progreso | Unitario | Aprobado |
| 3 | Calcular progreso con lista vacía | Unitario | Aprobado |
| 4 | Mostrar mensaje de día completado | Unitario | Aprobado |
| 5 | Mostrar mensaje de inicio | Unitario | Aprobado |
| 6 | Cargar hábitos con repositorio falso | Widget | Aprobado |
| 7 | Actualizar un hábito con repositorio falso | Widget | Aprobado |
| 8 | Mostrar el resumen de hábitos | Widget | Aprobado |
| 9 | Marcar un hábito y guardar el cambio en Firestore | Manual | Aprobado |
| 10 | Comprobar persistencia después de actualizar Edge | Manual | Aprobado |
| 11 | Reiniciar hábitos y comprobar persistencia | Manual | Aprobado |
| 12 | Abrir la pantalla de resumen | Manual | Aprobado |

## Comandos ejecutados

- flutter test: 7 pruebas automatizadas aprobadas.
- flutter analyze: No issues found.

## Observación

Las pruebas manuales de lectura, escritura, actualización y reinicio de hábitos se realizaron correctamente con Cloud Firestore.

La prueba de funcionamiento sin conexión a Firestore queda pendiente y no se considera validada.
