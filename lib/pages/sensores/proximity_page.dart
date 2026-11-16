import 'package:material_ui/material_ui.dart';

class ProximityPage extends StatelessWidget {
  const ProximityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Proximidade')),
      body: const Center(
        child: Text('Dados do sensor de proximidade'),
      ),
    );
  }
}
