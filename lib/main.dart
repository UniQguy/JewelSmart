import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';

// Core Router Imports
import 'core/router/app_router.dart';
import 'core/router/app_routes.dart';

void main() async {
  // Required for Firebase and Platform channel initialization
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the Firebase connection for Jewelsmart-231fb
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Wrap with ProviderScope for Riverpod state management
  runApp(const ProviderScope(child: JewelSmart()));
}

class JewelSmart extends StatelessWidget {
  const JewelSmart({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JewelSmart',

      // Global Luxury Theme Configuration
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        fontFamily: 'Cinzel', // Your IMCA luxury font
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFD4AF37), // Luxury Gold
          surface: Colors.black,
        ),
      ),

      // SETTING THE ENTRY POINT
      // initialRoute: Starts the app at the SplashScreen (AppRoutes.splash)
      // onGenerateRoute: Uses the AppRouter to handle transitions
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRouter.generateRoute,

      // NOTE: 'home:' is removed to prevent it from overriding the splash screen
    );
  }
}