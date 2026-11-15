

import 'package:cloud_firestore/cloud_firestore.dart';

class HabitoGuardado {
  final String id;
  final String nombre;
  final bool completado;

  HabitoGuardado({
    required this.id,
    required this.nombre,
    required this.completado,
  });
}

abstract class HabitosRepository {
  Future<List<HabitoGuardado>> cargar(List<String> nombres);
  Future<void> actualizar(String id, bool completado);
  Future<void> reiniciar(List<String> ids);
}

class FirestoreHabitosRepository implements HabitosRepository {
  final FirebaseFirestore db;

  FirestoreHabitosRepository(this.db);

  @override
  Future<List<HabitoGuardado>> cargar(List<String> nombres) async {
    final coleccion = db.collection('habitos');
    final datos = await coleccion.get();
    final resultado = <HabitoGuardado>[];

    for (final nombre in nombres) {
      final coincidencias = datos.docs.where((doc) {
        final guardado = (doc.data()['nombre'] ?? '')
            .toString()
            .toLowerCase();

        return guardado == nombre.toLowerCase() ||
            (nombre == 'Leer 20 minutos' && guardado == 'leer');
      });

      if (coincidencias.isNotEmpty) {
        final documento = coincidencias.first;

        if (documento.data()['nombre'] != nombre) {
          await coleccion.doc(documento.id).update({
            'nombre': nombre,
          });
        }

        resultado.add(HabitoGuardado(
          id: documento.id,
          nombre: nombre,
          completado: documento.data()['completado'] == true,
        ));
      } else {
        final nuevo = await coleccion.add({
          'nombre': nombre,
          'completado': false,
        });

        resultado.add(HabitoGuardado(
          id: nuevo.id,
          nombre: nombre,
          completado: false,
        ));
      }
    }

    return resultado;
  }

  @override
  Future<void> actualizar(String id, bool completado) async {
    await db.collection('habitos').doc(id).update({
      'completado': completado,
    });
  }

  @override
  Future<void> reiniciar(List<String> ids) async {
    final lote = db.batch();

    for (final id in ids) {
      lote.update(db.collection('habitos').doc(id), {
        'completado': false,
      });
    }

    await lote.commit();
  }
}
