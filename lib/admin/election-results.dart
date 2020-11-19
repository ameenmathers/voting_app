import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:votingapp/admin/admin-drawer.dart';
import 'package:votingapp/admin/view-candidate.dart';

class ElectionResults extends StatefulWidget {
  @override
  _ElectionResultsState createState() => _ElectionResultsState();
}

class _ElectionResultsState extends State<ElectionResults> {
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
    return Scaffold(
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
      drawer: AdminDrawer(),
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
              SizedBox(
                height: 15,
              ),
              Center(
                child: Text(
                  'Tap Candidate to Delete or Edit',
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: _users != null
                    ? SingleChildScrollView(child: _buildUsersList())
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
    );
  }

  Widget _buildUsersList() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 16.0),
      child: GridView.builder(
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            mainAxisSpacing: 20,
            crossAxisSpacing: 10),
        shrinkWrap: true,
        physics: ScrollPhysics(),
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
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewCandidate(
              cid: userDataMap['cid'],
              name: userDataMap['name'],
              position: userDataMap['position'],
              photoUrl: userDataMap['photoUrl'],
            ),
          ),
        );
      },
      child: Container(
        color: Color(0xff004343),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            userDataMap['photoUrl'] == null
                ? Text('')
                : Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.network(
                        userDataMap['photoUrl'],
                        width: 90,
                        height: 90,
                      ),
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
                    fontSize: 15,
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
                      fontSize: 15,
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
                      fontSize: 15,
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
