import 'package:flutter/material.dart';
import 'package:promo_track/utils/colors.dart';
import 'package:promo_track/utils/random_utils.dart';
import 'package:promo_track/widgets/custom_form.dart';
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

  @override
  void initState() {
    super.initState();
    _setCurrentDateTime();
  }

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
    List<String> history = prefs.getStringList('payment_history') ?? [];
    List<String> detailHistory =
        prefs.getStringList('detail_payment_history') ?? [];
    String historyEntry =
        'ID: $currentId, DateTime: $formattedDateTime, Phone Number: ${_phoneController.text},  Payment Method: $_selectedPaymentMethod';
    history.add(historyEntry);
    await prefs.setStringList('payment_history', history);
    String detailHistoryEntry =
        'ID: $currentId, Product name: ${_productNameController.text}, Quantity: ${_quantityController.text}, Price: ${_priceController.text}, Discount: ${_discountController.text}, Applied Directly: ${_isDiscountAppliedDirectly}';
    detailHistory.add(detailHistoryEntry);
    await prefs.setStringList('detail_payment_history', detailHistory);
    // Lưu ID hiện tại để sử dụng cho lần tiếp theo
    await prefs.setInt('purchase_id', currentId);

    // Hiển thị thông báo Snackbar
    print("Saved History: $historyEntry");
    print("Saved Detail History: $detailHistoryEntry");
    // Lưu thông tin chiết khấu
    // await prefs.setString('last_discount', _discountController.text);
    // await prefs.setBool(
    //     'last_discount_applied_directly', _isDiscountAppliedDirectly);
  }

  void _checkPhoneNumber() async {}

  void _calculateDiscount() {
    final price = double.tryParse(_priceController.text) ?? 0;
    final discountPercentage = double.tryParse(_discountController.text) ?? 0;
    print('Check discount: $_isDiscountAppliedDirectly');
    print('Price: $price');

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
    double quantity = _quantityController.text.isEmpty
        ? 0
        : double.parse(_quantityController.text);
    double discountedPrice;
    print('Discount Percentage: $discountPercentage');
    if (_isDiscountAppliedDirectly) {
      discountedPrice = price * (1 - (discountPercentage / 100));
    } else {
      discountedPrice =
          price; // Quy đổi thành giảm giá cho lần sau (chỉ ghi nhận)
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
        child: Column(
          children: <Widget>[
            Expanded(
              child: CustomForm(
                productNameController: _productNameController,
                quantityController: _quantityController,
                phoneController: _phoneController,
                priceController: _priceController,
                discountController: _discountController,
                selectedPaymentMethod: _selectedPaymentMethod,
                calculatedPrice: _calculatedPrice,
                isDiscountAppliedDirectly: _isDiscountAppliedDirectly,
                onDiscountAppliedDirectlyChanged: (value) {
                  setState(() {
                    _isDiscountAppliedDirectly = value;
                    print(
                        'Discount Applied Directly là: $_isDiscountAppliedDirectly');
                  });
                }, //
                calculateDiscount: _calculateDiscount,
                generateRandomValues: _generateRandomValues,
                showPurchaseHistory: _showPurchaseHistory,
                checkPhoneNumber:
                    _checkPhoneNumber, // Thêm nút kiểm tra số điện thoại
              ),
            ),
          ],
        ),
      ),
    );
  }
}
