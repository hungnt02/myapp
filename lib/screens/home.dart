import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/auth/presentation/pages/login_page.dart';
import 'package:myapp/common/toast.dart';
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
    final user = (ModalRoute.of(context)?.settings.arguments ?? '');

    final ThemeData theme = Theme.of(context);
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
      body: currentPageIndex == 1 ? const ProfileState() : const ListingPage(),
    );
  }
}
