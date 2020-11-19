import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  final String name;
  final String phone;

  const EditProfile({
    Key key,
    @required this.name,
    @required this.phone,
  }) : super(key: key);
  @override
  State createState() => EditProfileState();
}

class EditProfileState extends State<EditProfile> {
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;

  TextEditingController controllerName;
  TextEditingController controllerPhone;

  @override
  void initState() {
    super.initState();
    controllerName = new TextEditingController()..text = widget.name;
    controllerPhone = TextEditingController()..text = widget.phone;
    getCurrentUser();
  }

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

  final _formKey = GlobalKey<FormState>();

  String photoUrl = '';

  bool isLoading = false;
  File avatarImageFile;

  Future getImage() async {
    // ignore: deprecated_member_use
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        avatarImageFile = image;
        print('Image path $avatarImageFile');
      });
    }
  }

  Future uploadFile() async {
    setState(() {
      isLoading = true;
    });

    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;
    String fileName1 = uid;
    StorageReference reference =
        FirebaseStorage.instance.ref().child(fileName1);
    StorageUploadTask uploadTask = reference.putFile(avatarImageFile);
    StorageTaskSnapshot storageTaskSnapshot;

    storageTaskSnapshot = await uploadTask.onComplete;
    photoUrl = await storageTaskSnapshot.ref.getDownloadURL();

    await Firestore.instance
        .collection('users')
        .document(uid)
        .updateData({'photoUrl': photoUrl});

    setState(() {
      isLoading = false;
    });

    Fluttertoast.showToast(
        msg: "Picture Saved Succesfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Color(0xffc67608),
        textColor: Colors.white,
        fontSize: 14.0);
  }

  Future<DocumentSnapshot> getUserDoc({bool useCache = true}) async {
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;

    print('Loading Profile');

    var sameUser = await Firestore.instance
        .collection('users')
        .document(uid)
        .get()
        .then((DocumentSnapshot snapshot) => snapshot);

    return sameUser;
    //await needs to be placed here
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.chevron_left,
                                size: 40,
                                color: Color(0xcc004343),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditProfile()),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  (avatarImageFile == null)
                                      ? (photoUrl != ''
                                          ? Material(
                                              child: CachedNetworkImage(
                                                placeholder: (context, url) =>
                                                    Container(
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2.0,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                                Color>(
                                                            Color(0xff004343)),
                                                  ),
                                                  width: 90.0,
                                                  height: 90.0,
                                                  padding: EdgeInsets.all(20.0),
                                                ),
                                                imageUrl: photoUrl,
                                                width: 100.0,
                                                height: 90.0,
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(45.0)),
                                              clipBehavior: Clip.hardEdge,
                                            )
                                          : Stack(
                                              children: <Widget>[
                                                FutureBuilder<DocumentSnapshot>(
                                                    future: getUserDoc(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        return Row(
                                                          children: <Widget>[
                                                            Container(
                                                              child:
                                                                  CircleAvatar(
                                                                backgroundImage:
                                                                    CachedNetworkImageProvider(
                                                                  snapshot.data[
                                                                      'photoUrl'],
                                                                ),
                                                                radius: 50.0,
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      } else {
                                                        return Container(
                                                          child: Center(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      30.0,
                                                                      20.0,
                                                                      0.0,
                                                                      0.0),
                                                              child:
                                                                  CircularProgressIndicator(
                                                                valueColor:
                                                                    AlwaysStoppedAnimation<
                                                                            Color>(
                                                                        Color(
                                                                            0xff004343)),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    }),
                                              ],
                                            ))
                                      : Material(
                                          child: Image.file(
                                            avatarImageFile,
                                            width: 100.0,
                                            height: 100.0,
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(45.0)),
                                          clipBehavior: Clip.hardEdge,
                                        ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    65.0, 65.0, 0.0, 0.0),
                                child: IconButton(
                                    icon: Icon(
                                      Icons.add_box,
                                      color: Color(0xff004343),
                                      size: 30,
                                    ),
                                    onPressed: getImage),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RaisedButton(
                              color: Color(0xffF8F9D3),
                              onPressed: uploadFile,
                              highlightElevation: 8.0,
                              splashColor: Colors.white,
                              highlightColor: Colors.amber,
                              elevation: 2.0,
                              child: Text(
                                'Save Image',
                                style: TextStyle(
                                  color: Color(0xff004343),
                                  fontSize: 14,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 50,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.person),
                                    border: UnderlineInputBorder(),
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: "Name",
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                    ),
                                    focusColor: Colors.white,
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                  ),
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  controller: controllerName,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter Name';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                height: 50,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.phone_android),
                                    border: UnderlineInputBorder(),
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: "Phone Number",
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                    ),
                                    focusColor: Colors.white,
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                  ),
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  controller: controllerPhone,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter Name';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              Container(
                                width: 200,
                                height: 50,
                                child: RaisedButton(
                                  color: Color(0xffF8F9D3),
                                  highlightElevation: 8.0,
                                  splashColor: Colors.white,
                                  highlightColor: Colors.amber,
                                  elevation: 2.0,
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      setState(() {
                                        isLoading = true;
                                      });

                                      try {
                                        final FirebaseUser user =
                                            await _auth.currentUser();
                                        final uid = user.uid;

                                        var batch = Firestore.instance.batch();

                                        batch.updateData(
                                            Firestore.instance
                                                .collection('users')
                                                .document(uid),
                                            {
                                              'name': controllerName.text,
                                            });
                                        batch.updateData(
                                            Firestore.instance
                                                .collection('users')
                                                .document(uid),
                                            {
                                              'name': controllerName.text,
                                            });

                                        await batch.commit();

                                        setState(() {
                                          isLoading = false;
                                        });

                                        Fluttertoast.showToast(
                                            msg: "Profile Saved Succesfully",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.TOP,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Color(0xff004343),
                                            textColor: Colors.white,
                                            fontSize: 14.0);

                                        Navigator.pop(context);
                                      } catch (e) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        Fluttertoast.showToast(
                                            msg: "Something went wrong",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.TOP,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Color(0xff004343),
                                            textColor: Colors.white,
                                            fontSize: 14.0);

                                        Navigator.pop(context);
                                      }
                                    }
                                  },
                                  child: Text(
                                    'Save Changes',
                                    style: TextStyle(
                                      color: Color(0xff004343),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              isLoading
                  ? Positioned(
                      top: 0.0,
                      left: 0.0,
                      bottom: 0.0,
                      right: 0.0,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xff004343)),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
