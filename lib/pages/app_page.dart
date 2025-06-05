import 'package:flutter/material.dart';
import 'package:wallet_app/pages/home/history_page.dart';
import 'package:wallet_app/pages/home/home_page.dart';
import 'package:wallet_app/pages/home/profile_page.dart';
import 'package:wallet_app/pages/home/send_money_page.dart';

class AppPage extends StatefulWidget {
  static const String routeName = '/';
  const AppPage({super.key});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  NavigationDestinationLabelBehavior labelBehavior =
      NavigationDestinationLabelBehavior.alwaysShow;
  int currentPageIndex = 0;
  // controller for the page view
  final PageController pageController = PageController();

  final List<Widget> _pages = [
    const HomePage(),
    const SendMoneyPage(),
    const HistoryPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        itemBuilder: (context, index) {
          return _pages[index];
        },
        onPageChanged: (index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        controller: pageController,
        itemCount: _pages.length,
        physics: const NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: NavigationBar(
        labelBehavior: labelBehavior,
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
            pageController.jumpToPage(index);
          });
        },
        destinations: const <Widget>[
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(
            icon: Icon(Icons.monetization_on),
            label: 'Send',
          ),
          NavigationDestination(icon: Icon(Icons.history), label: 'History'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
