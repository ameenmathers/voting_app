import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:votingapp/admin/admin-drawer.dart';

class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  bool showSpinner = false;
  String _error;
  String photoUrl = '';
  String photo = '';
  bool isLoading = false;
  File avatarImageFile;
  String position;
  Future<DocumentSnapshot> userDocumentSnapshot;

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

  final GlobalKey<FormState> _addCandidateFormKey = GlobalKey<FormState>();
  TextEditingController nameInputController;
  TextEditingController bioInputController;
  TextEditingController departmentInputController;
  TextEditingController levelInputController;

  @override
  void initState() {
    nameInputController = new TextEditingController();
    bioInputController = new TextEditingController();
    departmentInputController = new TextEditingController();
    levelInputController = new TextEditingController();
    super.initState();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Admin Dashboard",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xff004343),
        elevation: 0.0,
      ),
      drawer: AdminDrawer(),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Form(
              key: _addCandidateFormKey,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      showAlert(),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Create a Candidate",
                        style: TextStyle(
                          color: Color(0xff004343),
                          fontSize: 25,
                        ),
                      ),
                      SizedBox(
                        height: 40,
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
                                          : Container(
                                              width: 100.0,
                                              height: 100.0,
                                              decoration: BoxDecoration(
                                                color: Color(0xff004343),
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(45),
                                                    topRight:
                                                        Radius.circular(45),
                                                    bottomLeft:
                                                        Radius.circular(45),
                                                    bottomRight:
                                                        Radius.circular(45)),
                                              ),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          showAlert(),
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                              child: Container(
                                width: 300,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter Name';
                                    }
                                    return null;
                                  },
                                  controller: nameInputController,
                                  decoration: InputDecoration(
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xffc67608))),
                                    filled: true,
                                    hintText: "Candidate Name",
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                    ),
                                    fillColor: Colors.white,
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                    focusColor: Colors.black,
                                  ),
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          FractionallySizedBox(
                            widthFactor: 0.95,
                            child: Container(
                              height: 50,
                              padding: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  canvasColor: Color(0xffF2F2F2),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: new DropdownButtonFormField<String>(
                                    value: position,
                                    validator: (String newValue) {
                                      if (newValue == null) {
                                        return 'Please enter position';
                                      }
                                      return null;
                                    },
                                    hint: Text(
                                      'Select',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        position = newValue;
                                      });
                                    },
                                    items: <String>[
                                      'President',
                                      'Vice President',
                                      'Public Relations Officer',
                                      'Treasurer',
                                      'Social Director',
                                      'Software Director',
                                      'Sports Director',
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return new DropdownMenuItem<String>(
                                        value: value,
                                        child: new Text(
                                          value,
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                              child: Container(
                                width: 300,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter level';
                                    }
                                    return null;
                                  },
                                  controller: levelInputController,
                                  decoration: InputDecoration(
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xffc67608))),
                                    filled: true,
                                    hintText: "Level eg. 300, 400",
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                    ),
                                    fillColor: Colors.white,
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                    focusColor: Colors.black,
                                  ),
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                              child: Container(
                                width: 300,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter Department';
                                    }
                                    return null;
                                  },
                                  controller: departmentInputController,
                                  decoration: InputDecoration(
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xffc67608))),
                                    filled: true,
                                    hintText: "Department",
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                    ),
                                    fillColor: Colors.white,
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                    focusColor: Colors.black,
                                  ),
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                              child: Container(
                                width: 300,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter Bio';
                                    }
                                    return null;
                                  },
                                  maxLines: 3,
                                  controller: bioInputController,
                                  decoration: InputDecoration(
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xffc67608))),
                                    filled: true,
                                    hintText: "Candidate Bio",
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                    ),
                                    fillColor: Colors.white,
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                    focusColor: Colors.black,
                                  ),
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 45,
                          ),
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                              child: ButtonTheme(
                                minWidth: 300.0,
                                height: 60.0,
                                child: RaisedButton(
                                  color: Color(0xff004343),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: Color(0xff004343),
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(0.0),
                                    ),
                                  ),
                                  child: Text("Submit"),
                                  textColor: Colors.white,
                                  onPressed: () async {
                                    if (_addCandidateFormKey.currentState
                                        .validate()) {
                                      setState(() {
                                        showSpinner = true;
                                      });

                                      DateTime now = DateTime.now();
                                      String formattedDate =
                                          DateFormat('EEE d MMM').format(now);

                                      String fileName1 = formattedDate;
                                      StorageReference reference =
                                          FirebaseStorage.instance
                                              .ref()
                                              .child(fileName1);
                                      StorageUploadTask uploadTask =
                                          reference.putFile(avatarImageFile);
                                      StorageTaskSnapshot storageTaskSnapshot;

                                      storageTaskSnapshot =
                                          await uploadTask.onComplete;
                                      photoUrl = await storageTaskSnapshot.ref
                                          .getDownloadURL();

                                      try {
                                        DocumentReference document =
                                            await Firestore.instance
                                                .collection('candidates')
                                                .add({});

                                        String documentId = document.documentID;

                                        Firestore.instance
                                            .collection('candidates')
                                            .document('$documentId')
                                            .setData({
                                          "votes": "0",
                                          "voters": FieldValue.arrayUnion([]),
                                          "cid": '$documentId',
                                          "name": nameInputController.text,
                                          "bio": bioInputController.text,
                                          "level": levelInputController.text,
                                          "department":
                                              departmentInputController.text,
                                          "position": position,
                                          "photoUrl": photoUrl,
                                        });

                                        setState(() {
                                          showSpinner = false;
                                        });

                                        Fluttertoast.showToast(
                                            msg: "Candidate Added",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Color(0xff004343),
                                            textColor: Colors.white,
                                            fontSize: 14.0);
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

                                        Navigator.pop(context);
                                      }
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
