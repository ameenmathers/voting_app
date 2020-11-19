import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:votingapp/candidate-list.dart';
import 'package:votingapp/cast-vote.dart';

class PresidentPage extends StatefulWidget {
  final String name;
  final String photoUrl;
  final bool hasVoted1;
  final String uid;

  const PresidentPage({
    Key key,
    @required this.name,
    @required this.hasVoted1,
    @required this.uid,
    @required this.photoUrl,
  }) : super(key: key);
  @override
  _PresidentPageState createState() => _PresidentPageState();
}

class _PresidentPageState extends State<PresidentPage> {
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;

  List<DocumentSnapshot> _users;
  final CollectionReference _usersCollectionReference =
      Firestore.instance.collection("candidates");

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    _getUsers();
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
    QuerySnapshot querySnapshot = await _usersCollectionReference
        .where('position', isEqualTo: 'President')
        .getDocuments();

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
        backgroundColor: Color(0xff004343),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CandidateList()),
                          );
                        },
                        child: Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Presidential Candidates",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
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
                      ? Column(
                          children: <Widget>[
                            Center(
                              child: Container(
                                width: 300,
                                child: Text(
                                  'Tap Each Candidate to View their Profile and Vote',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            // ignore: unrelated_type_equality_checks
                            widget.hasVoted1 == true
                                ? Center(
                                    child: Text(
                                      "You have voted for this position already",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                  )
                                : _buildUsersList(),
                          ],
                        )
                      : Column(
                          children: <Widget>[
                            SizedBox(
                              height: 150,
                            ),
                            Center(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                          ],
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
      child: ListView.builder(
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
    return ListTile(
      leading: Container(
        child: userDataMap['photoUrl'] == null
            ? Text('')
            : CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(userDataMap['photoUrl']),
              ),
      ),
      title: Text(userDataMap['name'] == null ? '' : userDataMap['name'],
          style: TextStyle(
            color: Colors.white,
          )),
      subtitle:
          Text(userDataMap['position'] == null ? '' : userDataMap['position'],
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
              )),
      trailing: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Text(
              userDataMap['department'] == null
                  ? ''
                  : userDataMap['department'],
              style: TextStyle(
                color: Colors.white,
              )),
          Text(userDataMap['level'] == null ? '' : userDataMap['level'],
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              )),
        ],
      ),
      onTap: () {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => CastVote(
                      uid: widget.uid,
                      cid: userDataMap['cid'],
                      name: userDataMap['name'],
                      photoUrl: userDataMap['photoUrl'],
                      position: userDataMap['position'],
                      department: userDataMap['department'],
                      level: userDataMap['level'],
                      votes: userDataMap['votes'].toString(),
                      bio: userDataMap['bio'],
                      voters: userDataMap['voters'],
                    )));
      },
    );
  }
}
