import 'package:app1/adminfeedback.dart';
import 'package:flutter/material.dart';
import 'package:app1/exchange_rate_screen.dart';
import 'package:app1/faq_screen.dart';
// import 'package:flutt/adminfeedback.dart';

class AdminDrawer extends StatelessWidget {
  final Function(String) onMenuTap;

  const AdminDrawer({Key? key, required this.onMenuTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            child: const Text(
              'Admin Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.monetization_on),
            title: const Text('Currency Convert'),
            onTap: () {
              Navigator.pushNamed(context, '/convertcurrency');
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Show User History'),
            onTap: () {
              Navigator.pushNamed(context, '/showhistory');
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('All Conversion History'),
            onTap: () {
              Navigator.pushNamed(context, '/allhistory'); // Admin-only page
            },
          ),
          ListTile(
            leading: const Icon(Icons.swap_horiz),
            title: const Text('Rate Exchange'),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => ExchangeRateScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('FAQs'),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => FAQScreen()));
            },
          ),
           ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Feedback'),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => adminFeedback()));
            },
          ),
        ],
      ),
    );
  }
}
