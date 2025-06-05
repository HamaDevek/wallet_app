import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallet_app/controllers/auth_controller.dart';
import 'package:wallet_app/pages/auth/onboarding_page.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    AuthController.to.setUserFromSharedPreferences();
    bool isLoggedIn = AuthController.to.isLoggedIn;
    if (!isLoggedIn) {
      return const RouteSettings(name: OnboardingPage.routeName);
    }
    
    return null;
  }
}
