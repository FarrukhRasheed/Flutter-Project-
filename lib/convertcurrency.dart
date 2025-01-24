import 'dart:async';
import 'dart:convert'; // JSON ke liye
import 'package:http/http.dart' as http; // HTTP requests ke liye
import 'package:flutter/material.dart';



class CurrencyConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Currency Converter',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CurrencyConverterScreen(),
    );
  }
}

class CurrencyConverterScreen extends StatefulWidget {
  @override
  _CurrencyConverterScreenState createState() => _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  final TextEditingController _amountController = TextEditingController();
  String _fromCurrency = 'USD';
  String _toCurrency = 'INR';
  double? _convertedAmount;
  bool _isLoading = false;

  final List<String> _currencies = ['USD', 'INR', 'EUR', 'GBP', 'AUD', 'CAD', 'JPY'];

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

    final url = Uri.parse(
        'https://api.exchangerate-api.com/v4/latest/$_fromCurrency');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final rate = data['rates'][_toCurrency];
        setState(() {
          _convertedAmount = amount * rate;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Currency Converter' ,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.amber))),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
            SizedBox(height: 16),
            if (_convertedAmount != null)
              Text(
                'Converted Amount: $_convertedAmount $_toCurrency',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}
