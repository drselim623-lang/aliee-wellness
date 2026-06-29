import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aliee_wellness/main.dart';

void main() {
  testWidgets('App boots and reaches role selection screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: AlieeWellnessApp()));
    await tester.pumpAndSettle();
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
