import 'dart:math';

import 'package:flutter/material.dart';
import 'package:promo_track/utils/random_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _phoneController = TextEditingController();
  final _priceController = TextEditingController();
  final _discountController = TextEditingController();
  final _productNameController = TextEditingController();
  final _quantityController = TextEditingController();
  bool _isDiscountAppliedDirectly = true;
  String _selectedPaymentMethod = 'Cash';
  double _calculatedPrice = 0; // Biến lưu trữ số tiền đã tính toán
  void _showPurchaseHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('purchase_history') ?? [];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Lịch sử mua'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: history.map((entry) => Text(entry)).toList(),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _generateRandomValues() {
    // Random instance
    final randomValues = RandomUtils.generateRandomValues();

    // Cập nhật TextField với giá trị ngẫu nhiên
    setState(() {
      _phoneController.text = randomValues['phone'] ?? '';
      _priceController.text = randomValues['price'] ?? '';
      _discountController.text = randomValues['discount'] ?? '';
    });
  }

  void _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();

    // Lấy ID hiện tại từ SharedPreferences
    int currentId = prefs.getInt('purchase_id') ?? 0;

    // Tăng giá trị ID cho lần mua tiếp theo
    currentId++;

    // Lưu thông tin lịch sử
    List<String> history = prefs.getStringList('purchase_history') ?? [];
    String historyEntry =
        'ID: $currentId, Product name: ${_productNameController.text}, Quantity: ${_quantityController.text}, Price: ${_priceController.text}, Discount: ${_discountController.text}, Applied Directly: ${_isDiscountAppliedDirectly},  Payment Method: $_selectedPaymentMethod';
    history.add(historyEntry);
    await prefs.setStringList('purchase_history', history);

    // Lưu ID hiện tại để sử dụng cho lần tiếp theo
    await prefs.setInt('purchase_id', currentId);

    // Hiển thị thông báo Snackbar
    print("Saved History: $historyEntry");

    // Lưu thông tin chiết khấu
    await prefs.setString('last_discount', _discountController.text);
    await prefs.setBool(
        'last_discount_applied_directly', _isDiscountAppliedDirectly);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _productNameController,
              decoration: InputDecoration(
                labelText: 'Product Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _quantityController,
                    decoration: InputDecoration(
                      labelText: 'Quantity',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 8.0),
                    ),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.left,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    int currentQuantity =
                        int.tryParse(_quantityController.text) ?? 0;
                    if (currentQuantity > 0) {
                      _quantityController.text =
                          (currentQuantity - 1).toString();
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    int currentQuantity =
                        int.tryParse(_quantityController.text) ?? 0;
                    _quantityController.text = (currentQuantity + 1).toString();
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _discountController,
              decoration: InputDecoration(
                labelText: 'Discount',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedPaymentMethod,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedPaymentMethod = newValue!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Payment Method',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              ),
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              items: <String>[
                'Cash',
                'Credit Card',
                'Debit Card',
                'Mobile Payment'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                  ),
                );
              }).toList(),
              style: TextStyle(fontSize: 16.0, color: Colors.black),
              icon: Icon(Icons.arrow_drop_down, color: Colors.black),
              isExpanded: true,
            ),
            Row(
              children: <Widget>[
                Checkbox(
                  value: _isDiscountAppliedDirectly,
                  onChanged: (value) {
                    setState(() {
                      _isDiscountAppliedDirectly = value ?? true;
                    });
                  },
                ),
                Text('Trừ trực tiếp'),
              ],
            ),
            ElevatedButton(
              onPressed: _calculateDiscount,
              child: Text('Tính tiền'),
            ),
            ElevatedButton(
              onPressed: _generateRandomValues,
              child: Text('Generate Random Values'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showPurchaseHistory,
              child: Text('Xem lịch sử mua'),
            ),
            Text(
              'Số tiền sau khi tính toán: \$${_calculatedPrice.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _calculateDiscount() {
    final price = double.tryParse(_priceController.text) ?? 0;
    final discountPercentage = double.tryParse(_discountController.text) ?? 0;

    if (price <= 0 || discountPercentage < 0) {
      _showErrorDialog('Vui lòng nhập giá tiền và chiết khấu hợp lệ.');
      return;
    }

    double discountedPrice;
    if (_isDiscountAppliedDirectly) {
      discountedPrice = price * (1 - discountPercentage / 100);
    } else {
      // Quy đổi thành giảm giá cho lần sau (thực tế không áp dụng ngay, chỉ ghi nhận)
      discountedPrice = price;
    }
    _saveHistory();
    setState(() {
      _calculatedPrice = discountedPrice; // Cập nhật giá tiền đã tính toán
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Lỗi'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
