class PaymentHistory {
  final int id;
  final DateTime dateTime;
  final String productName;
  final int quantity;
  final double price;
  final double discount;
  final bool appliedDirectly;
  final String paymentMethod;

  PaymentHistory({
    required this.id,
    required this.dateTime,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.discount,
    required this.appliedDirectly,
    required this.paymentMethod,
  });

  // Thêm phương thức toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dateTime': dateTime.toIso8601String(),
      'productName': productName,
      'quantity': quantity,
      'price': price,
      'discount': discount,
      'appliedDirectly': appliedDirectly,
      'paymentMethod': paymentMethod,
    };
  }

  // Nếu cần, bạn có thể thêm một factory để tạo từ JSON
  factory PaymentHistory.fromJson(Map<String, dynamic> json) {
    return PaymentHistory(
      id: json['id'],
      dateTime: DateTime.parse(json['dateTime']),
      productName: json['productName'],
      quantity: json['quantity'],
      price: json['price'],
      discount: json['discount'],
      appliedDirectly: json['appliedDirectly'],
      paymentMethod: json['paymentMethod'],
    );
  }
}
