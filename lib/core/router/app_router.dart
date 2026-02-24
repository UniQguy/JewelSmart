import 'package:flutter/material.dart';
import '../../features/auth/presentation/auth_wrapper.dart';
import 'app_routes.dart';

// Import all presentation layers
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/auth/presentation/login_page.dart';
import '../../features/auth/presentation/signup_page.dart';
import '../../features/auth/presentation/home_page.dart';
import '../../features/auth/presentation/product_detail_page.dart';
import '../../features/auth/presentation/search_screen.dart';
import '../../features/auth/presentation/success_page.dart';
import '../../features/auth/presentation/category_page.dart';
import '../../features/auth/domain/product_model.dart'; // REQUIRED for passing product data
import '../../features/cart/presentation/cart_page.dart';
import '../../features/profile/presentation/profile_page.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
    // 1. Initial Entry Point
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

    // 2. The Logic Gate (Splash redirects here)
      case AppRoutes.authWrapper:
        return MaterialPageRoute(builder: (_) => const AuthWrapper());

      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case AppRoutes.signup:
        return MaterialPageRoute(builder: (_) => const SignupPage());

      case AppRoutes.home:
      case AppRoutes.main:
        return MaterialPageRoute(builder: (_) => const HomePage());

      case AppRoutes.search:
        return MaterialPageRoute(builder: (_) => const SearchScreen());

    // 3. FIXED: Passes the Product object to prevent Red Screen error
      case AppRoutes.productDetail:
        return MaterialPageRoute(
          builder: (_) => const ProductDetailPage(), // No argument needed here now
          settings: settings, // This passes the product data
        );

      case AppRoutes.cart:
        return MaterialPageRoute(builder: (_) => const CartPage());

      case AppRoutes.success:
        return MaterialPageRoute(builder: (_) => const SuccessPage());

      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());

    // 4. FIXED: DYNAMIC CATEGORY ROUTE
      case AppRoutes.category:
        final String categoryName = settings.arguments as String? ?? 'Collection';
        return MaterialPageRoute(
          builder: (_) => CategoryPage(categoryName: categoryName),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Text(
                'No route defined for ${settings.name}',
                style: const TextStyle(color: Colors.white, letterSpacing: 2),
              ),
            ),
          ),
        );
    }
  }
}