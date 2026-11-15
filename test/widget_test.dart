
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab_habitos_melvin_gonzalez/main.dart';
import 'package:lab_habitos_melvin_gonzalez/habitos_repository.dart';

class FakeHabitosRepository implements HabitosRepository {
  final List<HabitoGuardado> datos = [
    HabitoGuardado(id: '1', nombre: 'Beber 2 L de agua', completado: false),
    HabitoGuardado(id: '2', nombre: 'Leer 20 minutos', completado: false),
    HabitoGuardado(id: '3', nombre: 'Caminar 30 minutos', completado: false),
    HabitoGuardado(id: '4', nombre: 'Estudiar Flutter', completado: false),
    HabitoGuardado(id: '5', nombre: 'Dormir 8 horas', completado: false),
  ];

  @override
  Future<List<HabitoGuardado>> cargar(List<String> nombres) async {
    return datos;
  }

  @override
  Future<void> actualizar(String id, bool completado) async {
    final index = datos.indexWhere((h) => h.id == id);
    final anterior = datos[index];

    datos[index] = HabitoGuardado(
      id: anterior.id,
      nombre: anterior.nombre,
      completado: completado,
    );
  }

  @override
  Future<void> reiniciar(List<String> ids) async {
    for (var i = 0; i < datos.length; i++) {
      final h = datos[i];
      datos[i] = HabitoGuardado(
        id: h.id,
        nombre: h.nombre,
        completado: false,
      );
    }
  }
}

void main() {
  testWidgets('Carga y actualiza hábitos con repositorio falso', (tester) async {
    final repositorio = FakeHabitosRepository();

    await tester.pumpWidget(
      MaterialApp(
        home: PanelHabitos(repository: repositorio),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Beber 2 L de agua'), findsOneWidget);

    await tester.ensureVisible(find.text('Beber 2 L de agua'));
    await tester.tap(find.text('Beber 2 L de agua'));
    await tester.pumpAndSettle();

    expect(repositorio.datos.first.completado, true);
  });

  testWidgets('Muestra el resumen de hábitos', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ResumenHabitos(
          habitos: ['Leer', 'Estudiar', 'Caminar'],
          cumplidos: [true, false, true],
        ),
      ),
    );

    expect(find.text('Resumen de hábitos'), findsOneWidget);
    expect(find.text('2 de 3'), findsOneWidget);
    expect(find.text('Leer'), findsOneWidget);
  });
}
