import 'package:flutter/material.dart';
import 'package:promo_track/utils/colors.dart';
import 'package:promo_track/utils/random_utils.dart';
import 'package:promo_track/widgets/custom_button.dart';
import 'package:promo_track/widgets/custom_button_group.dart';
import 'package:promo_track/widgets/custom_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

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
  final _dateTimeController = TextEditingController();
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

  void _setCurrentDateTime() {
    // Get current date and time
    DateTime now = DateTime.now();
    String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    // Set the formatted date and time to the controller
    _dateTimeController.text = formattedDateTime;
  }

  void _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();

    // Lấy ID hiện tại từ SharedPreferences
    int currentId = prefs.getInt('purchase_id') ?? 0;

    // Tăng giá trị ID cho lần mua tiếp theo
    currentId++;
    DateTime now = DateTime.now();
    String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm').format(now);
    // Lưu thông tin lịch sử
    List<String> history = prefs.getStringList('purchase_history') ?? [];
    String historyEntry =
        'ID: $currentId, DateTime: $formattedDateTime, Product name: ${_productNameController.text}, Quantity: ${_quantityController.text}, Price: ${_priceController.text}, Discount: ${_discountController.text}, Applied Directly: ${_isDiscountAppliedDirectly},  Payment Method: $_selectedPaymentMethod';
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
        title: const Text(
          'Checkout Screen',
          style: TextStyle(
            fontSize: 24,
            color: AppColors.textColor, // Màu chữ tiêu đề
          ),
        ),
        backgroundColor: AppColors.primaryColor, // Màu nền của AppBar
        iconTheme: const IconThemeData(
          color: AppColors.textColor, // Màu của các icon trong AppBar
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primaryColor, AppColors.secondaryColor],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 10),
              CustomTextfield(
                onPressed: _productNameController,
                color: AppColors.textColor,
                textLabel: const Text('Product Name'),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _quantityController,
                      decoration: InputDecoration(
                        labelText: 'Quantity',
                        labelStyle: const TextStyle(color: AppColors.textColor),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.white), // Màu viền khi không focus
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8.0),
                      ),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.left,
                      style: const TextStyle(color: AppColors.textColor),
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
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      int currentQuantity =
                          int.tryParse(_quantityController.text) ?? 0;
                      _quantityController.text =
                          (currentQuantity + 1).toString();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              CustomTextfield(
                onPressed: _phoneController,
                color: AppColors.textColor,
                textLabel: const Text('Phone Number'),
              ),
              const SizedBox(height: 10),
              CustomTextfield(
                onPressed: _priceController,
                color: AppColors.textColor,
                textLabel: const Text('Price'),
              ),
              const SizedBox(height: 10),
              CustomTextfield(
                onPressed: _discountController,
                color: AppColors.textColor,
                textLabel: const Text('Discount (%)'),
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
                  labelStyle: const TextStyle(color: AppColors.textColor),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 8.0),
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
                      style: const TextStyle(
                          fontSize: 16.0, color: AppColors.textColor),
                    ),
                  );
                }).toList(),
                style:
                    const TextStyle(fontSize: 16.0, color: AppColors.textColor),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
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
                  const Text(
                    'Direct deduction from price',
                    style: TextStyle(color: AppColors.textColor),
                  ),
                ],
              ),
              Text(
                'The amount after calculation.: \$${_calculatedPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor),
              ),
              const SizedBox(height: 10),
              CustomButtonGroup(
                onCalculateDiscount: _calculateDiscount,
                onGenerateRandomValues: _generateRandomValues,
                onShowPurchaseHistory: _showPurchaseHistory,
              )
            ],
          ),
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
    if (discountPercentage > 100) {
      _showErrorDialog('Chiết khấu không thể lớn hơn 100%.');
      return;
    }
    if (_quantityController.text.isEmpty) {
      _showErrorDialog('Vui lòng nhập số lượng.');
      return;
    } else if (int.tryParse(_quantityController.text) == 0) {
      _showErrorDialog('Số lượng phải lớn hơn 0.');
      return;
    } else if (int.tryParse(_quantityController.text) == null) {
      _showErrorDialog('Số lượng phải là số.');
      return;
    }
    if (_productNameController.text.isEmpty) {
      _showErrorDialog('Vui lòng nhập tên sản phẩm.');
      return;
    }
    if (_phoneController.text.isEmpty) {
      _showErrorDialog('Vui lòng nhập số điện thoại.');
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
