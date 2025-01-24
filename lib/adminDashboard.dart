import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Admindashboard extends StatefulWidget {
  const Admindashboard({super.key});

  @override
  State<Admindashboard> createState() => _AdmindashboardState();
}

class _AdmindashboardState extends State<Admindashboard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _logout() async {
    try {
      await _auth.signOut();
      // After logout, navigate to the login screen or landing page
      Navigator.pushReplacementNamed(context, '/login'); // Update '/login' with your route
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error logging out: $e"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("Admin Dashboard"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
            tooltip: "Logout",
          ),
        ],
      ),
      body: Center(
        child: Text("Admin DASHBOARD"),
      ),
    );
  }
}
