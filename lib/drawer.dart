import 'package:flutter/material.dart';

class CurrencyDrawer extends StatelessWidget {
  final Function(String) onMenuTap;

  const CurrencyDrawer({Key? key, required this.onMenuTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            child: const Text(
              'Currency Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.monetization_on),
            title: const Text('Currency Convert'),
            onTap: () => onMenuTap('convert'),
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Show History'),
            onTap: () => onMenuTap('history'),
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Add New Currency'),
            onTap: () => onMenuTap('add'),
          ),
        ],
      ),
    );
  }
}
