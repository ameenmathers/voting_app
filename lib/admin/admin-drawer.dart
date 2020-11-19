import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:votingapp/admin/admin.dart';
import 'package:votingapp/admin/election-results.dart';
import 'package:votingapp/admin/student-list.dart';
import 'package:votingapp/login.dart';

class AdminDrawer extends StatelessWidget {
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: Container(
        color: Color(0xff004343),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            ListTile(
              leading: Text(
                'Admin Dashboard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Admin()),
                );
              },
            ),
            ListTile(
              leading: Text(
                'View Students',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StudentsList()),
                );
              },
            ),
            ListTile(
              leading: Text(
                'View Election Results',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ElectionResults()),
                );
              },
            ),
            ListTile(
              leading: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
              onTap: () {
                _auth.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
