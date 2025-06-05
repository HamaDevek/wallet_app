import 'package:get/route_manager.dart';
import 'package:wallet_app/middleware/auth_middleware.dart';
import 'package:wallet_app/pages/app_page.dart';
import 'package:wallet_app/pages/auth/login_page.dart';
import 'package:wallet_app/pages/auth/onboarding_page.dart';
import 'package:wallet_app/pages/auth/register_page.dart';
import 'package:wallet_app/pages/recharge/recharge_page.dart';

class RouteNames {
  static final List<GetPage<dynamic>> routes = [
    GetPage(
      name: AppPage.routeName,
      page: () => const AppPage(),
      title: 'Home',
      transition: Transition.fadeIn,
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: OnboardingPage.routeName,
      page: () => const OnboardingPage(),
      title: 'Onboarding',
      transition: Transition.fadeIn,
    ),
    // register and login routes
    GetPage(
      name: RegisterPage.routeName,
      page: () => const RegisterPage(),
      title: 'Register',
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: LoginPage.routeName,
      page: () => const LoginPage(),
      title: 'Login',
      transition: Transition.fadeIn,
    ),
    // RechargePage
    GetPage(
      name: RechargePage.routeName,
      page: () => const RechargePage(),
      title: 'Recharge',
      transition: Transition.fadeIn,
      middlewares: [AuthMiddleware()],
    ),
  ];
}
