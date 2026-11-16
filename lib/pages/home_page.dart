import 'package:material_ui/material_ui.dart';

import 'sensores/accelerometer_page.dart';
import 'sensores/gyroscope_page.dart';
import 'sensores/magnetometer_page.dart';
import 'sensores/gps_page.dart';
import 'sensores/barometer_page.dart';
import 'sensores/proximity_page.dart';
import 'sensores/light_sensor_page.dart';
import 'sensores/gravity_page.dart';
import 'sensores/rotation_page.dart';
import 'sensores/step_counter_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const List<Map<String, dynamic>> sensores = [
    {
      'titulo': 'Acelerômetro',
      'descricao': 'Mede a aceleração do dispositivo',
      'icone': Icons.speed,
      'rota': AccelerometerPage(),
    },
    {
      'titulo': 'Giroscópio',
      'descricao': 'Mede a velocidade de rotação do dispositivo',
      'icone': Icons.screen_rotation,
      'rota': GyroscopePage(),
    },
    {
      'titulo': 'Magnetômetro',
      'descricao': 'Mede o campo magnético ao redor do dispositivo',
      'icone': Icons.explore,
      'rota': MagnetometerPage(),
    },
    {
      'titulo': 'GPS',
      'descricao': 'Obtém a localização geográfica do dispositivo',
      'icone': Icons.location_on,
      'rota': GpsPage(),
    },
    {
      'titulo': 'Barômetro',
      'descricao': 'Mede a pressão atmosférica',
      'icone': Icons.speed,
      'rota': BarometerPage(),
    },
    {
      'titulo': 'Proximidade',
      'descricao': 'Detecta objetos próximos à tela do dispositivo',
      'icone': Icons.sensors,
      'rota': ProximityPage(),
    },
    {
      'titulo': 'Luz ambiente',
      'descricao': 'Mede a intensidade da luz no ambiente',
      'icone': Icons.light_mode,
      'rota': LightSensorPage(),
    },
    {
      'titulo': 'Gravidade',
      'descricao': 'Detecta a direção e intensidade da gravidade',
      'icone': Icons.public,
      'rota': GravityPage(),
    },
    {
      'titulo': 'Rotação',
      'descricao': 'Identifica a orientação espacial do dispositivo',
      'icone': Icons.screen_rotation_alt,
      'rota': RotationPage(),
    },
    {
      'titulo': 'Contador de passos',
      'descricao': 'Registra a quantidade de passos realizados',
      'icone': Icons.directions_walk,
      'rota': StepCounterPage(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tela Inicial')),
      body: ListView.builder(
        itemCount: sensores.length,
        itemBuilder: (context, index) {
          final sensor = sensores[index];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: Icon(sensor['icone']),
              title: Text(sensor['titulo']),
              subtitle: Text(sensor['descricao']),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => sensor['rota']),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
