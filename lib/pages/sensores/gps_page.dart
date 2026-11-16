import 'package:material_ui/material_ui.dart';

class GpsPage extends StatelessWidget {
  const GpsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GPS')),
      body: const Center(
        child: Text('Dados do GPS'),
      ),
    );
  }
}
