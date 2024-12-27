import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:orlogo/model/transaction.dart';

class TransactionService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add a new transaction and update the user's balance
  Future<void> addTransaction({
    required String userId,
    required double amount,
    required String type, // "income" or "expenses"
    required String status, // "pending" or "success"
    required String description,
  }) async {
    try {
      // Get a reference to the user's document
      DocumentReference userDoc = _db.collection('users').doc(userId);

      await _db.runTransaction((transaction) async {
        DocumentSnapshot userSnapshot = await transaction.get(userDoc);

        if (!userSnapshot.exists) {
          throw Exception('User not found');
        }

        // Get the user's current balance
        double currentBalance = userSnapshot['balance'] ?? 0.0;
        double currentIncome = userSnapshot['income'] ?? 0.0;
        double currentExpenses = userSnapshot['expenses'] ?? 0.0;

        // Calculate the new balance based on the transaction type
        double newBalance;
        double newIncome = currentIncome; // Initialize to currentIncome
        double newExpenses = currentExpenses; // Initialize to currentExpenses
        if (type == 'income') {
          newBalance = currentBalance + amount;
          newIncome = currentIncome + amount;
        } else if (type == 'expenses') {
          newBalance = currentBalance - amount;
          newExpenses = currentExpenses + amount;
        } else {
          throw Exception('Invalid transaction type');
        }

        // Update the user's balance
        transaction.update(userDoc, {
          'balance': newBalance,
          'income': newIncome,
          'expenses': newExpenses,
        });

        // Add the new transaction to the 'transactions' collection
        await _db.collection('transactions').add({
          'userId': userId,
          'amount': amount,
          'type': type,
          'status': status,
          'description': description,
          'timestamp': FieldValue.serverTimestamp(),
        });
      });
    } catch (e) {
      print("Error adding transaction: $e");
      rethrow; // Rethrow error after logging it
    }
  }

  // Get transaction history for a user
  Stream<List<Transaction>> getTransactionHistory(String userId) {
    return _db
        .collection('transactions') // Assuming global transactions collection
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'success') // Filter by userId
        .orderBy('timestamp', descending: true) // Sort by timestamp
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return []; // Return an empty list if no transactions
      }
      return snapshot.docs
          .map((doc) => Transaction.fromFirestore(
              doc)) // Map Firestore data to Transaction model
          .toList();
    });
  }

  Stream<List<Transaction>> getPendingTransactionHistory(String userId) {
    return _db
        .collection('transactions') // Assuming global transactions collection
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'pending') // Filter by userId
        .orderBy('timestamp', descending: true) // Sort by timestamp
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return []; // Return an empty list if no transactions
      }
      return snapshot.docs
          .map((doc) => Transaction.fromFirestore(
              doc)) // Map Firestore data to Transaction model
          .toList();
    });
  }

  Future<void> addOutcomeTransaction({
    required String userId,
    required double amount,
    required String type,
    required Timestamp date,
    required String status, // "pending" or "success"
    required String description,
  }) async {
    try {
      // Get a reference to the user's document
      DocumentReference userDoc = _db.collection('users').doc(userId);

      await _db.runTransaction((transaction) async {
        DocumentSnapshot userSnapshot = await transaction.get(userDoc);

        if (!userSnapshot.exists) {
          throw Exception('User not found');
        }

        // Get the user's current balance
        double currentBalance = userSnapshot['balance'] ?? 0.0;
        double currentIncome = userSnapshot['income'] ?? 0.0;
        double currentExpenses = userSnapshot['expenses'] ?? 0.0;

        // Calculate the new balance based on the transaction type
        double newBalance;
        double newIncome = currentIncome; // Initialize to currentIncome
        double newExpenses = currentExpenses; // Initialize to currentExpenses
        if (type == 'income') {
          newBalance = currentBalance + amount;
          newIncome = currentIncome + amount;
        } else if (type == 'expenses') {
          newBalance = currentBalance - amount;
          newExpenses = currentExpenses + amount;
        } else {
          throw Exception('Invalid transaction type');
        }

        // Update the user's balance
        transaction.update(userDoc, {
          'balance': newBalance,
          'income': newIncome,
          'expenses': newExpenses,
        });

        // Add the new transaction to the 'transactions' collection
        await _db.collection('transactions').add({
          'userId': userId,
          'amount': amount,
          'type': type,
          'status': status,
          'description': description,
          'timestamp': date,
        });
      });
    } catch (e) {
      print("Error adding transaction: $e");
      rethrow; // Rethrow error after logging it
    }
  }

  Future<void> addPayment(
      {required String userId,
      required String docId,
      required double amount}) async {
    try {
      // Get a reference to the user's document
      DocumentReference userDoc = _db.collection('users').doc(userId);

      await _db.runTransaction((transaction) async {
        DocumentSnapshot userSnapshot = await transaction.get(userDoc);

        if (!userSnapshot.exists) {
          throw Exception('User not found');
        }

        // Get the user's current balance
        double currentBalance = userSnapshot['balance'] ?? 0.0;
        double currentExpenses = userSnapshot['expenses'] ?? 0.0;

        // Calculate the new balance based on the transaction type
        double newBalance;
        double newExpenses = currentExpenses; // Initialize to currentExpenses

        newBalance = currentBalance - amount;
        newExpenses = currentExpenses + amount;

        // Update the user's balance
        transaction.update(userDoc, {
          'balance': newBalance,
          'expenses': newExpenses,
        });
        DocumentReference transactionDoc =
            _db.collection('transactions').doc(docId);

        // Fetch the transaction document
        DocumentSnapshot transactionSnapshot = await transactionDoc.get();

        // Check if the document exists
        if (transactionSnapshot.exists) {
          // Access the data from the document
          await transactionDoc.update({
            'status': 'success',
          });
        } else {
          print('Transaction not found with docId: $docId');
        }
      });
    } catch (e) {
      print("Error adding transaction: $e");
      rethrow; // Rethrow error after logging it
    }
  }
}
