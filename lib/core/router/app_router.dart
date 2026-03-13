import 'package:flutter/material.dart';

// Core Application Shell
import '../../features/main_wrapper.dart'; // CRITICAL: The Global 3D Shell
import 'app_routes.dart';

// Authentication & Onboarding
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/auth/presentation/auth_wrapper.dart';
import '../../features/auth/presentation/login_page.dart';
import '../../features/auth/presentation/signup_page.dart';

// Customer Facing (Discovery & Identity)
import '../../features/auth/presentation/home_page.dart';
import '../../features/auth/presentation/search_screen.dart';
import '../../features/auth/presentation/category_page.dart';
import '../../features/auth/presentation/product_detail_page.dart';
import '../../features/profile/presentation/profile_page.dart';

// Customer Facing (Acquisition Loop)
import '../../features/cart/presentation/cart_page.dart';
import '../../features/cart/presentation/checkout_page.dart'; // NEW
import '../../features/cart/presentation/success_page.dart'; // CORRECTED PATH

// Administrative Layers
import '../../features/auth/presentation/admin_dashboard.dart';
import '../../features/auth/presentation/staff_dashboard.dart';
import '../../features/auth/presentation/repair_management_screen.dart';
import '../../features/admin/presentation/add_product_screen.dart';

// AR Try-On
import '../../features/try_on/presentation/try_on_page.dart'; // NEW

/// THE GLOBAL ROUTING GATEWAY
/// Handles cinematic screen transitions and ensures proper spatial handoffs.
class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
    // 1. SYSTEM INITIALIZATION
      case AppRoutes.splash:
        return _cinematicRoute(const SplashScreen());

      case AppRoutes.authWrapper:
        return _cinematicRoute(const AuthWrapper());

      case AppRoutes.login:
        return _cinematicRoute(const LoginPage());

      case AppRoutes.signup:
        return _cinematicRoute(const SignupPage());

    // 2. THE GLOBAL SHELL
      case AppRoutes.main:
        return _cinematicRoute(const MainWrapper()); // Fixed: Points to Wrapper, not Home

    // 3. ISOLATED VIEWS (Tabs inside the Wrapper, but can be pushed directly if needed)
      case AppRoutes.home:
        return _cinematicRoute(const HomePage());

      case AppRoutes.search:
        return _cinematicRoute(const SearchScreen());

      case AppRoutes.cart:
        return _cinematicRoute(const CartPage());

      case AppRoutes.profile:
        return _cinematicRoute(const ProfilePage());

    // 4. THE ACQUISITION SEQUENCE
      case AppRoutes.productDetail:
        return _cinematicRoute(const ProductDetailPage(), settings: settings);

      case AppRoutes.checkout:
        return _cinematicRoute(const CheckoutPage()); // Fixed: Added missing route

      case AppRoutes.success:
        return _cinematicRoute(const SuccessPage());

      case AppRoutes.category:
        final String categoryName = settings.arguments as String? ?? 'COLLECTION';
        return _cinematicRoute(CategoryPage(categoryName: categoryName));

    // 5. THE VIRTUAL ATELIER
      case AppRoutes.tryOn: // Assuming you will add this to app_routes.dart
        return _cinematicRoute(const TryOnPage());

    // 6. ADMINISTRATIVE BACKEND
      case AppRoutes.adminDashboard:
        return _cinematicRoute(const AdminDashboard());

      case AppRoutes.staffDashboard:
        return _cinematicRoute(const StaffDashboard());

      case AppRoutes.repairManagement:
        return _cinematicRoute(const RepairManagementScreen());

      case AppRoutes.addProduct:
        return _cinematicRoute(const AddProductScreen());

        default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Text(
                'VOID ANOMALY: ${settings.name}',
                style: const TextStyle(color: Color(0xFFD4AF37), letterSpacing: 5, fontSize: 10),
              ),
            ),
          ),
        );
    }
  }

  /// A custom page route builder to ensure transitions are buttery smooth
  /// and don't feature the harsh white flashes of standard Material transitions.
  static PageRouteBuilder _cinematicRoute(Widget page, {RouteSettings? settings}) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation.drive(CurveTween(curve: Curves.easeOutCubic)),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 600), // Slower, premium transition
    );
  }
}