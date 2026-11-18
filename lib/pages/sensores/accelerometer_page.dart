import 'package:material_ui/material_ui.dart';
import 'package:sensors_plus/sensors_plus.dart';

class AccelerometerPage extends StatefulWidget {
  const AccelerometerPage({super.key});

  @override
  State<AccelerometerPage> createState() => _AccelerometerPageState();
}

class _AccelerometerPageState extends State<AccelerometerPage> {
  late final Stream<UserAccelerometerEvent> _accelerometerStream;

  @override
  void initState() {
    super.initState();
    _accelerometerStream = userAccelerometerEventStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acelerômetro'),
      ),
      body: StreamBuilder<UserAccelerometerEvent>(
        stream: _accelerometerStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Erro ao acessar o acelerômetro'),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final event = snapshot.data!;

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

                const Text(
                  'Aceleração linear em m/s²',
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 30),

                const Text(
                  'A aceleração linear representa a aceleração '
                  'do aparelho sem a componente da gravidade. '
                  'É utilizada para detectar movimentos, '
                  'deslocamentos e atividades do dispositivo.',
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
