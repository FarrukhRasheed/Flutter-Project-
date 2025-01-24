import 'package:app1/authentication.dart';
import 'package:app1/home.dart';
import 'package:app1/login.dart';
import 'package:flutter/material.dart';
import 'package:app1/convertcurrency.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  // const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void RegisterUser() async {
    try {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();
      final UserCredential userCredential = await auth
          .createUserWithEmailAndPassword(email: email, password: password);

      print("Registeration Success");
      //Alert Msg
      Fluttertoast.showToast(msg: "Registeration Success");
      //clear Fields
      _emailController.clear();
      _passwordController.clear();
    } catch (e) {
      print("Registeration Failed : ${e.toString()}");
      //Alert Msg
      Fluttertoast.showToast(msg: "Registeration Failed : ${e.toString()}");
    }
  }
  // void RegisterUser() {
  //   print(emailController.text);
  //   print("Success");
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create an Account"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text(
              "Create an account",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email Address"),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              obscureText: true,
              obscuringCharacter: "*",
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  RegisterUser();
                },
                child: const Text("Register")),
            const Text("Already Have an Account"),
            TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                },
                child: const Text("Login"))
          ],
        ),
      ),
    );
  }
}
