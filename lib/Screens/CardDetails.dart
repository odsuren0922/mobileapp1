import 'package:orlogo/services/transaction.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CardDetailsPage extends StatefulWidget {
  const CardDetailsPage({super.key});

  @override
  _CardDetailsPageState createState() => _CardDetailsPageState();
}

class _CardDetailsPageState extends State<CardDetailsPage> {
  TransactionService transactionService = TransactionService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cvcController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  String cardName = '';
  String cardNumber = '';
  String cvc = '';
  String expiryDate = '';
  String amount = '';

  // Function to validate the form
  bool _validateForm() {
    if (_nameController.text.isEmpty ||
        _cardNumberController.text.isEmpty ||
        _cvcController.text.isEmpty ||
        _expiryDateController.text.isEmpty ||
        _amountController.text.isEmpty) {
      return false; // If any field is empty, return false
    }
    return true;
  }

  Future<void> _addIncome() async {
    if (_validateForm()) {
      final user = FirebaseAuth.instance.currentUser;
      double amount = double.tryParse(_amountController.text) ?? 0.0;
      if (user != null) {
        String userId = user.uid;

        // Create an instance of TransactionService
        final TransactionService transactionService = TransactionService();

        try {
          // Call addTransaction on the instance
          await transactionService.addTransaction(
            userId: userId,
            amount: amount,
            type: "income",
            status: "success",
            description: "Income added through card",
          );

          // Show success message
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Income Added'),
              content: const Text(
                  'Your income has been added successfully using the card.'),
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
        } catch (e) {
          print("Error adding income: $e");
          // Show a generic error message if something goes wrong
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Error'),
              content: const Text(
                  'An error occurred while adding the income. Please try again later.'),
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
            content: const Text('Please login to add income.'),
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
      // If form validation fails
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Please fill in all fields correctly.'),
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

  void _updateCardDetails() {
    setState(() {
      cardName = _nameController.text;
      cardNumber = _cardNumberController.text;
      cvc = _cvcController.text;
      expiryDate = _expiryDateController.text;
      amount = _amountController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.teal,
        leading: const Icon(Icons.arrow_back),
        title: const Padding(
          padding: EdgeInsets.only(top: 30),
          child: Text(
            'Түрийвч цэнэглэх',
            style: TextStyle(fontSize: 20),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        color: Colors.teal,
        child: Column(
          children: [
            // Tabs Section
            Container(
              padding: const EdgeInsets.only(right: 20, left: 20, top: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Картууд',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white),
                        ),
                        child: const Text(
                          'Аккаунт',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Card Section
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  children: [
                    // Card Image
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Debit Card',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            cardName.isEmpty ? 'Name' : cardName,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            cardNumber.isEmpty
                                ? '---- ---- ---- ----'
                                : cardNumber,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                letterSpacing: 2),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                cvc.isEmpty ? 'CVC' : cvc,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                              Text(
                                expiryDate.isEmpty ? 'MM/YY' : expiryDate,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Input Fields
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'КАРТ ДЭЭРХ НЭР',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (_) => _updateCardDetails(),
                    ),
                    const SizedBox(height: 15),

                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _cardNumberController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'КАРТЫН ДУГААР',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onChanged: (_) => _updateCardDetails(),
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 100,
                          child: TextField(
                            controller: _cvcController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'CVC',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _expiryDateController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'ДУУСАХ ХУГАЦАА YYYY/MM',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onChanged: (_) => _updateCardDetails(),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'ТӨЛБӨР',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    ElevatedButton(
                      onPressed: _addIncome,
                      child: const Text('Үндсэн карт ашиглах'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
