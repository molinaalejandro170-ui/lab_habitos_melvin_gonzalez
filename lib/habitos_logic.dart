class HabitosLogic {
  static int totalCumplidos(List<bool> cumplidos) {
    return cumplidos.where((item) => item).length;
  }

  static double progreso(int total, int cantidad) {
    if (cantidad <= 0) return 0;
    return (total / cantidad).clamp(0.0, 1.0);
  }

  static String mensaje(double progreso) {
    final porcentaje = (progreso.clamp(0.0, 1.0) * 100).round();
    if (porcentaje == 0) return '¡Empecemos!';
    if (porcentaje < 50) return 'Buen inicio';
    if (porcentaje < 100) return '¡Vas muy bien!';
    return '¡Día completado!';
  }
}
