import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab_habitos_melvin_gonzalez/main.dart';

void main() {
  testWidgets('muestra el panel y permite completar un hábito',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Hábitos de hoy'), findsOneWidget);
    expect(find.text('Hábitos — Cumplidos: 0 / 5'), findsOneWidget);

    final primerHabito = find.byType(CheckboxListTile).first;
    await tester.ensureVisible(primerHabito);
    await tester.tap(primerHabito);
    await tester.pump();

    expect(find.text('Hábitos — Cumplidos: 1 / 5'), findsOneWidget);
  });

  testWidgets('permite abrir y cerrar la pantalla de resumen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byTooltip('Resumen'));
    await tester.pumpAndSettle();

    expect(find.text('Resumen de hábitos'), findsOneWidget);
    await tester.tap(find.text('Volver'));
    await tester.pumpAndSettle();

    expect(find.text('Hábitos de hoy'), findsOneWidget);
  });
}
