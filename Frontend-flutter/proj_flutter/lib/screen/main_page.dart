import 'package:flutter/material.dart';
import 'package:proj_flutter/screen/home.dart';
import 'package:proj_flutter/screen/profile.dart';
import 'package:proj_flutter/screen/settings.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Widget> pages = [
    const Profile(),
    const Home(),
    const Settings(),
  ];
  int pageIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Settings"),
        ],
        currentIndex: pageIndex,
        onTap: changePage,
      ),
      body: pages[pageIndex],
    );
  }

  void changePage(value) {
    setState(() {
      pageIndex = value;
    });
  }
}
