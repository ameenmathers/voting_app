import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:votingapp/candidates/president.dart';
import 'package:votingapp/candidates/public-relation.dart';
import 'package:votingapp/candidates/social-director.dart';
import 'package:votingapp/candidates/software-director.dart';
import 'package:votingapp/candidates/sports-director.dart';
import 'package:votingapp/candidates/treasurer.dart';
import 'package:votingapp/candidates/vice-president.dart';
import 'package:votingapp/profile.dart';

class CandidateList extends StatefulWidget {
  final String name;
  final String photoUrl;
  final bool hasVoted1;
  final bool hasVoted2;
  final bool hasVoted3;
  final bool hasVoted4;
  final bool hasVoted5;
  final bool hasVoted6;
  final bool hasVoted7;
  final String uid;

  const CandidateList({
    Key key,
    @required this.name,
    @required this.hasVoted1,
    @required this.hasVoted2,
    @required this.hasVoted3,
    @required this.hasVoted4,
    @required this.hasVoted5,
    @required this.hasVoted6,
    @required this.hasVoted7,
    @required this.uid,
    @required this.photoUrl,
  }) : super(key: key);

  @override
  _CandidateListState createState() => _CandidateListState();
}

class _CandidateListState extends State<CandidateList> {
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  String email;
  bool showSpinner = false;

  Future<DocumentSnapshot> userDocumentSnapshot;

  Future<void> getUserDoc() async {
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;

    var snapshot = Firestore.instance.collection('users').document(uid).get();

    setState(() {
      userDocumentSnapshot = snapshot;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserDoc();
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
                            MaterialPageRoute(builder: (context) => Profile()),
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
                        "Candidate Positions",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                FutureBuilder(
                    future: userDocumentSnapshot,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                'President',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              trailing: Icon(
                                Icons.chevron_right,
                                size: 25,
                                color: Colors.white,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PresidentPage(
                                            uid: widget.uid,
                                            name: widget.name,
                                            hasVoted1:
                                                snapshot.data['hasVoted1'],
                                            photoUrl: widget.photoUrl,
                                          )),
                                );
                              },
                            ),
                            ListTile(
                              title: Text(
                                'Vice President',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              trailing: Icon(
                                Icons.chevron_right,
                                size: 25,
                                color: Colors.white,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => VicePresidentPage(
                                            uid: widget.uid,
                                            name: widget.name,
                                            hasVoted2:
                                                snapshot.data['hasVoted2'],
                                            photoUrl: widget.photoUrl,
                                          )),
                                );
                              },
                            ),
                            ListTile(
                              title: Text(
                                'Public Relations Officer',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              trailing: Icon(
                                Icons.chevron_right,
                                size: 25,
                                color: Colors.white,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PublicRelationtPage(
                                            uid: widget.uid,
                                            name: widget.name,
                                            hasVoted3:
                                                snapshot.data['hasVoted3'],
                                            photoUrl: widget.photoUrl,
                                          )),
                                );
                              },
                            ),
                            ListTile(
                              title: Text(
                                'Treasurer',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              trailing: Icon(
                                Icons.chevron_right,
                                size: 25,
                                color: Colors.white,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TreasurerPage(
                                            uid: widget.uid,
                                            name: widget.name,
                                            hasVoted4:
                                                snapshot.data['hasVoted4'],
                                            photoUrl: widget.photoUrl,
                                          )),
                                );
                              },
                            ),
                            ListTile(
                              title: Text(
                                'Social Director',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              trailing: Icon(
                                Icons.chevron_right,
                                size: 25,
                                color: Colors.white,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SocialDirectorPage(
                                            uid: widget.uid,
                                            name: widget.name,
                                            hasVoted5:
                                                snapshot.data['hasVoted5'],
                                            photoUrl: widget.photoUrl,
                                          )),
                                );
                              },
                            ),
                            ListTile(
                              title: Text(
                                'Software Director',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              trailing: Icon(
                                Icons.chevron_right,
                                size: 25,
                                color: Colors.white,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SoftwareDirectorPage(
                                            uid: widget.uid,
                                            name: widget.name,
                                            hasVoted6:
                                                snapshot.data['hasVoted6'],
                                            photoUrl: widget.photoUrl,
                                          )),
                                );
                              },
                            ),
                            ListTile(
                              title: Text(
                                'Sports Director',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              trailing: Icon(
                                Icons.chevron_right,
                                size: 25,
                                color: Colors.white,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SportsDirectorPage(
                                            uid: widget.uid,
                                            name: widget.name,
                                            hasVoted7:
                                                snapshot.data['hasVoted7'],
                                            photoUrl: widget.photoUrl,
                                          )),
                                );
                              },
                            ),
                          ],
                        );
                      } else {
                        return Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 150.0, 0.0, 0.0),
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        );
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
