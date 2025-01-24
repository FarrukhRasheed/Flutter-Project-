import 'package:app1/authentication.dart';
import 'package:app1/home.dart';
import 'package:app1/logiclogin.dart';
import 'package:app1/register.dart';
import 'package:flutter/material.dart';
import 'package:app1/convertcurrency.dart';
import 'package:fluttertoast/fluttertoast.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void LoginUser() {
    print(_emailController.text);
    print("Success");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text(
              "Login an account",
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
                  login(
                      context, _emailController.text, _passwordController.text);
                },
                child: const Text("Login")),
            const Text("Already Have an Account"),
            TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterScreen()));
                },
                child: const Text("Register")),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/forgetpassword');
                },
                child: const Text("Forgot Your Password")),
          ],
        ),
      ),
    );
  }
}
