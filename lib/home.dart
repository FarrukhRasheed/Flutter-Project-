import 'package:flutter/material.dart';
import 'login.dart'; // Import LoginScreen
import 'register.dart'; // Import RegisterScreen

void main() {
  runApp(CurrencyConverterWeb());
}

class CurrencyConverterWeb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Currency Converter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => AuthenticationScreen(),
        '/login': (context) => LoginScreen(), // Named route for LoginScreen
        '/register': (context) => RegisterScreen(), // Named route for RegisterScreen
      },
    );
  }
}

class AuthenticationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Authentication')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login'); // Navigate to LoginScreen
              },
              child: Text('Login'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register'); // Navigate to RegisterScreen
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
