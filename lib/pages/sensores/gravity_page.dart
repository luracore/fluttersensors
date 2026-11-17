import 'dart:math';

import 'package:material_ui/material_ui.dart';
import 'package:sensors_plus/sensors_plus.dart';

class GravityPage extends StatefulWidget {
  const GravityPage({super.key});

  @override
  State<GravityPage> createState() => _GravityPageState();
}

class _GravityPageState extends State<GravityPage> {
  late final Stream<AccelerometerEvent> _gravityStream;

  @override
  void initState() {
    super.initState();
    _gravityStream = accelerometerEventStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gravidade'),
      ),
      body: StreamBuilder<AccelerometerEvent>(
        stream: _gravityStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Erro ao acessar o sensor'),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final event = snapshot.data!;

          final intensidade = sqrt(
            event.x * event.x +
            event.y * event.y +
            event.z * event.z,
          );

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Leitura em tempo real',
                  style: TextStyle(fontSize: 22),
                ),
                const SizedBox(height: 30),

                _buildValue('Eixo X', event.x),
                _buildValue('Eixo Y', event.y),
                _buildValue('Eixo Z', event.z),

                const SizedBox(height: 20),

                _buildValue('Intensidade', intensidade),

                const SizedBox(height: 20),

                const Text(
                  'Valores em m/s²',
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 30),

                const Text(
                  'A gravidade representa a aceleração gravitacional '
                  'observada pelo aparelho. Seus componentes variam '
                  'conforme a orientação do dispositivo. É utilizada '
                  'para identificar inclinações e auxiliar na orientação '
                  'espacial.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildValue(String eixo, double valor) {
    return Card(
      child: ListTile(
        title: Text(eixo),
        trailing: Text(
          valor.toStringAsFixed(2),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
