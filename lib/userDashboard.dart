import 'package:app1/currency_crud_app.dart';
import 'package:app1/drawer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Userdashboard extends StatefulWidget {
  const Userdashboard({super.key});

  @override
  State<Userdashboard> createState() => _UserdashboardState();
}

class _UserdashboardState extends State<Userdashboard> {
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

  void _onMenuTap(String menu) {
    Navigator.pop(context); // Close the drawer
    switch (menu) {
      case 'convert':
        // Navigate to Currency Convert screen
        Navigator.push(context, MaterialPageRoute(builder: (_) => CurrencyConvertPage()));
        break;
      case 'history':
        // Navigate to Show History screen
        Navigator.push(context, MaterialPageRoute(builder: (_) => ShowHistoryPage()));
        break;
      case 'add':
        // Add new currency logic
        break;
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("User Dashboard"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
            tooltip: "Logout",
          ),
        ],
      ),
      drawer: CurrencyDrawer(onMenuTap: _onMenuTap),
      body: Center(
        child: Text("USER DASHBOARD"),
      ),
    );
  }
}
