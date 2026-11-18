import 'dart:io' show Platform;
import 'dart:math';

import 'package:light/light.dart';
import 'package:material_ui/material_ui.dart';

class LightSensorPage extends StatefulWidget {
  const LightSensorPage({super.key});

  @override
  State<LightSensorPage> createState() => _LightSensorPageState();
}

class _LightSensorPageState extends State<LightSensorPage> {
  late final Stream<int> _stream;

  @override
  void initState() {
    super.initState();
    _stream = Light().lightSensorStream;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Luz ambiente')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // No iOS o plugin depende do SensorKit (autorização especial da Apple).
    if (Platform.isIOS) {
      return const Center(child: Text('Sensor de luz disponível só no Android'));
    }

    return StreamBuilder<int>(
      stream: _stream,
      builder: (context, snapshot) {
        if (snapshot.hasError || (snapshot.data ?? 0) < 0) {
          return const Center(child: Text('Sensor não disponível neste aparelho'));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final lux = snapshot.data!;
        // Escala logarítmica: 0 lux = preto, ~100.000 lux (sol) = amarelo forte.
        final t = (log(lux + 1) / ln10 / 5).clamp(0.0, 1.0);
        final cor = Color.lerp(Colors.black, Colors.yellow, t)!;
        final textoClaro = t < 0.5;

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Mede a intensidade da luz ao redor do aparelho. Usado para ajustar '
              'o brilho da tela automaticamente, economizando bateria e dando '
              'conforto visual.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'Leitura em tempo real',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 10),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 220,
              decoration: BoxDecoration(
                color: cor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    lux < 10 ? Icons.dark_mode : Icons.light_mode,
                    size: 80,
                    color: textoClaro ? Colors.white : Colors.black,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '$lux lux',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: textoClaro ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(
                    _ambiente(lux),
                    style: TextStyle(
                      fontSize: 18,
                      color: textoClaro ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Tampe o sensor (perto da câmera frontal) ou aponte para uma lâmpada '
              'e veja o valor mudar.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        );
      },
    );
  }

  String _ambiente(int lux) {
    if (lux < 10) return 'Escuro';
    if (lux < 200) return 'Ambiente interno';
    if (lux < 1000) return 'Bem iluminado';
    if (lux < 10000) return 'Ao ar livre (sombra)';
    return 'Sol direto';
  }
}
