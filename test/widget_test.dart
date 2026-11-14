// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:lab_habitos_melvin_gonzalez/main.dart';

void main() {
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