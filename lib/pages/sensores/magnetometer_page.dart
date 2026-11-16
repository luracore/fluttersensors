import 'package:material_ui/material_ui.dart';

class MagnetometerPage extends StatelessWidget {
  const MagnetometerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Magnetômetro')),
      body: const Center(
        child: Text('Dados do magnetômetro'),
      ),
    );
  }
}
