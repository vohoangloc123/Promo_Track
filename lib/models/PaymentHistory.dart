class PaymentHistory {
  final int id;
  final DateTime dateTime;
  final String phoneNumber;
  final String paymentMethod;

  PaymentHistory({
    required this.id,
    required this.dateTime,
    required this.phoneNumber,
    required this.paymentMethod,
  });

  // Thêm phương thức toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dateTime': dateTime.toIso8601String(),
      'phoneNumber': phoneNumber,
      'paymentMethod': paymentMethod,
    };
  }

  // Nếu cần, bạn có thể thêm một factory để tạo từ JSON
  factory PaymentHistory.fromJson(Map<String, dynamic> json) {
    return PaymentHistory(
      id: json['id'],
      dateTime: DateTime.parse(json['dateTime']),
      phoneNumber: json['phoneNumber'],
      paymentMethod: json['paymentMethod'],
    );
  }
}
