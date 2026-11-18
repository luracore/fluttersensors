import 'dart:math';

import 'package:material_ui/material_ui.dart';
import 'package:sensors_plus/sensors_plus.dart';

class BarometerPage extends StatefulWidget {
  const BarometerPage({super.key});

  @override
  State<BarometerPage> createState() => _BarometerPageState();
}

class _BarometerPageState extends State<BarometerPage> {
  // Pressão média ao nível do mar. ponytail: valor padrão; para altitude absoluta
  // precisa, troque pela pressão ao nível do mar do dia (boletim meteorológico).
  static const double _pressaoNivelDoMar = 1013.25;

  late final Stream<BarometerEvent> _stream;
  double? _altitudeReferencia;

  @override
  void initState() {
    super.initState();
    _stream = barometerEventStream();
  }

  // Fórmula barométrica internacional.
  double _altitude(double pressao) =>
      44330 * (1 - pow(pressao / _pressaoNivelDoMar, 1 / 5.255).toDouble());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Barômetro')),
      body: StreamBuilder<BarometerEvent>(
        stream: _stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Sensor não disponível neste aparelho'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final pressao = snapshot.data!.pressure;
          final altitude = _altitude(pressao);
          final referencia = _altitudeReferencia;

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'Mede a pressão atmosférica. Quanto mais alto, menor a pressão. '
                'Usado para ajudar o GPS a saber a altitude (em que andar você está) '
                'e na previsão do tempo.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'Leitura em tempo real',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22),
              ),
              const SizedBox(height: 10),
              _buildValue('Pressão', '${pressao.toStringAsFixed(2)} hPa'),
              _buildValue('Altitude estimada', '${altitude.toStringAsFixed(2)} m'),
              const SizedBox(height: 10),
              const Text(
                'Nível do mar ≈ 1013 hPa. A cada ~8 m de subida, cai cerca de 1 hPa.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 30),
              const Text(
                'Marque a posição atual e suba ou desça uma escada:',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Center(
                child: FilledButton.icon(
                  onPressed: () => setState(() => _altitudeReferencia = altitude),
                  icon: const Icon(Icons.flag),
                  label: const Text('Marcar posição atual'),
                ),
              ),
              if (referencia != null) ...[
                const SizedBox(height: 10),
                _buildValue(
                  'Diferença de altura',
                  '${(altitude - referencia) >= 0 ? '+' : ''}'
                      '${(altitude - referencia).toStringAsFixed(2)} m',
                ),
                Text(
                  '≈ ${((altitude - referencia) / 3).toStringAsFixed(1)} andar(es) (3 m por andar)',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildValue(String titulo, String valor) {
    return Card(
      child: ListTile(
        title: Text(titulo),
        trailing: Text(
          valor,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
