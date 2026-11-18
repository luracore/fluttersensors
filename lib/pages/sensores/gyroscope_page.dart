import 'dart:async';
import 'dart:math';

import 'package:material_ui/material_ui.dart';
import 'package:sensors_plus/sensors_plus.dart';

class GyroscopePage extends StatefulWidget {
  const GyroscopePage({super.key});

  @override
  State<GyroscopePage> createState() => _GyroscopePageState();
}

class _GyroscopePageState extends State<GyroscopePage> {
  StreamSubscription<GyroscopeEvent>? _subscription;
  GyroscopeEvent? _evento;
  String? _erro;

  // Ângulo acumulado no eixo Z (integração da velocidade angular).
  // Obs.: integração simples acumula drift com o tempo; o botão "Zerar" recalibra.
  double _anguloZ = 0;
  DateTime? _ultimaLeitura;

  @override
  void initState() {
    super.initState();
    // gameInterval (~20 ms) deixa a seta fluida; o padrão (200 ms) gira "aos trancos".
    _subscription = gyroscopeEventStream(samplingPeriod: SensorInterval.gameInterval).listen(
      _onEvento,
      onError: (_) => setState(() => _erro = 'Sensor não disponível neste aparelho'),
      cancelOnError: true,
    );
  }

  void _onEvento(GyroscopeEvent evento) {
    final agora = DateTime.now();
    if (_ultimaLeitura != null) {
      final dt = agora.difference(_ultimaLeitura!).inMicroseconds / 1e6;
      _anguloZ += evento.z * dt;
    }
    _ultimaLeitura = agora;
    setState(() => _evento = evento);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Giroscópio')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_erro != null) return Center(child: Text(_erro!));

    final evento = _evento;
    if (evento == null) return const Center(child: CircularProgressIndicator());

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Mede a velocidade de rotação do aparelho em torno dos eixos X, Y e Z. '
          'Usado em realidade aumentada, estabilização de imagem e fotos 360°.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        const Text(
          'Leitura em tempo real',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22),
        ),
        const SizedBox(height: 10),
        _buildValue('Eixo X (inclinar para frente/trás)', evento.x),
        _buildValue('Eixo Y (inclinar para os lados)', evento.y),
        _buildValue('Eixo Z (girar sobre a mesa)', evento.z),
        const SizedBox(height: 10),
        const Text(
          'Valores em rad/s (parado ≈ 0)',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 30),
        const Text(
          'Coloque o celular na mesa e gire: a seta acompanha a rotação.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Center(
          // Sinal negativo: o giroscópio mede anti-horário positivo,
          // e o Transform.rotate gira no sentido horário.
          child: Transform.rotate(
            angle: -_anguloZ,
            child: const Icon(Icons.navigation, size: 120, color: Colors.blue),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Ângulo acumulado: ${(_anguloZ * 180 / pi).toStringAsFixed(0)}°',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Center(
          child: OutlinedButton.icon(
            onPressed: () => setState(() => _anguloZ = 0),
            icon: const Icon(Icons.restart_alt),
            label: const Text('Zerar'),
          ),
        ),
      ],
    );
  }

  Widget _buildValue(String eixo, double valor) {
    return Card(
      child: ListTile(
        title: Text(eixo),
        trailing: Text(
          valor.toStringAsFixed(2),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
