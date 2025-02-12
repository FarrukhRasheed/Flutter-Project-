import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class adminFeedback extends StatefulWidget {
  final bool isAdmin; // Admin role flag

  adminFeedback({required this.isAdmin});

  @override
  _adminFeedbackState createState() => _adminFeedbackState();
}

class _adminFeedbackState extends State<adminFeedback> {
  final TextEditingController _controller = TextEditingController();
  final CollectionReference _feedbackCollection =
      FirebaseFirestore.instance.collection('currency_feedback');
  final User? _user = FirebaseAuth.instance.currentUser; // Get logged-in user

  Future<void> _addFeedback(String feedback) async {
    if (feedback.isNotEmpty && _user != null) {
      try {
        await _feedbackCollection.add({
          'user_id': _user!.uid,
          'feedback_text': feedback,
          'timestamp': FieldValue.serverTimestamp(),
        });
        _controller.clear();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Feedback Submitted')));
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _deleteFeedback(String id) async {
    if (widget.isAdmin) {
      await _feedbackCollection.doc(id).delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.isAdmin ? 'Admin Dashboard' : 'Currency Feedback')),
      body: Column(
        children: [
          if (!widget.isAdmin) // Admin ke liye input box nahi dikhana
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Enter Currency Conversion Feedback',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send, color: Colors.blue),
                    onPressed: () => _addFeedback(_controller.text),
                  ),
                ),
              ),
            ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: widget.isAdmin
                  ? _feedbackCollection.orderBy('timestamp', descending: true).snapshots()
                  : _feedbackCollection
                      .where('user_id', isEqualTo: _user?.uid) // Normal user apna feedback dekhega
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error loading feedback'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final data = snapshot.data!;
                return ListView.builder(
                  itemCount: data.docs.length,
                  itemBuilder: (context, index) {
                    final doc = data.docs[index];
                    final feedbackText = doc['feedback_text'];

                    return ListTile(
                      title: Text(feedbackText),
                      trailing: widget.isAdmin
                          ? IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteFeedback(doc.id),
                            )
                          : null, // Normal user ke liye delete option nahi hoga
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
