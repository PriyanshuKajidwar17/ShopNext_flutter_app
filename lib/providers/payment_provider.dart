import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class PaymentModel {
  final String paymentId;
  final String orderId;
  final double amount;
  final String method;
  final String status;
  final DateTime dateTime;
  final String? upiId;
  final String? cardLast4;

  PaymentModel({
    required this.paymentId,
    required this.orderId,
    required this.amount,
    required this.method,
    required this.status,
    required this.dateTime,
    this.upiId,
    this.cardLast4,
  });

  Map<String, dynamic> toMap() {
    return {
      'paymentId': paymentId,
      'orderId': orderId,
      'amount': amount,
      'method': method,
      'status': status,
      'dateTime': dateTime.toIso8601String(),
      'upiId': upiId,
      'cardLast4': cardLast4,
    };
  }
}

class PaymentProvider with ChangeNotifier {
  final Box _paymentBox = Hive.box('paymentBox');

  List<Map<String, dynamic>> get payments =>
      _paymentBox.values.cast<Map<String, dynamic>>().toList().reversed.toList();

  void addPayment(PaymentModel payment) {
    _paymentBox.add(payment.toMap());
    notifyListeners();
  }
}
