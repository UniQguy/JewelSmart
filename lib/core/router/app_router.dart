import 'package:flutter/material.dart';
import 'package:jewelsmart/features/main_wrapper.dart';
import 'app_routes.dart';
import '../../features/auth/presentation/login_page.dart';
import '../../features/auth/presentation/signup_page.dart';
import '../../features/auth/presentation/home_page.dart';
import '../../features/auth/presentation/product_detail_page.dart';
import '../../features/auth/presentation/search_screen.dart';
import '../../features/cart/presentation/cart_page.dart'; // Import your new cart page

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case AppRoutes.signup:
        return MaterialPageRoute(builder: (_) => const SignupPage());

      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomePage());

      case AppRoutes.productDetail:
        return MaterialPageRoute(builder: (_) => const ProductDetailPage());

      case AppRoutes.search:
        return MaterialPageRoute(builder: (_) => const SearchScreen());

      case AppRoutes.cart:
        return MaterialPageRoute(builder: (_) => const CartPage());

    // Inside AppRouter.generateRoute switch case:
      case AppRoutes.main:
        return MaterialPageRoute(builder: (_) => const MainWrapper());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Text(
                'No route defined for ${settings.name}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
    }
  }
}