# AGENTS.md

Instruções para agentes de IA (e humanos) que forem contribuir neste projeto.
Leia tudo antes de gerar código. O objetivo é que todas as páginas fiquem com o mesmo padrão.

## Sobre o projeto

App Flutter (`sensores`) para **demonstrar os sensores do smartphone**, feito para um workshop da universidade.
A demonstração é feita rodando o app em **modo depuração** (`flutter run`) num **celular físico**. O emulador não tem a maioria dos sensores.

- Cada sensor tem **uma página** em `lib/pages/sensores/`.
- A `HomePage` (`lib/pages/home_page.dart`) lista os sensores e navega para a página de cada um.
- Cada integrante do grupo cuida de uma ou mais páginas.

## Estrutura

```
lib/
  main.dart                     # MaterialApp, tema, home
  pages/
    home_page.dart              # lista de sensores (titulo, descricao, icone, rota)
    sensores/
      accelerometer_page.dart   # ✅ IMPLEMENTADO: use como referência
      gyroscope_page.dart
      magnetometer_page.dart
      gps_page.dart
      barometer_page.dart
      proximity_page.dart
      light_sensor_page.dart
      gravity_page.dart
test/
  widget_test.dart
```

Não crie pastas novas (`widgets/`, `services/`, `utils/`, etc.) sem combinar com o grupo. Se um widget for usado só na sua página, deixe-o como método privado (`_buildValue`) dentro do próprio arquivo.

## Sensores e pacotes

| Página | Arquivo | Fonte dos dados | Unidade |
|---|---|---|---|
| Acelerômetro | `accelerometer_page.dart` | `sensors_plus`: `accelerometerEventStream()` | m/s² |
| Giroscópio | `gyroscope_page.dart` | `sensors_plus`: `gyroscopeEventStream()` | rad/s |
| Magnetômetro | `magnetometer_page.dart` | `sensors_plus`: `magnetometerEventStream()` | µT |
| Barômetro | `barometer_page.dart` | `sensors_plus`: `barometerEventStream()` | hPa |
| Gravidade | `gravity_page.dart` | `sensors_plus`: `accelerometerEventStream()` | m/s² |
| Proximidade | `proximity_page.dart` | `proximity_sensor` | perto/longe |
| Luz ambiente | `light_sensor_page.dart` | `light` (só Android) | lux |
| GPS | `gps_page.dart` | `geolocator` | lat/long (graus) |

Regras para dependências:
- **Prefira o `sensors_plus`**, que já está instalado. Só adicione outro pacote quando ele não cobrir o sensor.
- Adicione com `flutter pub add <pacote>` (nunca editando versões à mão) e faça commit do `pubspec.yaml` **e** do `pubspec.lock`.
- Se o pacote exigir permissões (GPS, passos), adicione-as em `android/app/src/main/AndroidManifest.xml` (e `ios/Runner/Info.plist` se for testar no iOS) e peça a permissão em tempo de execução na própria página.

## Convenções de código

- **Import do Material:** o projeto usa `import 'package:material_ui/material_ui.dart';` no lugar de `package:flutter/material.dart`. Mantenha esse import.
- **Idioma:** textos da interface, nomes de variáveis de domínio e commits em **português**. Nomes de classes e arquivos seguem o padrão existente (`XxxPage`, `xxx_page.dart`).
- **Lints:** o código precisa passar em `flutter analyze` sem warnings (`flutter_lints`).
- Use `const` sempre que possível.

## Padrão de uma página de sensor

Siga `accelerometer_page.dart` como modelo. Toda página deve ter:

1. `Scaffold` com `AppBar` mostrando o nome do sensor (o mesmo `titulo` da `HomePage`).
2. **Leitura em tempo real** com `StreamBuilder` sobre o stream do sensor, criado uma única vez no `initState` (não crie o stream dentro do `build`).
3. Os três estados tratados:
   - carregando → `CircularProgressIndicator`;
   - erro / sensor indisponível → mensagem em texto (ex.: `'Sensor não disponível neste aparelho'`);
   - com dados → os valores.
4. Valores formatados com `toStringAsFixed(2)` e a **unidade** visível na tela.
5. Um texto curto explicando **o que o sensor mede** e **um exemplo de uso real**, já que o app é usado para apresentar.
6. (Opcional, recomendado) uma visualização simples que deixe a demonstração mais clara, usando só widgets do Flutter (ex.: bússola com `Transform.rotate` no magnetômetro, tela que muda de cor no sensor de proximidade). Não adicione bibliotecas de gráficos sem combinar com o grupo.

Se a página usar `StreamSubscription` (em vez de `StreamBuilder`) ou um `Timer`, **cancele no `dispose()`**.

Esqueleto:

```dart
import 'package:material_ui/material_ui.dart';
import 'package:sensors_plus/sensors_plus.dart';

class GyroscopePage extends StatefulWidget {
  const GyroscopePage({super.key});

  @override
  State<GyroscopePage> createState() => _GyroscopePageState();
}

class _GyroscopePageState extends State<GyroscopePage> {
  late final Stream<GyroscopeEvent> _stream;

  @override
  void initState() {
    super.initState();
    _stream = gyroscopeEventStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Giroscópio')),
      body: StreamBuilder<GyroscopeEvent>(
        stream: _stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Sensor não disponível neste aparelho'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final e = snapshot.data!;
          // ... valores + unidade + explicação
        },
      ),
    );
  }
}
```

## Regras de colaboração

- **Mexa só na(s) sua(s) página(s).** Não altere páginas de outros integrantes.
- Na `home_page.dart`, altere apenas a entrada do seu sensor (descrição/ícone). Não reordene nem remova as outras.
- Não mude `main.dart`, tema ou nome da classe/arquivo das páginas sem combinar com o grupo.
- **Branch por sensor**, a partir da `main`: `feat/<sensor>` (ex.: `feat/giroscopio`, `feat/gps`).
- Commits curtos em português, no imperativo: `Implementa página do giroscópio`.
- Abra um Pull Request para a `main`. Não faça push direto na `main`.

## Antes de abrir o PR

```bash
flutter pub get
flutter analyze      # sem warnings
flutter test         # testes passando
flutter run          # testado num celular físico
```

Se você adicionou ou mudou o título de um sensor na `HomePage`, confira se o `test/widget_test.dart` continua passando.
