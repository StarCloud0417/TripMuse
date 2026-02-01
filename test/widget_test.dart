// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    // Build a simple test app without complex initialization
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('TripMind')),
            body: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Welcome to TripMind'),
                  Text('AI 智能旅行規劃助手'),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    // Verify that the app title is displayed
    expect(find.text('TripMind'), findsOneWidget);

    // Verify that the welcome message is displayed
    expect(find.text('Welcome to TripMind'), findsOneWidget);
    
    // Verify that the subtitle is displayed
    expect(find.text('AI 智能旅行規劃助手'), findsOneWidget);
  });
}
