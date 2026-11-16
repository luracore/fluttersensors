import 'package:material_ui/material_ui.dart';

class GyroscopePage extends StatelessWidget {
  const GyroscopePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Giroscópio')),
      body: const Center(
        child: Text('Dados do giroscópio'),
      ),
    );
  }
}
