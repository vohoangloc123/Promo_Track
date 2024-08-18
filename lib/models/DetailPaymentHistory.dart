class DetailPaymentHistory {
  final int id;
  final String productName;
  final String quantity;
  final String price;
  final String discount;
  final bool appliedDirectly;

  DetailPaymentHistory({
    required this.id,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.discount,
    required this.appliedDirectly,
  });

  // Phương thức toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productName': productName,
      'quantity': quantity,
      'price': price,
      'discount': discount,
      'appliedDirectly': appliedDirectly,
    };
  }

  // Factory method để tạo đối tượng từ JSON
  factory DetailPaymentHistory.fromJson(Map<String, dynamic> json) {
    return DetailPaymentHistory(
      id: json['id'],
      productName: json['productName'],
      quantity: json['quantity'],
      price: json['price'],
      discount: json['discount'],
      appliedDirectly: json['appliedDirectly'],
    );
  }
}
