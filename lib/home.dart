import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:votingapp/admin/admin.dart';
import 'package:votingapp/profile.dart';

class Home extends StatefulWidget {
  final bool wantsTouchId;
  final String email;
  final String password;

  Home({
    this.wantsTouchId,
    this.email,
    this.password,
  });

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      setState(() {
        loggedInUser = user;
      });

      print(loggedInUser.uid);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loggedInUser == null
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xcc004343)),
              ),
            )
          : StreamBuilder<DocumentSnapshot>(
              stream: Firestore.instance
                  .collection('users')
                  .document(loggedInUser.uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xcc004343)),
                      ),
                    );
                  default:
                    return checkRole(snapshot.data);
                }
              },
            ),
    );
  }

  checkRole(DocumentSnapshot snapshot) {
    if (snapshot.data['role'] == 'admin') {
      return Admin();
    } else {
      return Profile();
    }
  }
}
