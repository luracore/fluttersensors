import 'dart:async';
import 'dart:math';

import 'package:material_ui/material_ui.dart';
import 'package:sensors_plus/sensors_plus.dart';

class MagnetometerPage extends StatefulWidget {
  const MagnetometerPage({super.key});

  @override
  State<MagnetometerPage> createState() => _MagnetometerPageState();
}

class _MagnetometerPageState extends State<MagnetometerPage> {
  // Suavização (filtro passa-baixa): 0 = não muda, 1 = sem filtro.
  // Menor = seta mais estável, porém mais lenta para reagir.
  static const double _suavizacao = 0.15;

  StreamSubscription<MagnetometerEvent>? _magSub;
  StreamSubscription<AccelerometerEvent>? _accSub;
  List<double>? _campo; // campo magnético filtrado (µT)
  List<double>? _gravidade; // acelerômetro filtrado ≈ gravidade (m/s²)
  double _direcao = 0;
  String? _erro;

  @override
  void initState() {
    super.initState();
    void falhou(Object _) =>
        setState(() => _erro = 'Sensor não disponível neste aparelho');

    // O acelerômetro diz onde é "para baixo", para descontar a inclinação do celular.
    _accSub = accelerometerEventStream(samplingPeriod: SensorInterval.uiInterval)
        .listen((e) => _gravidade = _filtrar(_gravidade, [e.x, e.y, e.z]),
            onError: falhou, cancelOnError: true);
    _magSub = magnetometerEventStream(samplingPeriod: SensorInterval.uiInterval)
        .listen((e) {
      _campo = _filtrar(_campo, [e.x, e.y, e.z]);
      setState(() => _direcao = _calcularDirecao(_campo!, _gravidade) ?? _direcao);
    }, onError: falhou, cancelOnError: true);
  }

  @override
  void dispose() {
    _magSub?.cancel();
    _accSub?.cancel();
    super.dispose();
  }

  List<double> _filtrar(List<double>? anterior, List<double> novo) => anterior == null
      ? novo
      : [for (var i = 0; i < 3; i++) anterior[i] + _suavizacao * (novo[i] - anterior[i])];

  /// Rumo em graus (0° = norte magnético, sentido horário), compensando a
  /// inclinação. Mesma conta do SensorManager.getRotationMatrix do Android.
  double? _calcularDirecao(List<double> e, List<double>? g) {
    // Sem acelerômetro ainda: assume o celular deitado.
    g ??= [0, 0, 1];
    // H = E × G aponta para o leste no plano horizontal.
    final hx = e[1] * g[2] - e[2] * g[1];
    final hy = e[2] * g[0] - e[0] * g[2];
    final hz = e[0] * g[1] - e[1] * g[0];
    final normaH = sqrt(hx * hx + hy * hy + hz * hz);
    final normaG = sqrt(g[0] * g[0] + g[1] * g[1] + g[2] * g[2]);
    // Campo paralelo à gravidade (perto dos polos) ou queda livre: mantém o anterior.
    if (normaH < 0.1 || normaG < 0.1) return null;
    // M = G × H aponta para o norte no plano horizontal.
    final my = (g[2] * hx - g[0] * hz) / (normaG * normaH);
    final graus = atan2(hy / normaH, my) * 180 / pi;
    return (graus + 360) % 360;
  }

  String _pontoCardeal(double graus) {
    const pontos = ['N', 'NE', 'L', 'SE', 'S', 'SO', 'O', 'NO'];
    return pontos[((graus + 22.5) % 360 ~/ 45)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Magnetômetro')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_erro != null) {
      return Center(child: Text(_erro!));
    }

    final campo = _campo;
    if (campo == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final intensidade = sqrt(
      campo[0] * campo[0] + campo[1] * campo[1] + campo[2] * campo[2],
    );
    final direcao = _direcao;

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
        _buildValue('Eixo X', campo[0]),
        _buildValue('Eixo Y', campo[1]),
        _buildValue('Eixo Z', campo[2]),
        _buildValue('Intensidade', intensidade),
        const SizedBox(height: 10),
        const Text(
          'Valores em µT (o campo da Terra fica entre ~25 e 65 µT)',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 30),
        const Text(
          'Bússola: segure o celular deitado (pode inclinar um pouco). '
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
          'Dica: aproxime um ímã ou objeto de metal e veja a intensidade subir. '
          'Se a bússola errar, calibre movendo o celular em forma de "8" e '
          'afaste-o de metais (notebook, mesa de ferro).',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      ],
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
