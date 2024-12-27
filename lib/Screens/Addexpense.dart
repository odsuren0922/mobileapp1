import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:orlogo/services/transaction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final TextEditingController _amountController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedTransaction = 'Netflix'; // Default value

  @override
  Widget build(BuildContext context) {
    bool validateForm() {
      // Add your form validation logic here
      return _amountController.text.isNotEmpty && _selectedDate != null;
    }

    Future<void> addOutcome() async {
      if (validateForm()) {
        final user = FirebaseAuth.instance.currentUser;
        double amount = double.tryParse(_amountController.text) ?? 0.0;
        if (user != null) {
          String userId = user.uid;

          // Create an instance of TransactionService
          final TransactionService transactionService = TransactionService();

          try {
            Timestamp dateTimestamp = _selectedDate != null
                ? Timestamp.fromDate(_selectedDate!)
                : Timestamp
                    .now(); // Default to current timestamp if no date selected
            // Call addTransaction on the instancea
            await transactionService.addOutcomeTransaction(
              userId: userId,
              amount: amount,
              date: dateTimestamp,
              type: "expenses",
              status: "pending",
              description: _selectedTransaction ?? 'Other',
            );

            // Show success message
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Outcome Added'),
                content:
                    const Text('Your outcome has been added successfully.'),
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
            print("Error adding outcome: $e");
            // Show a generic error message if something goes wrong
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Error'),
                content: const Text(
                    'An error occurred while adding the outcome. Please try again later.'),
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

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(200), // Increase the height here
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.teal,
          leading: const Icon(Icons.arrow_back),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ],
          flexibleSpace: const Padding(
            padding: EdgeInsets.only(top: 30.0), // Adjust top padding for title
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Зарлага нэмэх',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400), // Bigger title
                ),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.teal,
        child: Column(
          children: [
            // Form Section
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Transaction Name
                    const Text(
                      'Гүйлгээний нэр',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _selectedTransaction,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedTransaction = newValue;
                          });
                        },
                        items: <String>[
                          'Netflix',
                          'Amazon',
                          'Spotify',
                          'Food',
                          'Youtube',
                          'Other'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  radius: 20,
                                  backgroundImage: NetworkImage(
                                    'https://upload.wikimedia.org/wikipedia/commons/0/08/Netflix_2015_logo.svg',
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(value,
                                    style: const TextStyle(fontSize: 18)),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Amount
                    const Text(
                      'Үнийн дүн',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefixText: '\$ ',
                        prefixStyle:
                            const TextStyle(color: Colors.teal, fontSize: 18),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Date
                    const Text(
                      'Огноо',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: _selectDate,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedDate != null
                                  ? DateFormat('EEE, dd MMM yyyy')
                                      .format(_selectedDate!)
                                  : 'Select a date',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                            ),
                            const Icon(Icons.calendar_today,
                                color: Colors.teal),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Payment Button
                    const Text(
                      'Төлбөр',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        addOutcome();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey.shade300, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, color: Colors.teal),
                            SizedBox(width: 10),
                            Text(
                              'Төлбөр нэмэх',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.teal),
                            ),
                          ],
                        ),
                      ),
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

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: AddExpensePage(),
  ));
}
