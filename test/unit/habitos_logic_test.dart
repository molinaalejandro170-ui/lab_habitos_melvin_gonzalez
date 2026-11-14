import 'package:flutter_test/flutter_test.dart';
import 'package:lab_habitos_melvin_gonzalez/habitos_logic.dart';

void main() {
  group('HabitosLogic', () {
    test('cuenta solamente los hábitos completados', () {
      expect(HabitosLogic.totalCumplidos([true, false, true, false]), 2);
    });

    test('calcula el progreso de cinco hábitos', () {
      expect(HabitosLogic.progreso(2, 5), 0.4);
    });

    test('evita división entre cero', () {
      expect(HabitosLogic.progreso(0, 0), 0);
    });

    test('limita el progreso al máximo de 100 por ciento', () {
      expect(HabitosLogic.progreso(8, 5), 1.0);
    });

    test('devuelve el mensaje de día completado', () {
      expect(HabitosLogic.mensaje(1), '¡Día completado!');
    });
  });
}
