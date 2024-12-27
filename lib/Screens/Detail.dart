import 'package:orlogo/Screens/Details.dart';
import 'package:orlogo/Widgets/bottomnav.dart';
import 'package:flutter/material.dart';

class BillDetailsScreen extends StatelessWidget {
  final String uid;
  final String name;
  final double amount;
  final String date;
  const BillDetailsScreen({
    super.key,
    required this.uid,
    required this.name,
    required this.amount,
    required this.date,
  });
  @override
  Widget build(BuildContext context) {
    final double rate = amount / 10;
    final double all = rate + amount;
    return Scaffold(
      backgroundColor: Colors.white, // Background color
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: AppBar(
            backgroundColor: Colors.teal,
            elevation: 0,
            title: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Bill Details',
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
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.play_circle_filled,
                            size: 40, color: Colors.red),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              date,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Үнэ', style: TextStyle(fontSize: 16)),
                        Text('\$ $amount',
                            style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Хураамж', style: TextStyle(fontSize: 16)),
                        Text('\$ $rate', style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Нийт',
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
            ),
            const SizedBox(height: 20),
            const Text('Төлбөрийн хэрэгсэл сонго',
                style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            const PaymentOptionTile(
              label: 'Дебит карт',
              icon: Icons.credit_card,
              selected: true,
            ),
            const PaymentOptionTile(
              label: 'Paypal',
              icon: Icons.payment,
              selected: false,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BillDetailsorlogoroveScreen(
                      uid: uid,
                      name: name,
                      amount: amount,
                      date: date,
                      rate: rate,
                      all: all,
                      payment: 'Card',
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Төлөх',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentOptionTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;

  const PaymentOptionTile({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: selected
          ? const Icon(Icons.check_circle, color: Colors.green)
          : const Icon(Icons.radio_button_unchecked),
      onTap: () {},
    );
  }
}
