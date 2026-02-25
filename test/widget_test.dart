import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Required for ProviderScope
import 'package:jewelsmart/main.dart';

void main() {
  testWidgets('JewelSmart smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // FIXED: Changed MyApp() to JewelSmart() and added ProviderScope
    await tester.pumpWidget(const ProviderScope(child: JewelSmart()));

    // Note: The original counter test logic will fail because JewelSmart 
    // does not have a counter. You can safely delete or comment out 
    // the expect() lines below if you just want the test to pass.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}