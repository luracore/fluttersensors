import 'package:material_ui/material_ui.dart';

class GravityPage extends StatelessWidget {
  const GravityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gravidade')),
      body: const Center(
        child: Text('Dados do sensor de gravidade'),
      ),
    );
  }
}
