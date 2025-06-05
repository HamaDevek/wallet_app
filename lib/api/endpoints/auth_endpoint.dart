import 'package:wallet_app/shared/env.dart';

class AuthEndpoint {
  const AuthEndpoint();
  String get login => '$apiUrl/auth/login';
  String get me => '$apiUrl/auth/me';
  String get logout => '$apiUrl/auth/logout';
  String get register => '$apiUrl/auth/register';
  String get health => '$apiUrl/health';
}
