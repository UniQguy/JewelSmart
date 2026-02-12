import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; //
import 'core/router/app_router.dart';
import 'core/router/app_routes.dart';

void main() {
  runApp(
    // ProviderScope is the Riverpod equivalent of MultiProvider
    const ProviderScope(
      child: JewelSmartApp(),
    ),
  );
}

class JewelSmartApp extends StatelessWidget {
  const JewelSmartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jewel Smart',
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}