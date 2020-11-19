import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:votingapp/candidate-list.dart';
import 'package:votingapp/main.dart';

class CastVote extends StatefulWidget {
  String name;
  String level;
  String position;
  String bio;
  String votes;
  String department;
  final List voters;
  String photoUrl;
  String uid;
  String cid;

  CastVote({
    this.name,
    this.level,
    this.photoUrl,
    this.uid,
    this.cid,
    this.bio,
    this.votes,
    this.position,
    this.voters,
    this.department,
  });

  @override
  _CastVoteState createState() => _CastVoteState();
}

class _CastVoteState extends State<CastVote> {
  Widget showAlert() {
    if (_error != null) {
      return Container(
        color: Color(0xcc004343),
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.error_outline,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: AutoSizeText(
                _error,
                maxLines: 3,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _error = null;
                  });
                },
              ),
            )
          ],
        ),
      );
    }
    return SizedBox(
      height: 0,
    );
  }

  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  bool showSpinner = false;
  String _error;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        backgroundColor: Color(0xff004343),
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: SingleChildScrollView(
            child: SafeArea(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
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
                            width: 50,
                          ),
                          Text(
                            "Voting Page",
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
                    Image.network(
                      widget.photoUrl,
                      width: 200,
                      height: 190,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.name,
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40.0, 0.0, 0.0, 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Department:',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            widget.department,
                            style: TextStyle(fontSize: 17, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40.0, 0.0, 0.0, 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Position:',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            widget.position,
                            style: TextStyle(fontSize: 17, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40.0, 0.0, 0.0, 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Level:',
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            widget.level,
                            style: TextStyle(fontSize: 17, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40.0, 0.0, 0.0, 0.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Votes:',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            widget.votes == null
                                ? '0'
                                : widget.votes.toString(),
                            style: TextStyle(fontSize: 17, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    (widget.voters.contains(widget.uid))
                        ? Text(
                            "You have voted",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          )
                        : Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                              child: ButtonTheme(
                                minWidth: 200.0,
                                height: 60.0,
                                child: RaisedButton(
                                  color: Color(0xffF8F9D3),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: Color(0xffF8F9D3),
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(0.0),
                                    ),
                                  ),
                                  child: Text(
                                    "Vote",
                                    style: TextStyle(
                                      fontSize: 17,
                                    ),
                                  ),
                                  textColor: Color(0xcc004343),
                                  onPressed: () async {
                                    setState(() {
                                      showSpinner = true;
                                    });

                                    try {
                                      if (widget.position ==
                                          'Sports Director') {
                                        final FirebaseUser user =
                                            await _auth.currentUser();
                                        final uid = user.uid;

                                        Firestore.instance
                                            .collection('candidates')
                                            .document(widget.cid)
                                            .updateData({
                                          "votes": FieldValue.increment(1),
                                          "voters":
                                              FieldValue.arrayUnion([uid]),
                                        });

                                        Firestore.instance
                                            .collection('users')
                                            .document(uid)
                                            .updateData({
                                          "hasVoted7": true,
                                        });

                                        setState(() {
                                          showSpinner = false;
                                        });

                                        _auth.signOut();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MyHomePage()),
                                        );

                                        Fluttertoast.showToast(
                                            msg: "Voting Completed",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Color(0xff004343),
                                            textColor: Colors.white,
                                            fontSize: 14.0);
                                      } else {
                                        final FirebaseUser user =
                                            await _auth.currentUser();
                                        final uid = user.uid;

                                        Firestore.instance
                                            .collection('candidates')
                                            .document(widget.cid)
                                            .updateData({
                                          "votes": FieldValue.increment(1),
                                          "voters":
                                              FieldValue.arrayUnion([uid]),
                                        });

                                        if (widget.position == 'President') {
                                          Firestore.instance
                                              .collection('users')
                                              .document(uid)
                                              .updateData({
                                            "hasVoted1": true,
                                          });
                                        } else if (widget.position ==
                                            'Vice President') {
                                          Firestore.instance
                                              .collection('users')
                                              .document(uid)
                                              .updateData({
                                            "hasVoted2": true,
                                          });
                                        } else if (widget.position ==
                                            'Public Relations Officer') {
                                          Firestore.instance
                                              .collection('users')
                                              .document(uid)
                                              .updateData({
                                            "hasVoted3": true,
                                          });
                                        } else if (widget.position ==
                                            'Treasurer') {
                                          Firestore.instance
                                              .collection('users')
                                              .document(uid)
                                              .updateData({
                                            "hasVoted4": true,
                                          });
                                        } else if (widget.position ==
                                            'Social Director') {
                                          Firestore.instance
                                              .collection('users')
                                              .document(uid)
                                              .updateData({
                                            "hasVoted5": true,
                                          });
                                        } else if (widget.position ==
                                            'Software Director') {
                                          Firestore.instance
                                              .collection('users')
                                              .document(uid)
                                              .updateData({
                                            "hasVoted6": true,
                                          });
                                        } else if (widget.position ==
                                            'Sports Director') {
                                          Firestore.instance
                                              .collection('users')
                                              .document(uid)
                                              .updateData({
                                            "hasVoted7": true,
                                          });
                                        }

                                        setState(() {
                                          showSpinner = false;
                                        });

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CandidateList(),
                                          ),
                                        );

                                        Fluttertoast.showToast(
                                            msg: "Vote Casted",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Color(0xff004343),
                                            textColor: Colors.white,
                                            fontSize: 14.0);
                                      }
                                    } catch (e) {
                                      setState(() {
                                        showSpinner = false;
                                      });
                                      Fluttertoast.showToast(
                                          msg: "Something went wrong",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.TOP,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.redAccent,
                                          textColor: Colors.white,
                                          fontSize: 14.0);
                                    }
                                  },
                                ),
                              ),
                            ),
                          )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
