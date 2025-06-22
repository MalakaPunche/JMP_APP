// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jmp/main.dart';

void main() {
  testWidgets('JMP app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our app starts with MaterialApp
    expect(find.byType(MaterialApp), findsOneWidget);
    
    // Wait for the app to settle (but not too long to avoid timer issues)
    await tester.pump();
    
    // Verify that the app is running without errors
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
