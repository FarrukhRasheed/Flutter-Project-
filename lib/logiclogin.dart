// import 'package:app1/authentication.dart';
// import 'package:app1/home.dart';
import 'package:flutter/material.dart';
// import 'package:app1/convertcurrency.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

const String adminEmail = 'admin@gmail.com';
final FirebaseAuth auth = FirebaseAuth.instance;

void login(BuildContext context, String email, String password) async {
  try {
    UserCredential userCredential =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    if (userCredential.user!.email == adminEmail) {
      print('Admin Login Success.....');
      Fluttertoast.showToast(msg: 'Admin Login Success');
      Navigator.pushNamed(context, '/adminDashboard');
    } else {
      print('User Login Success');
      Fluttertoast.showToast(msg: 'User Login Success');
      Navigator.pushNamed(context, '/userDashboard');
    }
  } catch (e) {
    //Show msg
    print('Login Failed');
    //Alert
    Fluttertoast.showToast(msg: 'Login Failed');
  }
}
