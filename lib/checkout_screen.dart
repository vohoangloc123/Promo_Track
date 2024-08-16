import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // Các biến cần thiết để lưu thông tin đơn hàng và chiết khấu
  double totalAmount = 0.0; // Tổng giá trị đơn hàng
  double discountPercentage = 10.0; // Phần trăm chiết khấu (có thể thay đổi)
  bool isDirectDiscount = true; // Loại chiết khấu (trực tiếp hoặc quy đổi)

  // Controller để quản lý TextField
  final TextEditingController _totalAmountController = TextEditingController();
  final TextEditingController _discountPercentageController = TextEditingController();

  late Database _database;

  @override
  void initState() {
    super.initState();
    // Khởi tạo controller với giá trị mặc định
    _totalAmountController.text = totalAmount.toString();
    _discountPercentageController.text = discountPercentage.toString();
  }

  @override
  void dispose() {
    // Giải phóng controller khi không còn cần thiết
    _totalAmountController.dispose();
    _discountPercentageController.dispose();
    super.dispose();
  }


  // Hàm chèn đơn hàng vào bảng orders
  Future<int> _insertOrder() async {
    return await _database.insert(
      'orders',
      {
        'customer_id': 1, // Thay đổi theo nhu cầu thực tế
        'order_date': DateTime.now().toIso8601String(),
        'total_amount': totalAmount,
        'discount_applied': isDirectDiscount ? totalAmount * (discountPercentage / 100) : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Hàm chèn chiết khấu vào bảng discounts
  Future<int> _insertDiscount() async {
    return await _database.insert(
      'discounts',
      {
        'percentage': discountPercentage,
        'valid_from': DateTime.now().toIso8601String(),
        'valid_until': DateTime.now().add(Duration(days: 30)).toIso8601String(), // Ví dụ cho hạn sử dụng
        'is_applied_directly': isDirectDiscount ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Hàm chèn thông tin chiết khấu vào bảng order_discounts
  Future<void> _insertOrderDiscount(int orderId, int discountId) async {
    await _database.insert(
      'order_discounts',
      {
        'order_id': orderId,
        'discount_id': discountId,
        'applied_amount': totalAmount * (discountPercentage / 100),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Hàm chèn thông tin chiết khấu vào bảng discount_history
  Future<void> _insertDiscountHistory(int discountId, int orderId) async {
    await _database.insert(
      'discount_history',
      {
        'discount_id': discountId,
        'order_id': orderId,
        'applied_amount': totalAmount * (discountPercentage / 100),
        'date': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Cập nhật giá trị biến từ các controller
    double discountAmount = totalAmount * (discountPercentage / 100);
    double finalAmount = isDirectDiscount
        ? totalAmount - discountAmount
        : totalAmount;

    return Scaffold(
      appBar: AppBar(title: Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trường nhập liệu cho tổng giá trị đơn hàng
            TextField(
              controller: _totalAmountController,
              decoration: InputDecoration(labelText: 'Total Amount'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  totalAmount = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            SizedBox(height: 10),
            // Trường nhập liệu cho phần trăm chiết khấu
            TextField(
              controller: _discountPercentageController,
              decoration: InputDecoration(labelText: 'Discount Percentage'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  discountPercentage = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            SizedBox(height: 10),
            // Switch để chọn loại chiết khấu
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Apply Discount Directly'),
                Switch(
                  value: isDirectDiscount,
                  onChanged: (value) {
                    setState(() {
                      isDirectDiscount = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            // Hiển thị số tiền chiết khấu
            Text('Discount: \$${discountAmount.toStringAsFixed(2)} (${discountPercentage.toStringAsFixed(2)}%)'),
            SizedBox(height: 10),
            // Hiển thị số tiền cuối cùng sau khi áp dụng chiết khấu
            Text('Final Amount: \$${finalAmount.toStringAsFixed(2)}'),
            SizedBox(height: 20),
            // Nút xác nhận đơn hàng
            ElevatedButton(
              onPressed: () async {
                int orderId = await _insertOrder();
                int discountId = await _insertDiscount();
                await _insertOrderDiscount(orderId, discountId);
                await _insertDiscountHistory(discountId, orderId);

                // Có thể hiển thị thông báo hoặc chuyển trang sau khi lưu thành công
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Order confirmed and saved')),
                );

                // Quay lại màn hình trước hoặc thực hiện các thao tác khác sau khi lưu thành công
                Navigator.pop(context);
              },
              child: Text('Confirm Order'),
            ),
          ],
        ),
      ),
    );
  }
}
