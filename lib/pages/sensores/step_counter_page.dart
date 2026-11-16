import 'package:material_ui/material_ui.dart';

class StepCounterPage extends StatelessWidget {
  const StepCounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contador de passos')),
      body: const Center(
        child: Text('Dados do contador de passos'),
      ),
    );
  }
}
