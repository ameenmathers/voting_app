import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:votingapp/admin/admin-drawer.dart';
import 'package:votingapp/admin/admin.dart';

class ViewCandidate extends StatefulWidget {
  final String name;
  final String position;
  final String cid;
  final String photoUrl;

  const ViewCandidate({
    Key key,
    @required this.name,
    @required this.position,
    @required this.cid,
    @required this.photoUrl,
  }) : super(key: key);
  @override
  _ViewCandidateState createState() => _ViewCandidateState();
}

class _ViewCandidateState extends State<ViewCandidate> {
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;

  TextEditingController controllerName;

  @override
  void initState() {
    super.initState();
    controllerName = new TextEditingController()..text = widget.name;
    position = widget.position;
  }

  final _formKey = GlobalKey<FormState>();

  String photoUrl = '';
  String position;

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
        .collection('candidates')
        .document(widget.cid)
        .updateData({'photoUrl': photoUrl});

    setState(() {
      isLoading = false;
    });

    Fluttertoast.showToast(
        msg: "Picture Saved Succesfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Color(0xffc67608),
        textColor: Colors.white,
        fontSize: 14.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xcc004343),
        title: Text('Edit Candidate'),
        elevation: 0.0,
      ),
      drawer: AdminDrawer(),
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: <Widget>[
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
                                                Row(
                                                  children: <Widget>[
                                                    Container(
                                                      child: CircleAvatar(
                                                        backgroundImage:
                                                            CachedNetworkImageProvider(
                                                          widget.photoUrl,
                                                        ),
                                                        radius: 50.0,
                                                      ),
                                                    ),
                                                  ],
                                                ),
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
                              FractionallySizedBox(
                                widthFactor: 1.1,
                                child: Container(
                                  height: 70,
                                  padding:
                                      EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                                  child: Theme(
                                    data: Theme.of(context).copyWith(
                                      canvasColor: Color(0xffF2F2F2),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child:
                                          new DropdownButtonFormField<String>(
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
                                        var batch = Firestore.instance.batch();

                                        batch.updateData(
                                            Firestore.instance
                                                .collection('candidates')
                                                .document(widget.cid),
                                            {
                                              'name': controllerName.text,
                                            });
                                        batch.updateData(
                                            Firestore.instance
                                                .collection('candidates')
                                                .document(widget.cid),
                                            {
                                              'name': controllerName.text,
                                              'position': position,
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

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Admin()),
                                        );
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
                      SizedBox(
                        height: 60,
                      ),
                      Center(
                        child: Text(
                          'Please be sure you want to delete candidate before proceeding',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xff004343),
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 200,
                        height: 50,
                        child: RaisedButton(
                          color: Colors.redAccent,
                          highlightElevation: 8.0,
                          elevation: 2.0,
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });

                            try {
                              Firestore.instance
                                  .collection('candidates')
                                  .document(widget.cid)
                                  .delete();

                              setState(() {
                                isLoading = false;
                              });

                              Fluttertoast.showToast(
                                  msg: "Candidate Deleted",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Color(0xffc67608),
                                  textColor: Colors.white,
                                  fontSize: 14.0);

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Admin()),
                              );
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
                          },
                          child: Text(
                            'Delete Candidate',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
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
