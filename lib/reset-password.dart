import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:votingapp/login.dart';
import 'package:votingapp/main.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _auth = FirebaseAuth.instance;
  String email;
  bool showSpinner = false;

  final _formKey = GlobalKey<FormState>();

  String _error;

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
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(35.0),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            showAlert(),
                            Text(
                              "Change Password",
                              style: TextStyle(
                                color: Color(0xcc004343),
                                fontSize: 30,
                              ),
                            ),
                            SizedBox(
                              height: 50,
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
                                        return 'Please enter Email';
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
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                              child: ButtonTheme(
                                minWidth: 300.0,
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
                                  child: Text("Submit"),
                                  textColor: Color(0xff004343),
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      setState(() {
                                        showSpinner = true;
                                      });
                                      try {
                                        _auth
                                            .sendPasswordResetEmail(
                                              email: email,
                                            )
                                            .then((result) => {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Login()),
                                                  ),
                                                });

                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text("Notification"),
                                                content: Text(
                                                    "A reset password link has been sent to $email "),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    child: Text("Close"),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  )
                                                ],
                                              );
                                            });

                                        setState(() {
                                          showSpinner = false;
                                        });
                                      } catch (e) {
                                        print(e);

                                        setState(() {
                                          showSpinner = false;
                                          _error = e.message;
                                        });
                                      }
                                    }
                                  },
                                ),
                              ),
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
