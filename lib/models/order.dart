class Order {
  final int id;
  final int customerId;
  final DateTime orderDate;
  final double totalAmount;
  final double discountApplied;

  Order({
    required this.id,
    required this.customerId,
    required this.orderDate,
    required this.totalAmount,
    required this.discountApplied,
  });

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      customerId: map['customer_id'],
      orderDate: DateTime.parse(map['order_date']),
      totalAmount: map['total_amount'].toDouble(),
      discountApplied: map['discount_applied'].toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customer_id': customerId,
      'order_date': orderDate.toIso8601String(),
      'total_amount': totalAmount,
      'discount_applied': discountApplied,
    };
  }
}
