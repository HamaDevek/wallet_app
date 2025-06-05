import 'package:flutter/material.dart';
import 'package:wallet_app/init_page.dart';
import 'package:wallet_app/utils/shared_preferences_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesHelper.init();
  // get data from shared preferences
  runApp(InitPage());
}
