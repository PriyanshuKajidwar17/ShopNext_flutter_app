class PaymentModel {
  final String paymentId;
  final String orderId;
  final double amount;
  final String method; // UPI / CARD / COD
  final String status; // SUCCESS / FAILED
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
}
