class OrderDiscount {
  final int id;
  final int orderId;
  final int discountId;
  final double appliedAmount;

  OrderDiscount({
    required this.id,
    required this.orderId,
    required this.discountId,
    required this.appliedAmount,
  });

  factory OrderDiscount.fromMap(Map<String, dynamic> map) {
    return OrderDiscount(
      id: map['id'],
      orderId: map['order_id'],
      discountId: map['discount_id'],
      appliedAmount: map['applied_amount'].toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'order_id': orderId,
      'discount_id': discountId,
      'applied_amount': appliedAmount,
    };
  }
}
