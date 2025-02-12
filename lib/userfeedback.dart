import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CurrencyFeedbackScreen extends StatefulWidget {
  @override
  _CurrencyFeedbackScreenState createState() => _CurrencyFeedbackScreenState();
}

class _CurrencyFeedbackScreenState extends State<CurrencyFeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();
  int _rating = 1; // Default rating value

  final CollectionReference _feedbackCollection =
      FirebaseFirestore.instance.collection('currency_feedback');

  Future<void> _submitFeedback() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _feedbackCollection.add({
          'name': _nameController.text,
          'email': _emailController.text,
          'rating': _rating,
          'feedback_text': _feedbackController.text,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Clear fields after submission
        _nameController.clear();
        _emailController.clear();
        _feedbackController.clear();
        setState(() {
          _rating = 1;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Feedback Submitted Successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Currency Feedback Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.isEmpty ? 'Please enter your email' : null,
              ),
              TextFormField(
                controller: _feedbackController,
                decoration: InputDecoration(labelText: 'Feedback'),
                maxLines: 3,
                validator: (value) => value!.isEmpty ? 'Please enter feedback' : null,
              ),
              SizedBox(height: 10),
              Text('Rate Your Experience:'),
              Row(
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      color: Colors.orange,
                    ),
                    onPressed: () {
                      setState(() {
                        _rating = index + 1;
                      });
                    },
                  );
                }),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _submitFeedback,
                  child: Text('Submit Feedback'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
