import 'package:flutter/material.dart';

// Core Architecture Imports
import 'core/theme/theme.dart';
import 'core/router/app_router.dart';
import 'core/router/app_routes.dart';

/// THE APPLICATION ROOT
/// Encapsulates the global luxury theme and the cinematic routing engine.
class JewelSmartApp extends StatelessWidget {
  const JewelSmartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JewelSmart',
      debugShowCheckedModeBanner: false,

      // CRITICAL: Injects the global spatial UI, transparent scaffolds, and cinematic typography
      theme: AppTheme.luxuryTheme,

      // BOOT SEQUENCE: Grand Overture (Splash) -> Auth Gatekeeper -> Global Shell
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}