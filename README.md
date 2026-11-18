# Sensores: demonstração dos sensores do smartphone

App Flutter desenvolvido para o workshop de **LLDM**. Cada página do app demonstra, em tempo real, um sensor do celular: o que ele mede e para que é usado.

## Sensores explorados

| Sensor | O que faz | Exemplo de uso | Status |
|---|---|---|---|
| **Acelerômetro** | Mede a aceleração linear nos eixos X, Y e Z, incluindo a gravidade. | Orientação da tela, detectar "chacoalhar", contar passos. | ✅ |
| **Giroscópio** | Mede a velocidade de rotação nos três eixos. | Realidade aumentada, estabilização de imagem, panoramas 360°. | ✅ |
| **Magnetômetro** | Mede o campo magnético ao redor do aparelho (bússola digital). | Navegação e direção cardeal. | ✅ |
| **Proximidade** | Detecta objetos próximos à tela sem contato (infravermelho). | Apagar a tela ao encostar o celular no ouvido durante uma ligação. | ✅ |
| **Luz ambiente** | Mede a intensidade de luz do ambiente. | Brilho automático da tela. | ✅ |
| **Barômetro** | Mede a pressão atmosférica. | Altimetria (em que andar você está) e previsão do tempo. | ✅ |
| **GPS / GNSS** | Obtém a geolocalização via satélite. | Mapas, entregas, rotas, latitude e longitude. | ✅ |
| **Gravidade** | Isola a direção e a intensidade da gravidade. | Saber a inclinação do aparelho, nivelamento. | ✅ |

> Nem todo aparelho tem todos os sensores (barômetro e luz ambiente, por exemplo, faltam em vários modelos). Nesse caso a página avisa que o sensor não está disponível.

## Pré-requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) **3.47 ou superior** (Dart `^3.13.7`). Versões antigas falham no `flutter pub get`; atualize com `flutter upgrade`.
- Android Studio ou o Android SDK (para `adb` e drivers)
- Um **smartphone físico**: o emulador simula poucos sensores e não serve para a demonstração.

Verifique o ambiente com:

```bash
flutter doctor
```

## Como rodar (modo depuração)

1. **Ative o modo desenvolvedor no celular** (Android): *Configurações → Sobre o telefone →* toque 7 vezes em *Número da versão*.
2. Em *Opções do desenvolvedor*, ative a **Depuração USB** (ou *Depuração por Wi-Fi*).
3. Conecte o celular ao computador e aceite a autorização de depuração que aparece na tela.
4. Na pasta do projeto:

```bash
flutter pub get
flutter devices      # o celular deve aparecer na lista
flutter run          # compila e instala em modo debug
```

Se houver mais de um dispositivo: `flutter run -d <id-do-dispositivo>`.

Atalhos no terminal durante o `flutter run`:

| Tecla | Ação |
|---|---|
| `r` | Hot reload (aplica mudanças mantendo o estado) |
| `R` | Hot restart (reinicia o app) |
| `q` | Encerra |

Pelo VS Code: abra o projeto, selecione o celular na barra inferior e aperte **F5**.

## Estrutura

```
lib/
  main.dart                 # ponto de entrada
  pages/
    home_page.dart          # lista de sensores
    sensores/               # uma página por sensor
test/
  widget_test.dart
```

## Como contribuir

Cada integrante implementa a página do(s) seu(s) sensor(es) numa branch própria (`feat/<sensor>`) e abre um Pull Request para a `main`.
O padrão de código, os pacotes de cada sensor e o checklist antes do PR estão no **[AGENTS.md](AGENTS.md)**. Leia antes de começar, principalmente se for usar IA para gerar o código.

```bash
flutter analyze
flutter test
```

## Pacotes

- [`sensors_plus`](https://pub.dev/packages/sensors_plus): acelerômetro, giroscópio, magnetômetro, barômetro
- [`geolocator`](https://pub.dev/packages/geolocator): GPS / GNSS
- [`proximity_sensor`](https://pub.dev/packages/proximity_sensor): sensor de proximidade
- [`light`](https://pub.dev/packages/light): luz ambiente (só Android)
- [`material_ui`](https://pub.dev/packages/material_ui): widgets Material
