import 'package:material_ui/material_ui.dart';

class RotationPage extends StatelessWidget {
  const RotationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rotação')),
      body: const Center(
        child: Text('Dados do sensor de rotação'),
      ),
    );
  }
}
