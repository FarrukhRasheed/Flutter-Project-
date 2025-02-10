import 'package:app1/adminDrawer.dart';
import 'package:app1/currency_crud_app.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Admindashboard extends StatefulWidget {
  const Admindashboard({super.key});

  @override
  State<Admindashboard> createState() => _AdmindashboardState();
}

class _AdmindashboardState extends State<Admindashboard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
        title: Text("Admin Dashboard"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
            tooltip: "Logout",
          ),
        ],
      ),
      drawer: AdminDrawer(onMenuTap: _onMenuTap),

      body: Center(
        child: Text("Admin DASHBOARD"),
      ),
    );
  }
}
