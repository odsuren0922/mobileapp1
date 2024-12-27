import 'package:flutter/material.dart';
import 'package:orlogo/services/transaction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Bill.dart';

class BillDetailsorlogoroveScreen extends StatelessWidget {
  final String uid;
  final String name;
  final double amount;
  final String date;
  final double rate;
  final double all;
  final String payment;

  const BillDetailsorlogoroveScreen(
      {super.key,
      required this.uid,
      required this.name,
      required this.amount,
      required this.date,
      required this.all,
      required this.rate,
      required this.payment});

  @override
  Widget build(BuildContext context) {
    Future<void> addOutcome() async {
      final user = FirebaseAuth.instance.currentUser;
      double amount = all;
      if (user != null) {
        String userId = user.uid;

        // Create an instance of TransactionService
        final TransactionService transactionService = TransactionService();

        try {
          await transactionService.addPayment(
            userId: userId,
            docId: uid,
            amount: amount,
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentSuccessScreen(
                name: name,
                amount: amount,
                rate: rate,
                all: all,
                payment: payment,
              ),
            ),
          );
        } catch (e) {
          print("Error payment: $e");
          // Show a generic error message if something goes wrong
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Error'),
              content: const Text(
                  'An error occurred while adding the payment. Please try again later.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      } else {
        // User is not authenticated
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Please login to add outcome.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.white, // Background color
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          backgroundColor: Colors.teal,
          elevation: 0,
          title: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Bill Payment', // Changed to match screenshot title
              style: TextStyle(color: Colors.black),
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card with payment details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 24, // Size of the logo
                    backgroundColor:
                        Colors.teal, // Background color of the logo
                    child: Text(
                      name.isNotEmpty
                          ? name[0].toUpperCase()
                          : '', // Take the first letter
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        // Allow text to take up remaining space and wrap
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "You will pay $name for one month with $payment",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              softWrap: true, // Enable soft wrap
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 50),
                  // Price and fee details
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Price', style: TextStyle(fontSize: 16)),
                      Text('\$ $amount', style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Fee', style: TextStyle(fontSize: 16)),
                      Text('\$ $rate', style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 20),
                  // Total price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '\$ $all',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Spacer(),
            // Pay button
            ElevatedButton(
              onPressed: () {
                addOutcome();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Баталгаажуулах',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
