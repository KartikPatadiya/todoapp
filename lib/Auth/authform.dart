import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  //=====keyss======
  final _formkey = GlobalKey<FormState>();

  var _email = '';
  var _password = '';
  var _username = '';
  bool isLoginPage = false;
  //=====keyss======
//---------------------

  startauthetication() {
    final validity = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (validity) {
      _formkey.currentState!.save();
      submitform(_email, _password, _username);
    }
  }

  submitform(String email, String password, String username) async {
    final auth = FirebaseAuth.instance;
    AuthCredential authresult;
    try {
      if (isLoginPage) {
        // authresult = await auth.signInWithEmailAndPassword(email: email, password: password);

        UserCredential authresult = (await auth.signInWithEmailAndPassword(
            email: email, password: password));
      } else {
        // UserCredential usercredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

        UserCredential authresult = (await auth.createUserWithEmailAndPassword(
            email: email, password: password));
        String? uid = authresult.user?.uid;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .set({'username': username, 'email': email});
      }
    } catch (err) {
      print(err.toString());
      return null;
    }
  }

//---------------------
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(top: 15),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!isLoginPage)
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      key: ValueKey('username'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Incorrect username';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _username = value!;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide()),
                          labelText: "Username",
                          labelStyle: GoogleFonts.roboto()),
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    key: ValueKey('email'),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Incorrect Email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value!;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide()),
                        labelText: "Email",
                        labelStyle: GoogleFonts.roboto()),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    obscureText: true,
                    keyboardType: TextInputType.emailAddress,
                    key: ValueKey('password'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Incorrect Password';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value!;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide()),
                        labelText: "Password",
                        labelStyle: GoogleFonts.roboto()),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      startauthetication();
                    },
                    child: isLoginPage
                        ? Text('Login', style: GoogleFonts.roboto(fontSize: 16))
                        : Text('SignUp',
                            style: GoogleFonts.roboto(fontSize: 16)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          isLoginPage = !isLoginPage;
                        });
                      },
                      child: isLoginPage
                          ? Text('Not a Member')
                          : Text('Already a Member?'))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
