// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sensores/main.dart';

void main() {
  testWidgets('Home page lists the available sensors', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Tela Inicial'), findsOneWidget);
    expect(find.text('Acelerômetro'), findsOneWidget);
    expect(find.text('Giroscópio'), findsOneWidget);
    expect(find.byType(ListTile), findsWidgets);
  });
}
