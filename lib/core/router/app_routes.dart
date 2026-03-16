class AppRoutes {
  // 1. System & Entrance
  static const String splash = '/';
  static const String authWrapper = '/auth-wrapper';

  // 2. Authentication
  static const String login = '/login';
  static const String signup = '/signup';

  // 3. The Global Shell & Core Tabs
  static const String main = '/main';
  static const String home = '/home';
  static const String search = '/search';
  static const String cart = '/cart';
  static const String profile = '/profile';

  // 4. Acquisition Sequence
  static const String productDetail = '/product-detail';
  static const String category = '/category';
  static const String checkout = '/checkout'; // ADDED: For the Security Protocol
  static const String success = '/success';

  // 5. The Virtual Atelier
  static const String tryOn = '/try-on'; // ADDED: For the AR Camera

  // 6. Dashboards & Administration
  static const String adminDashboard = '/admin-dashboard';
  static const String staffDashboard = '/staff-dashboard';
  static const String repairManagement = '/repair-management'; //  for admins
  static const String repairRequest = '/repair-request'; // For customers
  static const String addProduct = '/add-product';

  // Note: acquisitionHistory is now handled via a Glassmorphic Modal in ProfilePage,
  // but keeping the constant here in case you ever want a standalone route.
  static const String acquisitionHistory = '/acquisition-history';
}