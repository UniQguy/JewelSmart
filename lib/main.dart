import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';

// Core Architecture Imports
import 'core/router/app_router.dart';
import 'core/router/app_routes.dart';
import 'core/theme/theme.dart';

void main() async {
  // Required for Firebase and Platform channel initialization
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the Firebase connection for JewelSmart
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Wrap with ProviderScope for Riverpod state management (Cart, Inventory, Auth)
  runApp(const ProviderScope(child: JewelSmart()));
}

class JewelSmart extends StatelessWidget {
  const JewelSmart({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JewelSmart',

      // CRITICAL ARCHITECTURAL SHIFT:
      // Injecting the Global Luxury Theme we built earlier.
      // This guarantees the transparent scaffolds, cinematic typography,
      // and glassmorphic input decorations are applied globally.
      theme: AppTheme.luxuryTheme,

      // SETTING THE ENTRY POINT
      // initialRoute: Starts the app at the Grand Overture (SplashScreen)
      // onGenerateRoute: Uses the AppRouter to handle the custom 600ms FadeTransitions
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}