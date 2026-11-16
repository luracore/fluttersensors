import 'package:material_ui/material_ui.dart';

class BarometerPage extends StatelessWidget {
  const BarometerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Barômetro')),
      body: const Center(
        child: Text('Dados do barômetro'),
      ),
    );
  }
}
