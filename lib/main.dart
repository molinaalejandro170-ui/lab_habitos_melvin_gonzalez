

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'habitos_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Panel de hábitos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        useMaterial3: true,
      ),
      home: const PanelHabitos(),
    );
  }
}

class PanelHabitos extends StatefulWidget {
  final HabitosRepository? repository;

  const PanelHabitos({
    super.key,
    this.repository,
  });

  @override
  State<PanelHabitos> createState() => _PanelHabitosState();
}

class _PanelHabitosState extends State<PanelHabitos> {
  late final HabitosRepository _repository;

  final List<String> _habitos = [
    'Beber 2 L de agua',
    'Leer 20 minutos',
    'Caminar 30 minutos',
    'Estudiar Flutter',
    'Dormir 8 horas',
  ];

  List<bool> _cumplidos = List<bool>.filled(5, false);
  List<String> _documentos = [];
  int _meta = 3;
  bool _enfoque = false;
  bool _cargando = true;
  String _error = '';
  String _nota = '';

  final TextEditingController _notaCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    _repository = widget.repository ??
        FirestoreHabitosRepository(FirebaseFirestore.instance);

    _cargarHabitos();
  }

  Future<void> _cargarHabitos() async {
    try {
      final datos = await _repository.cargar(_habitos);

      if (!mounted) return;

      setState(() {
        _cumplidos = datos.map((h) => h.completado).toList();
        _documentos = datos.map((h) => h.id).toList();
        _cargando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _cargando = false;
        _error = 'No se pudieron cargar los hábitos: $e';
      });
    }
  }

  @override
  void dispose() {
    _notaCtrl.dispose();
    super.dispose();
  }

  int get _totalCumplidos =>
      _cumplidos.where((valor) => valor).length;

  double get _progreso =>
      _habitos.isEmpty ? 0 : _totalCumplidos / _habitos.length;

  bool get _metaAlcanzada => _totalCumplidos >= _meta;

  String get _mensaje {
    final porcentaje = (_progreso * 100).round();

    if (porcentaje == 0) return '¡Empecemos!';
    if (porcentaje < 50) return 'Buen inicio';
    if (porcentaje < 100) return '¡Vas muy bien!';
    return '¡Día completado!';
  }

  Future<void> _alternarHabito(int index) async {
    final nuevoEstado = !_cumplidos[index];

    setState(() {
      _cumplidos[index] = nuevoEstado;
    });

    try {
      await _repository.actualizar(
        _documentos[index],
        nuevoEstado,
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _cumplidos[index] = !nuevoEstado;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo guardar el cambio'),
        ),
      );
    }
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

  Future<void> _reiniciarDia() async {
    setState(() {
      _cumplidos = List<bool>.filled(_habitos.length, false);
      _nota = '';
      _meta = 3;
      _enfoque = false;
      _notaCtrl.clear();
    });

    try {
      await _repository.reiniciar(_documentos);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al reiniciar los hábitos'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hábitos — $_totalCumplidos / ${_habitos.length}',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: 'Ver resumen',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ResumenHabitos(
                    habitos: _habitos,
                    cumplidos: _cumplidos,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: _cargando
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _error.isNotEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(_error),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Progreso del día',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            LinearProgressIndicator(
                              value: _progreso,
                              minHeight: 10,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${(_progreso * 100).round()} % completado',
                            ),
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
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Meta del día',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Slider(
                              value: _meta.toDouble(),
                              min: 1,
                              max: 5,
                              divisions: 4,
                              label: '$_meta',
                              onChanged: _cambiarMeta,
                            ),
                            Text('Meta: $_meta hábitos'),
                            if (_metaAlcanzada)
                              const Text(
                                '✓ Meta alcanzada',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: SwitchListTile(
                        title: const Text(
                          'Modo enfoque',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: const Text(
                          'Ocultar hábitos ya cumplidos',
                        ),
                        value: _enfoque,
                        onChanged: _alternarEnfoque,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Hábitos de hoy',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...List.generate(_habitos.length, (index) {
                      if (_enfoque && _cumplidos[index]) {
                        return const SizedBox.shrink();
                      }

                      return Card(
                        child: CheckboxListTile(
                          value: _cumplidos[index],
                          onChanged: (_) => _alternarHabito(index),
                          title: Text(_habitos[index]),
                          controlAffinity:
                              ListTileControlAffinity.leading,
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Nota del día',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _notaCtrl,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Escribe una nota...',
                                labelText: 'Nota',
                              ),
                              onSubmitted: (_) => _guardarNota(),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _guardarNota,
                                child: const Text('Guardar nota'),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _nota.isEmpty ? 'Sin nota' : _nota,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
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

class ResumenHabitos extends StatelessWidget {
  final List<String> habitos;
  final List<bool> cumplidos;

  const ResumenHabitos({
    super.key,
    required this.habitos,
    required this.cumplidos,
  });

  @override
  Widget build(BuildContext context) {
    final total = cumplidos.where((valor) => valor).length;
    final progreso =
        habitos.isEmpty ? 0.0 : total / habitos.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen de hábitos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tu resumen del día',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
                title: const Text('Hábitos completados'),
                subtitle: Text('$total de ${habitos.length}'),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text('Progreso total'),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(value: progreso),
                    const SizedBox(height: 8),
                    Text('${(progreso * 100).round()} %'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Detalle de hábitos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: habitos.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(
                      cumplidos[index]
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: cumplidos[index]
                          ? Colors.green
                          : Colors.grey,
                    ),
                    title: Text(habitos[index]),
                    subtitle: Text(
                      cumplidos[index]
                          ? 'Completado'
                          : 'Pendiente',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
