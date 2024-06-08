// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:myapp/common/toast.dart';
import 'package:myapp/models/user.dart';

class ProfileState extends StatefulWidget {
  final UserModel user;
  const ProfileState({
    Key? key,
    required this.user,
  }) : super(key: key);

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
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.network(
              widget.user.photo ??
                  'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png',
              width: 250.0,
              height: 200.0,
              fit: BoxFit.fill,
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
          ),
          Text(
            widget.user.username ?? '',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Container(
            margin: EdgeInsets.all(10),
          ),
          Text(
            widget.user.email ?? '',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Container(
            margin: EdgeInsets.all(10),
          ),
          GestureDetector(
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushNamed(context, "/login");
              showToast(message: "Successfully signed out");
            },
            child: Container(
              height: 35,
              width: 80,
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
