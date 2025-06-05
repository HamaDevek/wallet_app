import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallet_app/binding.dart';
import 'package:wallet_app/pages/app_page.dart';
import 'package:wallet_app/routes/v1.dart';

class InitPage extends StatefulWidget {
  const InitPage({super.key});

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  @override
  void initState() {
    super.initState();
    print('InitPage initialized');
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Wallet App',

      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: Colors.blueAccent,
        appBarTheme: const AppBarTheme(),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blueAccent, // Default button color
          textTheme: ButtonTextTheme.primary, // Text color for buttons
        ),
        // NavigationDestination
        navigationBarTheme: NavigationBarThemeData(
          indicatorColor: Colors.blueAccent.withValues(alpha: .2),
          backgroundColor: Colors.white,
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      // home: AppPage.routeName, // Replace with your actual home widget
      debugShowCheckedModeBanner: false,
      getPages: RouteNames.routes,
      initialRoute: AppPage.routeName,
      initialBinding: BindingManager(),
    );
  }
}
