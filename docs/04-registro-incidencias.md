# 04. Registro de incidencias

## Incidencia 1
- Descripción: El comando firebase no era reconocido por PowerShell.
- Severidad: Baja.
- Prioridad: Media.
- Origen: Configuración del entorno.
- Causa: Firebase CLI no estaba instalado.
- Solución: Instalar Firebase CLI mediante npm.
- Estado: Corregida.

## Incidencia 2
- Descripción: El comando flutterfire configure no era reconocido.
- Severidad: Baja.
- Prioridad: Media.
- Origen: Configuración del entorno.
- Causa: FlutterFire CLI no estaba disponible como comando directo.
- Solución: Ejecutar dart pub global run flutterfire_cli:flutterfire configure.
- Estado: Corregida.

## Incidencia 3
- Descripción: Falló la prueba predeterminada Counter increments smoke test.
- Severidad: Baja.
- Prioridad: Media.
- Origen: Prueba automatizada inicial.
- Causa: La prueba predeterminada de Flutter no correspondía a la interfaz de la aplicación.
- Solución: Sustituir la prueba predeterminada por una prueba del resumen de hábitos.
- Verificación: flutter test terminó con All tests passed.
- Estado: Corregida.

## Resultado
Las incidencias anteriores fueron corregidas. No se registran como errores funcionales actuales de la aplicación.
