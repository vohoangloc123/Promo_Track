import 'package:shared_preferences/shared_preferences.dart';

class DiscountUtils {
  // Phương thức tính toán chiết khấu
  static Future<double> calculateDiscount({
    required double price,
    required double discountPercentage,
    required bool isDiscountAppliedDirectly,
  }) async {
    if (price <= 0 || discountPercentage < 0) {
      throw ArgumentError('Giá tiền và chiết khấu phải hợp lệ.');
    }

    double discountedPrice;
    if (isDiscountAppliedDirectly) {
      discountedPrice = price * (1 - discountPercentage / 100);
    } else {
      // Quy đổi thành giảm giá cho lần sau (thực tế không áp dụng ngay, chỉ ghi nhận)
      discountedPrice = price;
    }

    // Lưu lịch sử
    await _saveHistory(price, discountPercentage, isDiscountAppliedDirectly);

    return discountedPrice;
  }

  // Phương thức lưu lịch sử vào SharedPreferences
  static Future<void> _saveHistory(double price, double discountPercentage, bool isDiscountAppliedDirectly) async {
    final prefs = await SharedPreferences.getInstance();

    // Lưu thông tin lịch sử
    List<String> history = prefs.getStringList('purchase_history') ?? [];
    String historyEntry = 'Price: $price, Discount: $discountPercentage%, Applied Directly: $isDiscountAppliedDirectly';
    history.add(historyEntry);
    await prefs.setStringList('purchase_history', history);

    // Lưu thông tin chiết khấu
    await prefs.setString('last_discount', '$discountPercentage%');
    await prefs.setBool('last_discount_applied_directly', isDiscountAppliedDirectly);
  }
}
