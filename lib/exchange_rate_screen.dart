import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';

class ExchangeRateScreen extends StatefulWidget {
  @override
  _ExchangeRateScreenState createState() => _ExchangeRateScreenState();
}

class _ExchangeRateScreenState extends State<ExchangeRateScreen> {
  final String apiKey = "YOUR_API_KEY"; // Replace with your API key
  final String baseCurrency = "USD";
  String selectedCurrency = "EUR";
  double exchangeRate = 0.0;
  List<FlSpot> historicalData = [];
  TextEditingController amountController = TextEditingController();
  double convertedAmount = 0.0;

  @override
  void initState() {
    super.initState();
    fetchExchangeRate();
    fetchHistoricalData();
  }

  Future<void> fetchExchangeRate() async {
    final url =
        "https://api.exchangerate-api.com/v4/latest/$baseCurrency";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        exchangeRate = data['rates'][selectedCurrency] ?? 0.0;
        updateConvertedAmount();
      });
    } else {
      print("Error fetching exchange rate: ${response.statusCode}");
    }
  }

  Future<void> fetchHistoricalData() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('exchange_rates')
          .orderBy('date', descending: true)
          .limit(7)
          .get();

      List<FlSpot> tempData = [];
      int index = 0;
      for (var doc in snapshot.docs) {
        if (doc.data().containsKey('rate')) {
          double rate = doc['rate'].toDouble();
          tempData.add(FlSpot(index.toDouble(), rate));
          index++;
        }
      }

      setState(() {
        historicalData = tempData.isNotEmpty ? tempData : [FlSpot(0, 1)];
      });
      print("Historical Data: $historicalData");
    } catch (e) {
      print("Error fetching historical data: $e");
    }
  }

  void updateConvertedAmount() {
    setState(() {
      double amount = double.tryParse(amountController.text) ?? 0.0;
      convertedAmount = amount * exchangeRate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Exchange Rate Info"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Enter Amount in $baseCurrency",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => updateConvertedAmount(),
            ),
            SizedBox(height: 10),
            DropdownButton<String>(
              value: selectedCurrency,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCurrency = newValue!;
                  fetchExchangeRate();
                });
              },
              items: ['USD', 'INR', 'EUR', 'GBP', 'AUD', 'CAD', 'JPY', 'PKR']
                  .map((currency) => DropdownMenuItem(
                        value: currency,
                        child: Text(currency),
                      ))
                  .toList(),
            ),
            SizedBox(height: 20),
            Text("1 $baseCurrency = $exchangeRate $selectedCurrency",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text("Converted Amount: $convertedAmount $selectedCurrency",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
            SizedBox(height: 20),
            Expanded(
              child: historicalData.isNotEmpty
                  ? LineChart(
                      LineChartData(
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(show: true),
                        borderData: FlBorderData(show: true),
                        lineBarsData: [
                          LineChartBarData(
                            spots: historicalData,
                            isCurved: true,
                            color: Colors.blue,
                            barWidth: 3,
                            isStrokeCapRound: true,
                            belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
                          )
                        ],
                      ),
                    )
                  : Center(child: Text("No data available")),
            ),
          ],
        ),
      ),
    );
  }
}
