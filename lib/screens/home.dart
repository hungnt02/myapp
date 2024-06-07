import 'package:flutter/material.dart';
import 'package:myapp/auth/presentation/pages/login_page.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/screens/listing_page.dart';
import 'package:myapp/screens/profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final data = (ModalRoute.of(context)?.settings.arguments);
    if (data == null) {
      return LoginPage();
    }
    final user = data as UserModel;
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Color.fromARGB(255, 233, 179, 135),
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.person)),
            label: 'Profile',
          ),
        ],
      ),
      body: currentPageIndex == 1
          ? const ProfileState()
          : ListingPage(
              data: UserModel(
                  username: user.username,
                  email: user.email,
                  photo: user.photo),
            ),
    );
  }
}
