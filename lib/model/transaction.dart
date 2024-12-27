import 'package:cloud_firestore/cloud_firestore.dart';

class Transaction {
  final String transactionId;
  final double amount;
  final String type; // "income" or "outcome"
  final String status;
  final String description;
  final Timestamp timestamp;

  Transaction({
    required this.transactionId,
    required this.amount,
    required this.type,
    required this.status,
    required this.description,
    required this.timestamp,
  });

  // Convert a Firestore document to a Transaction object
  factory Transaction.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Transaction(
      transactionId: doc.id,
      amount: data['amount'] ?? 0.0,
      type: data['type'] ?? '',
      status: data['status'] ?? '',
      description: data['description'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  // Convert a Transaction object to a map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'type': type,
      'status': status,
      'description': description,
      'timestamp': timestamp,
    };
  }
}
