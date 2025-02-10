import 'dart:async';
import 'dart:convert';
import 'package:app1/currency_crud_app.dart';
import 'package:app1/drawer.dart';
import 'package:app1/exchange_rate_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(CurrencyConverterApp());
// }

class CurrencyConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Currency Converter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      home: CurrencyConverterScreen(),
    );
  }
}

class CurrencyConverterScreen extends StatefulWidget {
  @override
  _CurrencyConverterScreenState createState() =>
      _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  final TextEditingController _amountController = TextEditingController();
  String _fromCurrency = 'USD';
  String _toCurrency = 'INR';
  double? _convertedAmount;
  bool _isLoading = false;

  final List<String> _currencies = [
    'USD',
    'INR',
    'EUR',
    'GBP',
    'AUD',
    'CAD',
    'JPY',
    'PKR'
  ];

  Future<void> _convertCurrency() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid amount.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final url =
        Uri.parse('https://api.exchangerate-api.com/v4/latest/$_fromCurrency');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final rate = data['rates'][_toCurrency];
        setState(() {
          _convertedAmount = amount * rate;
        });

        // Get logged-in user ID
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User not logged in!')),
          );
          return;
        }

        // Save to Firebase with user ID
        await FirebaseFirestore.instance.collection('conversion_history').add({
          'uid': user.uid, // Store user ID
          'amount': amount,
          'fromCurrency': _fromCurrency,
          'toCurrency': _toCurrency,
          'convertedAmount': _convertedAmount,
          'timestamp': FieldValue.serverTimestamp(),
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch exchange rate.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again later.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ConversionHistoryScreen()),
    );
  }

  void _onMenuTap(String menu) {
    Navigator.pop(context); // Close the drawer
    switch (menu) {
      case 'convert':
        // Navigate to Currency Convert screen
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => CurrencyConverterApp()));
        break;
      case 'history':
        // Navigate to Show History screen
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => ShowHistoryPage()));
        break;
      case 'rx':
        // Add new currency logic
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => ExchangeRateScreen()));

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Currency Converter',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber),
          ),
        ),
      ),
      drawer: CurrencyDrawer(onMenuTap: _onMenuTap),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Amount',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _fromCurrency,
                              onChanged: (value) {
                                setState(() {
                                  _fromCurrency = value!;
                                });
                              },
                              items: _currencies.map((currency) {
                                return DropdownMenuItem(
                                  value: currency,
                                  child: Text(currency),
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                labelText: 'From',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _toCurrency,
                              onChanged: (value) {
                                setState(() {
                                  _toCurrency = value!;
                                });
                              },
                              items: _currencies.map((currency) {
                                return DropdownMenuItem(
                                  value: currency,
                                  child: Text(currency),
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                labelText: 'To',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _convertCurrency,
                        child: _isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text('Convert'),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              if (_convertedAmount != null)
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Converted Amount: $_convertedAmount $_toCurrency',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _navigateToHistory,
                child: Text('View Conversion History'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class ConversionHistoryScreen extends StatefulWidget {
  @override
  _ConversionHistoryScreenState createState() =>
      _ConversionHistoryScreenState();
}

class _ConversionHistoryScreenState extends State<ConversionHistoryScreen> {
  String? selectedCurrency;
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversion History'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: "Search by amount or currency",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(color: Colors.grey),
              ),
              child: DropdownButton<String>(
                hint: Text("Filter by Currency"),
                value: selectedCurrency,
                isExpanded: true,
                underline: SizedBox(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCurrency = newValue;
                  });
                },
                items: [
                  null,
                  'USD',
                  'INR',
                  'EUR',
                  'GBP',
                  'AUD',
                  'CAD',
                  'JPY',
                  'PKR'
                ]
                    .map((currency) => DropdownMenuItem(
                          value: currency,
                          child: Text(currency ?? 'All'),
                        ))
                    .toList(),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseAuth.instance.authStateChanges().asyncMap((user) {
                print(user);
                if (user == null) {
                  return FirebaseFirestore.instance
                      .collection('conversion_history')
                      .where('uid', isEqualTo: '')
                      .get();
                }
                else if (user?.email == "admin@gmail.com") {
                  return FirebaseFirestore.instance
                      .collection('conversion_history')
                      .get();
                }
                return FirebaseFirestore.instance
                    .collection('conversion_history')
                    .where('uid',
                        isEqualTo:
                            user.uid) // Fetch only the logged-in user's records
                    .orderBy('timestamp', descending: true)
                    .get();
              }),
              builder: (context, snapshot) {
                print(snapshot);

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                      child: Text('No conversion history available.'));
                }

                final historyDocs = snapshot.data!.docs.where((doc) {
                  if (selectedCurrency != null &&
                      (doc['fromCurrency'] != selectedCurrency &&
                          doc['toCurrency'] != selectedCurrency)) {
                    return false;
                  }
                  final amount = doc['amount'].toString().toLowerCase();
                  final fromCurrency =
                      doc['fromCurrency'].toString().toLowerCase();
                  final toCurrency = doc['toCurrency'].toString().toLowerCase();
                  return amount.contains(searchQuery) ||
                      fromCurrency.contains(searchQuery) ||
                      toCurrency.contains(searchQuery);
                }).toList();

                if (historyDocs.isEmpty) {
                  return Center(child: Text('No matching conversions.'));
                }

                return ListView.builder(
                  itemCount: historyDocs.length,
                  itemBuilder: (context, index) {
                    final history = historyDocs[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 3,
                      child: ListTile(
                        title: Text(
                          '${history['amount']} ${history['fromCurrency']} to ${history['toCurrency']}',
                        ),
                        subtitle: Text(
                            'Converted Amount: ${history['convertedAmount']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                                '${(history['timestamp'] as Timestamp).toDate()}'),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection('conversion_history')
                                    .doc(history.id)
                                    .delete();
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
