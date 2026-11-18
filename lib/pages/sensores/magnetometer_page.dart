import 'dart:math';

import 'package:material_ui/material_ui.dart';
import 'package:sensors_plus/sensors_plus.dart';

class MagnetometerPage extends StatefulWidget {
  const MagnetometerPage({super.key});

  @override
  State<MagnetometerPage> createState() => _MagnetometerPageState();
}

class _MagnetometerPageState extends State<MagnetometerPage> {
  late final Stream<MagnetometerEvent> _magnetometerStream;

  @override
  void initState() {
    super.initState();
    _magnetometerStream = magnetometerEventStream();
  }

  double _direcao(MagnetometerEvent e) {
    // -x: com o topo para o leste, o norte fica à esquerda (eixo X negativo).
    final graus = atan2(e.y, -e.x) * 180 / pi;
    return (90 - graus + 360) % 360;
  }

  String _pontoCardeal(double graus) {
    const pontos = ['N', 'NE', 'L', 'SE', 'S', 'SO', 'O', 'NO'];
    return pontos[((graus + 22.5) % 360 ~/ 45)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Magnetômetro')),
      body: StreamBuilder<MagnetometerEvent>(
        stream: _magnetometerStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Sensor não disponível neste aparelho'),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final event = snapshot.data!;
          final intensidade = sqrt(
            event.x * event.x + event.y * event.y + event.z * event.z,
          );
          final direcao = _direcao(event);

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'Mede o campo magnético ao redor do aparelho. '
                'Usado em bússolas, mapas e detecção de objetos metálicos.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'Leitura em tempo real',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22),
              ),
              const SizedBox(height: 10),
              _buildValue('Eixo X', event.x),
              _buildValue('Eixo Y', event.y),
              _buildValue('Eixo Z', event.z),
              _buildValue('Intensidade', intensidade),
              const SizedBox(height: 10),
              const Text(
                'Valores em µT (o campo da Terra fica entre ~25 e 65 µT)',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 30),
              const Text(
                'Bússola: deixe o celular deitado na mesa. '
                'A seta aponta para o norte magnético.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Center(
                child: Transform.rotate(
                  angle: -direcao * pi / 180,
                  child: const Icon(
                    Icons.navigation,
                    size: 120,
                    color: Colors.red,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '${direcao.toStringAsFixed(0)}° ${_pontoCardeal(direcao)}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Dica: aproxime um ímã ou objeto de metal e veja a intensidade subir.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildValue(String titulo, double valor) {
    return Card(
      child: ListTile(
        title: Text(titulo),
        trailing: Text(
          valor.toStringAsFixed(2),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
