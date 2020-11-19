import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResultsPage extends StatefulWidget {
  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;

  List<DocumentSnapshot> _users;
  final CollectionReference _usersCollectionReference =
      Firestore.instance.collection("candidates");

  @override
  void initState() {
    super.initState();
    _getUsers();
    getCurrentUser();
    searchController.addListener(() {
      setState(() {
        filter = searchController.text;
      });
    });
  }

  TextEditingController searchController = new TextEditingController();
  String filter;

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List<DocumentSnapshot>> getUsersList() async {
    QuerySnapshot querySnapshot =
        await _usersCollectionReference.getDocuments();

    return querySnapshot.documents;
  }

  Future<void> _getUsers() async {
    List<DocumentSnapshot> usersList = await getUsersList().then((v) {
      print(v);
      return Future.value(v);
    });

    setState(() {
      _users = usersList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Election Results",
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
            ),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Color(0xff004343),
          elevation: 0.0,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 350,
                  height: 50,
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Search",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: _users != null
                      ? _buildUsersList()
                      : Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUsersList() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 16.0),
      child: GridView.builder(
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.6,
          crossAxisSpacing: 10,
          mainAxisSpacing: 20,
        ),
        shrinkWrap: true,
        itemCount: _users.length,
        itemBuilder: ((context, index) {
          return filter == null || filter == ""
              ? _buildUserListTile(
                  userDataMap: _users[index].data, context: context)
              : _users[index]
                      .data['name']
                      .toLowerCase()
                      .contains(filter.toLowerCase())
                  ? _buildUserListTile(
                      userDataMap: _users[index].data, context: context)
                  : SizedBox.shrink();
        }),
      ),
    );
  }

  Widget _buildUserListTile(
      {@required Map userDataMap, @required BuildContext context}) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xff004343),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            userDataMap['photoUrl'] == null
                ? Text('')
                : Center(
                    child: Image.network(
                      userDataMap['photoUrl'],
                      width: 144,
                      height: 144,
                    ),
                  ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
              child: Text(
                userDataMap['name'] == null
                    ? ''
                    : userDataMap['name'].toUpperCase(),
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Position:',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    userDataMap['position'] == null
                        ? ''
                        : userDataMap['position'],
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
              child: Row(
                children: <Widget>[
                  Text(
                    'Votes:',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    userDataMap['votes'] == null
                        ? '0'
                        : userDataMap['votes'].toString(),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
