import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'Detail.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text('Please log in'),
        ),
      );
    }

    // Fetch user data from Firestore
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Scaffold(
            body: Center(child: Text('User data not found')),
          );
        }

        var userData = snapshot.data!.data() as Map<String, dynamic>;
        double balance = userData['balance'] ?? 0.0;

        return Scaffold(
          body: Container(
            color: Colors.teal,
            child: Column(
              children: [
                // Balance Section
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(30)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Нийт үлдэгдэл',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '\$${balance.toStringAsFixed(2)}', // Displaying balance
                        style: const TextStyle(
                            fontSize: 36, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildActionButton(Icons.add, 'Нэмэх'),
                          _buildActionButton(Icons.grid_view, 'Төлөх'),
                          _buildActionButton(Icons.send, 'Илгээх'),
                        ],
                      ),
                    ],
                  ),
                ),
                // Tab Section
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildTab('Гүйлгээнүүд', 0),
                    _buildTab('Хүлээгдэж буй гүйлгээ', 1),
                  ],
                ),
                const SizedBox(height: 10),
                // Transactions Section
                Expanded(
                  child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30)),
                      ),
                      child: _selectedTabIndex == 0
                          ? StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('transactions')
                                  .where('userId', isEqualTo: user.uid)
                                  .where('status', isEqualTo: 'success')
                                  .orderBy('timestamp', descending: true)
                                  .snapshots(),
                              builder: (context, transactionSnapshot) {
                                if (transactionSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }

                                if (transactionSnapshot.hasError) {
                                  return Center(
                                      child: Text(
                                          'Error: ${transactionSnapshot.error}'));
                                }

                                if (!transactionSnapshot.hasData ||
                                    transactionSnapshot.data!.docs.isEmpty) {
                                  return const Center(
                                      child: Text(
                                    'No transactions found',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 18),
                                  ));
                                }

                                final transactions = transactionSnapshot
                                    .data!.docs
                                    .map((doc) =>
                                        doc.data() as Map<String, dynamic>)
                                    .toList();

                                return ListView.builder(
                                  itemCount: transactions.length,
                                  itemBuilder: (context, index) {
                                    var transaction = transactions[index];
                                    return _buildTransaction(
                                      transaction['description'] ?? 'Unknown',
                                      transaction['amount'] ?? '\$0.00',
                                      transaction['timestamp'] ??
                                          'Unknown date',
                                      transaction['type'] == 'income'
                                          ? Colors.green
                                          : Colors.red,
                                    );
                                  },
                                );
                              },
                            )
                          : StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('transactions')
                                  .where('userId', isEqualTo: user.uid)
                                  .where('status', isEqualTo: 'pending')
                                  .orderBy('timestamp', descending: true)
                                  .snapshots(),
                              builder: (context, transactionSnapshot) {
                                if (transactionSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }

                                if (transactionSnapshot.hasError) {
                                  return Center(
                                      child: Text(
                                          'Error: ${transactionSnapshot.error}'));
                                }

                                if (!transactionSnapshot.hasData ||
                                    transactionSnapshot.data!.docs.isEmpty) {
                                  return const Center(
                                      child: Text(
                                    'No transactions',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 18),
                                  ));
                                }

                                final transactions = transactionSnapshot
                                    .data!.docs
                                    .map((doc) =>
                                        doc.data() as Map<String, dynamic>)
                                    .toList();

                                return ListView.builder(
                                  itemCount: transactions.length,
                                  itemBuilder: (context, index) {
                                    var documentId = transactionSnapshot
                                        .data!.docs[index].id;
                                    var transaction = transactions[index];
                                    return _buildPendingTransaction(
                                      documentId,
                                      transaction['description'] ?? 'Unknown',
                                      transaction['amount'] ?? '\$0.00',
                                      transaction['timestamp'] ??
                                          'Unknown date',
                                      () {
                                        print('Oloh button pressed!');
                                      },
                                    );
                                  },
                                );
                              },
                            )),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.teal.shade100,
          child: Icon(icon, color: Colors.teal, size: 30),
        ),
        const SizedBox(height: 10),
        Text(label, style: const TextStyle(fontSize: 16, color: Colors.teal)),
      ],
    );
  }

  Widget _buildTab(String label, int index) {
    bool isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.teal : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildTransaction(
      String name, double amount, Timestamp date, Color amountColor) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date.toDate());
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey.shade200,
        child: Text(name[0],
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      title: Text(name,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      subtitle: Text(formattedDate, style: const TextStyle(color: Colors.grey)),
      trailing: Text(
        '\$${amount.toStringAsFixed(1)}',
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: amountColor),
      ),
    );
  }

  Widget _buildPendingTransaction(String uid, String name, double amount,
      Timestamp date, VoidCallback onButtonPressed) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date.toDate());

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey.shade200,
        child: Text(name[0],
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      title: Text(name,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      subtitle: Text(formattedDate, style: const TextStyle(color: Colors.grey)),
      trailing: Row(
        mainAxisSize:
            MainAxisSize.min, // Ensures the row doesn't take full width
        children: [
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BillDetailsScreen(
                    uid: uid,
                    name: name,
                    amount: amount,
                    date: formattedDate,
                  ),
                ),
              );
            }, // Callback for button press
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal, // Button color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30), // Rounded corners
              ),
            ),
            child: const Text(
              'Төлөх',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

void main() => runApp(MaterialApp(
      home: DashboardPage(),
    ));
