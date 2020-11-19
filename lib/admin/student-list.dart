import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:votingapp/admin/admin-drawer.dart';

class StudentsList extends StatefulWidget {
  @override
  _StudentsListState createState() => _StudentsListState();
}

class _StudentsListState extends State<StudentsList> {
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;

  List<DocumentSnapshot> _users;
  final CollectionReference _usersCollectionReference =
      Firestore.instance.collection("users");

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
          "Students",
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
      backgroundColor: Color(0xff004343),
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
      subtitle: Text(userDataMap['course'] == null ? '' : userDataMap['course'],
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
          )),
      trailing: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Text(userDataMap['matric_no'] == null ? '' : userDataMap['matric_no'],
              style: TextStyle(
                color: Colors.white,
              )),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
