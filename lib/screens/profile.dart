import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/common/toast.dart';

class ProfileState extends StatefulWidget {
  const ProfileState({super.key});

  @override
  State<ProfileState> createState() => _ProfileState();
}

class _ProfileState extends State<ProfileState> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushNamed(context, "/login");
              showToast(message: "Successfully signed out");
            },
            child: Container(
              height: 45,
              width: 100,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(10)),
              child: const Center(
                child: Text(
                  "Sign out",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
