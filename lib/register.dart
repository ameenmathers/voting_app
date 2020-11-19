import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:votingapp/login.dart';
import 'package:votingapp/main.dart';

class Register extends StatefulWidget {
  Register({Key key}) : super(key: key);
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseUser currentUser;
  String classCourse;
  String _error;
  bool showSpinner = false;
  bool _useTouchId = false;

  final storage = new FlutterSecureStorage();
  final auth = LocalAuthentication();

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

  final _photo =
      'https://firebasestorage.googleapis.com/v0/b/attendance-app-7f610.appspot.com/o/pic.png?alt=media&token=110d6516-c32b-441b-8f80-3a6405f7d892';

  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  TextEditingController nameInputController;
  TextEditingController phoneInputController;
  TextEditingController emailInputController;
  TextEditingController matricNoInputController;
  TextEditingController pwdInputController;
  TextEditingController confirmPwdInputController;

  @override
  void initState() {
    nameInputController = new TextEditingController();
    phoneInputController = new TextEditingController();
    emailInputController = new TextEditingController();
    matricNoInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    confirmPwdInputController = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: SafeArea(
            child: SingleChildScrollView(
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
                                  builder: (context) => MyHomePage()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Form(
                    key: _registerFormKey,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(35.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            showAlert(),
                            Text(
                              "Register",
                              style: TextStyle(
                                color: Color(0xcc004343),
                                fontSize: 35,
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 0.0, 0.0, 0.0),
                                child: Container(
                                  width: 300,
                                  child: TextFormField(
                                    controller: nameInputController,
                                    validator: (value) {
                                      if (value.length < 3) {
                                        return "Please enter a valid name.";
                                      }
                                    },
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.person),
                                      border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xffc67608))),
                                      filled: true,
                                      hintText: "Full Name",
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                      ),
                                      fillColor: Colors.white,
                                      labelStyle: TextStyle(
                                        color: Colors.black,
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
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 0.0, 0.0, 0.0),
                                child: Container(
                                  width: 300,
                                  child: TextFormField(
                                    controller: emailInputController,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter email';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.email),
                                      border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xffc67608))),
                                      filled: true,
                                      hintText: "Email",
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
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 0.0, 0.0, 0.0),
                                child: Container(
                                  width: 300,
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter Phone Number';
                                      }
                                      return null;
                                    },
                                    controller: phoneInputController,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.phone_android),
                                      border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xffc67608))),
                                      filled: true,
                                      hintText: "Phone Number",
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
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 0.0, 0.0, 0.0),
                                child: Container(
                                  width: 300,
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter Matriculation Number';
                                      }
                                      return null;
                                    },
                                    controller: matricNoInputController,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.school),
                                      border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xffc67608))),
                                      filled: true,
                                      hintText: "Matriculation Number",
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
                              height: 30,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  20.0, 0.0, 0.0, 0.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'College and Departments',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 17,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            FractionallySizedBox(
                              widthFactor: 1.2,
                              child: Container(
                                height: 50,
                                padding:
                                    EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    canvasColor: Colors.white,
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: new DropdownButtonFormField<String>(
                                      value: classCourse,
                                      validator: (String newValue) {
                                        if (newValue == null) {
                                          return 'Please enter College and course';
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
                                          classCourse = newValue;
                                        });
                                      },
                                      items: <String>[
                                        'COLNAS: B.Sc. Microbiology',
                                        'COLNAS: B.Sc. B.Tech.Biotechnology',
                                        'COLNAS: B.Sc. Biochemistry',
                                        'COLNAS: B.Sc. Chemistry',
                                        'COLNAS: B.Tech. Food Science & Technology',
                                        'COLNAS: B.Sc. Nutrition and Dietetics',
                                        'COLNAS: B.Sc. Physics',
                                        'COLNAS: B.Sc. Applied Mathematics with Statistics',
                                        'COLNAS: B.Tech. Computer Science',
                                        'COLNAS: B.Tech. Information Technology',
                                        'COLMANS: B.Sc. Accounting',
                                        'COLMANS: B.Sc. Economics',
                                        'COLMANS: B.Sc. Finance and Banking ',
                                        'COLMANS: B.Sc. Business Administration',
                                        'COLMANS: B.Sc. Management Technology',
                                        'COLENG: B.Eng. Biomedical Engineering',
                                        'COLENG: B.Eng. Mechanical Engineering',
                                        'COLENG: B.Eng. Mechatronics Engineering',
                                        'COLENG: B.Eng. Electrical/Electronics Engineering',
                                        'COLENG: B.Eng. Computer Engineering',
                                        'COLENG: B.Eng. Telecommunication Engineering',
                                        'COLENVS: B.Sc. Architecture',
                                        'COLENVS: B.Tech. Surveying and Geoinformatics',
                                        'COLENVS: B.Tech. Building Technology',
                                        'COLENVS: B.Tech. Quantity Surveying',
                                        'COLENVS: B.Tech. Urban and Regional Planning',
                                        'COLENVS: B.Tech. Estate Management',
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
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 0.0, 0.0, 0.0),
                                child: Container(
                                  width: 300,
                                  child: TextFormField(
                                    obscureText: true,
                                    controller: pwdInputController,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter password';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.lock),
                                      border: UnderlineInputBorder(),
                                      hintText: "Password",
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      labelStyle: TextStyle(
                                        color: Colors.white,
                                      ),
                                      focusColor: Colors.white,
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey)),
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
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 0.0, 0.0, 0.0),
                                child: Container(
                                  width: 300,
                                  child: TextFormField(
                                    obscureText: true,
                                    controller: confirmPwdInputController,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter password';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.lock),
                                      border: UnderlineInputBorder(),
                                      hintText: "Confirm Password",
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      labelStyle: TextStyle(
                                        color: Colors.white,
                                      ),
                                      focusColor: Colors.white,
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey)),
                                    ),
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Checkbox(
                                    activeColor: Colors.blue,
                                    value: _useTouchId,
                                    onChanged: (newValue) {
                                      setState(() {
                                        _useTouchId = newValue;
                                      });
                                    }),
                                Text(
                                  "Register your TouchID",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xcc004343),
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 0.0, 0.0, 0.0),
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
                                    child: Text("Sign Up"),
                                    textColor: Colors.white,
                                    onPressed: () async {
                                      try {
                                        if (_registerFormKey.currentState
                                            .validate()) {
                                          if (!_useTouchId) {
                                            // The checkbox wasn't checked
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Please register your TouchID",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.CENTER,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor:
                                                    Color(0xcc004343),
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                          } else {
                                            if (pwdInputController.text ==
                                                confirmPwdInputController
                                                    .text) {
                                              final canCheck =
                                                  await auth.canCheckBiometrics;

                                              if (canCheck) {
                                                List<BiometricType>
                                                    availableBiometrics =
                                                    await auth
                                                        .getAvailableBiometrics();
                                                if (Platform.isIOS) {
                                                  if (availableBiometrics
                                                      .contains(
                                                          BiometricType.face)) {
                                                    final authenticated = await auth
                                                        .authenticateWithBiometrics(
                                                            localizedReason:
                                                                'Authenticate to sign in for next time');

                                                    if (authenticated) {
                                                      storage.write(
                                                          key: 'email',
                                                          value:
                                                              emailInputController
                                                                  .text
                                                                  .trim());
                                                      storage.write(
                                                          key: 'password',
                                                          value:
                                                              pwdInputController
                                                                  .text
                                                                  .trim());
                                                      storage.write(
                                                          key: 'usingBiometric',
                                                          value: 'true');
                                                    }
                                                    // Face ID.
                                                  } else if (availableBiometrics
                                                      .contains(BiometricType
                                                          .fingerprint)) {
                                                    // Touch ID.
                                                    auth.authenticateWithBiometrics(
                                                        localizedReason:
                                                            'Authenticate to sign in for next time');
                                                  }
                                                } else {
                                                  try {
                                                    final authenticated = await auth
                                                        .authenticateWithBiometrics(
                                                      localizedReason:
                                                          'Authenticate to sign in for next time',
                                                      stickyAuth: true,
                                                      useErrorDialogs: true,
                                                    );

                                                    if (authenticated) {
                                                      storage.write(
                                                          key: 'email',
                                                          value:
                                                              emailInputController
                                                                  .text
                                                                  .trim());
                                                      storage.write(
                                                          key: 'password',
                                                          value:
                                                              pwdInputController
                                                                  .text
                                                                  .trim());
                                                      storage.write(
                                                          key: 'usingBiometric',
                                                          value: 'true');
                                                    }
                                                  } on PlatformException catch (e) {
                                                    print(e);
                                                    if (e.code ==
                                                        auth_error
                                                            .notAvailable) {
                                                      setState(() {
                                                        showSpinner = false;
                                                        _error = e.message;
                                                      });
                                                    }
                                                  }
                                                }
                                              } else {
                                                print('cant check');
                                              }

                                              FirebaseAuth.instance
                                                  .createUserWithEmailAndPassword(
                                                      email:
                                                          emailInputController
                                                              .text
                                                              .trim(),
                                                      password:
                                                          pwdInputController
                                                              .text)
                                                  .then((currentUser) =>
                                                      Firestore.instance
                                                          .collection("users")
                                                          .document(currentUser
                                                              .user.uid)
                                                          .setData({
                                                            "uid": currentUser
                                                                .user.uid,
                                                            "name":
                                                                nameInputController
                                                                    .text,
                                                            "course":
                                                                classCourse,
                                                            "matric_no":
                                                                matricNoInputController
                                                                    .text,
                                                            "email":
                                                                emailInputController
                                                                    .text
                                                                    .trim(),
                                                            "phone":
                                                                phoneInputController
                                                                    .text,
                                                            "photoUrl": _photo,
                                                            "role": 'student',
                                                            "hasVoted1": false,
                                                            "hasVoted2": false,
                                                            "hasVoted3": false,
                                                            "hasVoted4": false,
                                                            "hasVoted5": false,
                                                            "hasVoted6": false,
                                                            "hasVoted7": false,
                                                          })
                                                          .then((result) => {
                                                                Fluttertoast.showToast(
                                                                    msg:
                                                                        "Sign up was successful",
                                                                    toastLength:
                                                                        Toast
                                                                            .LENGTH_SHORT,
                                                                    gravity:
                                                                        ToastGravity
                                                                            .TOP,
                                                                    timeInSecForIosWeb:
                                                                        1,
                                                                    backgroundColor:
                                                                        Color(
                                                                            0xcc004343),
                                                                    textColor:
                                                                        Colors
                                                                            .white,
                                                                    fontSize:
                                                                        14.0),
                                                                Navigator.pushAndRemoveUntil(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                Login()),
                                                                    (_) =>
                                                                        false),
                                                                nameInputController
                                                                    .clear(),
                                                                emailInputController
                                                                    .clear(),
                                                                pwdInputController
                                                                    .clear(),
                                                                confirmPwdInputController
                                                                    .clear()
                                                              })
                                                          .catchError((err) =>
                                                              print(err)))
                                                  .catchError(
                                                      (err) => print(err));
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text("Error"),
                                                      content: Text(
                                                          "The passwords do not match"),
                                                      actions: <Widget>[
                                                        FlatButton(
                                                          child: Text("Close"),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        )
                                                      ],
                                                    );
                                                  });
                                            }
                                          }
                                        }
                                      } catch (e) {
                                        print(e);

                                        setState(() {
                                          _error = e.message;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Already have an account?",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Login()),
                                    );
                                  },
                                  child: Text(
                                    "Log In",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xcc004343),
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
