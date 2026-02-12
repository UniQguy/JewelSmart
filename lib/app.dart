import 'package:flutter/material.dart';
import 'core/theme/theme.dart'; // Import your theme file
import 'core/router/app_router.dart';
import 'core/router/app_routes.dart';

class JewelSmartApp extends StatelessWidget {
  const JewelSmartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JewelSmart',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.luxuryTheme, // Apply the luxury theme here
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}