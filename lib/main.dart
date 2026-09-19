import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Panel de hábitos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.green, useMaterial3: true),
      home: const PanelHabitos(),
    );
  }
}

class PanelHabitos extends StatefulWidget {
  const PanelHabitos({super.key});

  @override
  State<PanelHabitos> createState() => _PanelHabitosState();
}

class _PanelHabitosState extends State<PanelHabitos> {
  // Datos

  final List<String> _habitos = const [
    'Beber 2 L de agua',
    'Leer 20 minutos',
    'Caminar 30 minutos',
    'Estudiar Flutter',
    'Dormir 8 horas',
  ];

  // Estado

  late List<bool> _cumplidos;

  int _meta = 3;

  bool _enfoque = false;

  String _nota = '';

  final TextEditingController _notaCtrl = TextEditingController();

  static const int _metaInicial = 3;

  // Inicializacion

  @override
  void initState() {
    super.initState();

    _cumplidos = List<bool>.filled(_habitos.length, false);
  }

  // Liberar recursos

  @override
  void dispose() {
    _notaCtrl.dispose();
    super.dispose();
  }

  // Getters liberados

  int get _totalCumplidos {
    return _cumplidos.where((cumplido) => cumplido).length;
  }

  double get _progreso {
    return _habitos.isEmpty ? 0 : _totalCumplidos / _habitos.length;
  }

  bool get _metaAlcanzada {
    return _totalCumplidos >= _meta;
  }

  String get _mensaje {
    final porcentaje = (_progreso * 100).round();

    if (porcentaje == 0) {
      return '¡Empecemos!';
    }

    if (porcentaje < 50) {
      return 'Buen inicio';
    }

    if (porcentaje < 100) {
      return '¡Vas muy bien!';
    }

    return '¡Día completado!';
  }

  // Acciones

  void _alternarHabito(int index) {
    setState(() {
      _cumplidos[index] = !_cumplidos[index];
    });
  }

  void _cambiarMeta(double valor) {
    setState(() {
      _meta = valor.round();
    });
  }

  void _alternarEnfoque(bool valor) {
    setState(() {
      _enfoque = valor;
    });
  }

  void _guardarNota() {
    setState(() {
      _nota = _notaCtrl.text.trim();
    });
  }

  void _reiniciarDia() {
    setState(() {
      _cumplidos = List<bool>.filled(_habitos.length, false);

      _nota = '';

      _meta = _metaInicial;

      _enfoque = false;

      _notaCtrl.clear();
    });
  }

  // Interfaz

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hábitos — Cumplidos: $_totalCumplidos / ${_habitos.length}',
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Progreso

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Progreso del día',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  LinearProgressIndicator(value: _progreso, minHeight: 10),

                  const SizedBox(height: 8),

                  Text('${(_progreso * 100).round()} % completado'),

                  const SizedBox(height: 12),

                  Text(
                    _mensaje,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Meta del dia
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Meta del día',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  Slider(
                    value: _meta.toDouble(),
                    min: 1,
                    max: _habitos.length.toDouble(),
                    divisions: _habitos.length - 1,
                    label: '$_meta',
                    onChanged: _cambiarMeta,
                  ),

                  Text(
                    'Meta: $_meta hábitos',
                    style: const TextStyle(fontSize: 16),
                  ),

                  if (_metaAlcanzada)
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '✓ Meta alcanzada',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Modo enfoque
          Card(
            child: SwitchListTile(
              title: const Text(
                'Modo enfoque',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('Ocultar hábitos ya cumplidos'),
              value: _enfoque,
              onChanged: _alternarEnfoque,
            ),
          ),

          const SizedBox(height: 12),

          // Lista de habitos
          const Text(
            'Hábitos de hoy',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          ...List.generate(_habitos.length, (index) {
            // No mostramos los hábitos cumplidos.
            if (_enfoque && _cumplidos[index]) {
              return const SizedBox.shrink();
            }

            return Card(
              child: CheckboxListTile(
                value: _cumplidos[index],
                onChanged: (_) {
                  _alternarHabito(index);
                },
                title: Text(_habitos[index]),
                controlAffinity: ListTileControlAffinity.leading,
              ),
            );
          }),

          const SizedBox(height: 16),

          // Nota del dia
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nota del día',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: _notaCtrl,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Escribe una nota...',
                      labelText: 'Nota',
                    ),
                    onSubmitted: (_) {
                      _guardarNota();
                    },
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _guardarNota,
                      child: const Text('Guardar nota'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Nota guardada
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nota guardada',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    _nota.isEmpty ? 'Sin nota' : _nota,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Restart
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _reiniciarDia,
              icon: const Icon(Icons.refresh),
              label: const Text('Reiniciar día'),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
