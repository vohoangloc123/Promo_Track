import 'dart:math';

class RandomUtils {
  // Phương thức tạo giá trị ngẫu nhiên
  static Map<String, String> generateRandomValues() {
    final random = Random();

    final randomPhone = '0${random.nextInt(900000000) + 100000000}';
    final randomPrice = (random.nextInt(100000) + 1000).toString();
    final randomDiscount = '${random.nextInt(50) + 1}';

    return {
      'phone': randomPhone,
      'price': randomPrice,
      'discount': randomDiscount,
    };
  }
}
