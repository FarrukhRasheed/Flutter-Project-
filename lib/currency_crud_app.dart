// import 'package:flutter/dra.dart';
import 'package:app1/drawer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dra.dart';

class CurrencyCrudApp extends StatefulWidget {
  const CurrencyCrudApp({Key? key}) : super(key: key);

  @override
  State<CurrencyCrudApp> createState() => _CurrencyCrudAppState();
}

class _CurrencyCrudAppState extends State<CurrencyCrudApp> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final CollectionReference _currencies =
      FirebaseFirestore.instance.collection('currencies');

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

  void _addCurrency() async {
    final String name = _nameController.text.trim();
    final String rateText = _rateController.text.trim();

    if (name.isNotEmpty && rateText.isNotEmpty) {
      final double? rate = double.tryParse(rateText);
      if (rate != null) {
        await _currencies.add({'name': name, 'rate': rate});
        _nameController.clear();
        _rateController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency CRUD'),
        backgroundColor: Colors.blue,
      ),
      drawer: CurrencyDrawer(onMenuTap: _onMenuTap), // Use the custom drawer
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Currency Name'),
                ),
                TextField(
                  controller: _rateController,
                  decoration: const InputDecoration(labelText: 'Exchange Rate'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _addCurrency,
                  child: const Text('Add Currency'),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _currencies.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Error fetching data.'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final data = snapshot.data!;
                return ListView.builder(
                  itemCount: data.docs.length,
                  itemBuilder: (context, index) {
                    final doc = data.docs[index];
                    final Map<String, dynamic> currency =
                        doc.data() as Map<String, dynamic>;

                    return ListTile(
                      title: Text(currency['name']),
                      subtitle: Text('Rate: ${currency['rate']}'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CurrencyConvertPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Currency Convert')),
      body: const Center(child: Text('Currency Convert Page')),
    );
  }
}

class ShowHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Show History')),
      body: const Center(child: Text('Show History Page')),
    );
  }
}
