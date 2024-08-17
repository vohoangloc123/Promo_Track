class DiscountHistory {
  final int id;
  final int discountId;
  final int orderId;
  final double appliedAmount;
  final DateTime date;

  DiscountHistory({
    required this.id,
    required this.discountId,
    required this.orderId,
    required this.appliedAmount,
    required this.date,
  });

  factory DiscountHistory.fromMap(Map<String, dynamic> map) {
    return DiscountHistory(
      id: map['id'],
      discountId: map['discount_id'],
      orderId: map['order_id'],
      appliedAmount: map['applied_amount'].toDouble(),
      date: DateTime.parse(map['date']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'discount_id': discountId,
      'order_id': orderId,
      'applied_amount': appliedAmount,
      'date': date.toIso8601String(),
    };
  }
}
