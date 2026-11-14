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
| 6 | Mostrar el resumen de hábitos | Widget | Aprobado |
| 7 | Marcar un hábito y guardar el cambio | Manual | Aprobado |
| 8 | Abrir la pantalla de resumen | Manual | Aprobado |
| 9 | Reiniciar hábitos y comprobar persistencia | Manual | Aprobado |
| 10 | Comprobar comportamiento sin conexión a Firestore | Manual | Pendiente |

## Comandos ejecutados

- flutter test: todos los tests pasaron.
- flutter analyze: No issues found.

## Observación
La prueba sin conexión queda pendiente. No se afirma que el comportamiento de la aplicación sin conexión haya sido validado.
