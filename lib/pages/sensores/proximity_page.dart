import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:proximity_sensor/proximity_sensor.dart';

class ProximityPage extends StatefulWidget {
  const ProximityPage({super.key});

  @override
  State<ProximityPage> createState() => _ProximityPageState();
}

class _ProximityPageState extends State<ProximityPage> {
  StreamSubscription<int>? _subscription;
  bool? _perto; 
  String? _erro;

  @override
  void initState() {
    super.initState();
    _subscription = ProximitySensor.events.listen(
      (evento) {
        setState(() => _perto = evento > 0);
      },
      onError: (_) => setState(() => _erro = 'Sensor não disponível neste aparelho'),
      cancelOnError: true,
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Proximidade')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_erro != null) return Center(child: Text(_erro!));

    final perto = _perto;
    if (perto == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'Aguardando leitura...\n(passe a mão perto do topo da tela)',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Detecta se há um objeto (como seu rosto ou a mão) muito perto da tela. '
          'Usado para apagar a tela durante uma ligação e evitar toques acidentais.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        const Text(
          'Leitura em tempo real',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22),
        ),
        const SizedBox(height: 30),
        Center(
          child: Icon(
            perto ? Icons.back_hand : Icons.sensors,
            size: 120,
            color: perto ? Colors.red : Colors.green,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          perto ? 'Objeto PERTO' : 'Nenhum objeto por perto',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Card(
          child: ListTile(
            title: const Text('Estado'),
            trailing: Text(
              perto ? 'Perto' : 'Longe',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'O sensor fica perto do alto-falante, na parte de cima da frente do celular. '
          'A maioria dos aparelhos só informa dois estados: perto ou longe.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
