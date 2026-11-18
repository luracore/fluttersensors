import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:material_ui/material_ui.dart';

class GpsPage extends StatefulWidget {
  const GpsPage({super.key});

  @override
  State<GpsPage> createState() => _GpsPageState();
}

class _GpsPageState extends State<GpsPage> {
  StreamSubscription<Position>? _subscription;
  Position? _posicao;
  String? _erro;
  // Ação oferecida junto com o erro (abrir configurações, tentar de novo...).
  String? _acaoTexto;
  VoidCallback? _acao;

  @override
  void initState() {
    super.initState();
    _iniciar();
  }

  Future<void> _iniciar() async {
    setState(() {
      _erro = null;
      _acao = null;
    });

    if (!await Geolocator.isLocationServiceEnabled()) {
      return _mostrarErro(
        'A localização do aparelho está desligada.',
        'Abrir configurações',
        () async {
          await Geolocator.openLocationSettings();
          _iniciar();
        },
      );
    }

    var permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
    }
    if (permissao == LocationPermission.denied) {
      return _mostrarErro('Permissão de localização negada.', 'Tentar novamente', _iniciar);
    }
    if (permissao == LocationPermission.deniedForever) {
      return _mostrarErro(
        'Permissão de localização bloqueada. Libere nas configurações do app.',
        'Abrir configurações do app',
        () async {
          await Geolocator.openAppSettings();
          _iniciar();
        },
      );
    }

    await _subscription?.cancel();
    _subscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.best),
    ).listen(
      (posicao) => setState(() => _posicao = posicao),
      onError: (_) => _mostrarErro('Erro ao obter a localização.', 'Tentar novamente', _iniciar),
    );
  }

  void _mostrarErro(String erro, String acaoTexto, VoidCallback acao) {
    if (!mounted) return;
    setState(() {
      _erro = erro;
      _acaoTexto = acaoTexto;
      _acao = acao;
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GPS')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_erro != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.location_off, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(_erro!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              if (_acao != null)
                FilledButton(onPressed: _acao, child: Text(_acaoTexto!)),
            ],
          ),
        ),
      );
    }

    final p = _posicao;
    if (p == null) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Buscando satélites...\n(fica mais rápido ao ar livre)', textAlign: TextAlign.center),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Captura a localização do aparelho via satélite (GPS / GNSS). '
          'Usado em mapas, apps de entrega, rotas e marcação de localização.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        const Text(
          'Leitura em tempo real',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22),
        ),
        const SizedBox(height: 10),
        _buildValue('Latitude', '${p.latitude.toStringAsFixed(6)}°'),
        _buildValue('Longitude', '${p.longitude.toStringAsFixed(6)}°'),
        _buildValue('Altitude', '${p.altitude.toStringAsFixed(2)} m'),
        _buildValue('Precisão', '± ${p.accuracy.toStringAsFixed(2)} m'),
        _buildValue('Velocidade', '${(p.speed * 3.6).toStringAsFixed(2)} km/h'),
        const SizedBox(height: 10),
        Text(
          'Última atualização: ${TimeOfDay.fromDateTime(p.timestamp.toLocal()).format(context)}',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
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
