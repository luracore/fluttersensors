import 'package:material_ui/material_ui.dart';

class LightSensorPage extends StatelessWidget {
  const LightSensorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Luz ambiente')),
      body: const Center(
        child: Text('Dados do sensor de luz'),
      ),
    );
  }
}
