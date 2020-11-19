import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:votingapp/home.dart';
import 'package:votingapp/main.dart';
import 'package:votingapp/register.dart';
import 'package:votingapp/reset-password.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  String pass;
  String _error;
  bool showSpinner = false;
  bool userHasTouchId;
  Timer timer;

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

  @override
  void initState() {
    super.initState();
    getSecureStorage();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void getSecureStorage() async {
    final isUsingBio = await storage.read(key: 'usingBiometric');
    setState(() {
      userHasTouchId = isUsingBio == 'true';
    });
  }

//  void _read() async {
//    final userStoredEmail = await storage.read(key: 'email');
//    final userStoredPassword = await storage.read(key: 'password');
//
//    emailInputController.text = userStoredEmail;
//    pwdInputController.text = userStoredPassword;
//  }

  void authenticate() async {
    setState(() {
      showSpinner = false;
    });

    final canCheck = await auth.canCheckBiometrics;

    if (canCheck) {
      List<BiometricType> availableBiometrics =
          await auth.getAvailableBiometrics();
      if (Platform.isIOS) {
        if (availableBiometrics.contains(BiometricType.face)) {
          final authenticated = await auth.authenticateWithBiometrics(
            localizedReason: 'Authenticate to sign in for next time',
            useErrorDialogs: false,
            stickyAuth: true,
          );

          if (authenticated) {
            final userStoredEmail = await storage.read(key: 'email');
            final userStoredPassword = await storage.read(key: 'password');

            final user = await _auth.signInWithEmailAndPassword(
              email: userStoredEmail.trim(),
              password: userStoredPassword.trim(),
            );

            if (user != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Home()),
              );
              setState(() {
                showSpinner = false;
              });
            }
          }

          // Face ID.
        } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
          // Touch ID.
          final authenticated = await auth.authenticateWithBiometrics(
            localizedReason: 'Authenticate to sign in for next time',
            useErrorDialogs: false,
            stickyAuth: true,
          );

          if (authenticated) {
            final userStoredEmail = await storage.read(key: 'email');
            final userStoredPassword = await storage.read(key: 'password');
            final user = await _auth.signInWithEmailAndPassword(
              email: userStoredEmail.trim(),
              password: userStoredPassword.trim(),
            );

            if (user != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Home()),
              );
              setState(() {
                showSpinner = false;
              });
            }
          }
        }
      } else {
        try {
          final authenticated = await auth.authenticateWithBiometrics(
            localizedReason: 'Authenticate to sign in for next time',
            stickyAuth: true,
            useErrorDialogs: false,
          );

          if (authenticated) {
            final userStoredEmail = await storage.read(key: 'email');
            final userStoredPassword = await storage.read(key: 'password');

            final user = await _auth.signInWithEmailAndPassword(
              email: userStoredEmail.trim(),
              password: userStoredPassword.trim(),
            );

            if (user != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Home()),
              );
              setState(() {
                showSpinner = false;
              });
            }
          }
        } on PlatformException catch (e) {
          print(e);
          if (e.code == auth_error.notAvailable) {
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
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: SingleChildScrollView(
            child: SafeArea(
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
                  Padding(
                    padding: const EdgeInsets.all(35.0),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          showAlert(),
                          Text(
                            "Welcome",
                            style: TextStyle(
                              color: Color(0xcc004343),
                              fontSize: 35,
                            ),
                          ),
                          Text(
                            "Back",
                            style: TextStyle(
                              color: Color(0xcc004343),
                              fontSize: 35,
                            ),
                          ),
                          SizedBox(
                            height: 50,
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
                                      return 'Please enter email';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    email = value;
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
                            height: 30,
                          ),
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                              child: Container(
                                width: 300,
                                child: TextFormField(
                                  obscureText: true,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter password';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    password = value;
                                  },
                                  decoration: InputDecoration(
                                    border: UnderlineInputBorder(),
                                    prefixIcon: Icon(Icons.lock),
                                    hintText: "Password",
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    labelStyle: TextStyle(
                                      color: Colors.black,
                                    ),
                                    focusColor: Colors.black,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ResetPassword()),
                                  );
                                },
                                child: Text(
                                  "Forgot Password?",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xcc004343),
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Center(
                            child: InkWell(
                              onTap: () => authenticate(),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Icon(
                                  Icons.fingerprint,
                                  color: Color(0xcc004343),
                                  size: 45,
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
                                  child: Text("Login"),
                                  textColor: Colors.white,
                                  onPressed: () async {
                                    setState(() {
                                      showSpinner = true;
                                    });

                                    try {
                                      final user = await _auth
                                          .signInWithEmailAndPassword(
                                        email: email.trim(),
                                        password: password.trim(),
                                      );
                                      if (user != null) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Home()),
                                        );
                                        setState(() {
                                          showSpinner = false;
                                        });
                                      }
                                    } catch (e) {
                                      print(e);

                                      setState(() {
                                        showSpinner = false;
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
                                "Don't have an account?",
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
                                        builder: (context) => Register()),
                                  );
                                },
                                child: Text(
                                  "Sign Up",
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
