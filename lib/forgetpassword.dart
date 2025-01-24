// import 'package:app1/authentication.dart';
// import 'package:app1/home.dart';
import 'package:flutter/material.dart';
// import 'package:app1/convertcurrency.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController emailcontroller = TextEditingController();
  void _resetpassword() async {
    try {
      final String email = emailcontroller.text.trim();
      await auth.sendPasswordResetEmail(email: email);
      Fluttertoast.showToast(msg: 'password reset email sent');
      Navigator.pushNamed(context, 'forgetpassword');
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to sent reset email : ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        backgroundColor: Colors.indigoAccent,
      ),
      body: Column(
        children: [
          TextField(
            controller: emailcontroller,
            decoration: const InputDecoration(
                labelText: "Email", hintText: "enter your email"),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(onPressed: _resetpassword,
           child: const Text("Reset Password"),),
        ],
      ),
    );
  }
}
