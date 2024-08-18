import 'package:flutter/material.dart';
import 'package:promo_track/utils/colors.dart';
import 'custom_button_group.dart'; // Import nếu CustomButtonGroup ở file khác
import 'custom_textfield.dart'; // Import nếu CustomTextfield ở file khác

class CustomForm extends StatefulWidget {
  final TextEditingController productNameController;
  final TextEditingController quantityController;
  final TextEditingController phoneController;
  final TextEditingController priceController;
  final TextEditingController discountController;
  final String? selectedPaymentMethod;
  final double calculatedPrice;
  final VoidCallback calculateDiscount;
  final VoidCallback generateRandomValues;
  final VoidCallback showPurchaseHistory;
  final VoidCallback checkPhoneNumber;
  final bool isDiscountAppliedDirectly; // Thêm thuộc tính này
  final ValueChanged<bool> onDiscountAppliedDirectlyChanged;
  const CustomForm({
    Key? key,
    required this.productNameController,
    required this.quantityController,
    required this.phoneController,
    required this.priceController,
    required this.discountController,
    required this.selectedPaymentMethod,
    required this.calculatedPrice,
    required this.calculateDiscount,
    required this.generateRandomValues,
    required this.showPurchaseHistory,
    required this.checkPhoneNumber,
    required this.isDiscountAppliedDirectly, // Thêm thuộc tính này
    required this.onDiscountAppliedDirectlyChanged,
  }) : super(key: key);

  @override
  _CustomFormState createState() => _CustomFormState();
}

class _CustomFormState extends State<CustomForm> {
  late bool _isDiscountAppliedDirectly; // Định nghĩa biến này

  @override
  void initState() {
    super.initState();
    _isDiscountAppliedDirectly = widget
        .isDiscountAppliedDirectly; // Sử dụng widget.isDiscountAppliedDirectly
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 10),
          CustomTextfield(
            onPressed: widget.productNameController,
            color: AppColors.textColor,
            textLabel: const Text('Product Name'),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: widget.quantityController,
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    labelStyle: const TextStyle(color: AppColors.textColor),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
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
                icon: const Icon(Icons.remove, color: Colors.white),
                onPressed: () {
                  int currentQuantity =
                      int.tryParse(widget.quantityController.text) ?? 0;
                  if (currentQuantity > 0) {
                    widget.quantityController.text =
                        (currentQuantity - 1).toString();
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  int currentQuantity =
                      int.tryParse(widget.quantityController.text) ?? 0;
                  widget.quantityController.text =
                      (currentQuantity + 1).toString();
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          CustomTextfield(
            onPressed: widget.phoneController,
            color: AppColors.textColor,
            textLabel: const Text('Phone Number'),
          ),
          const SizedBox(height: 10),
          CustomTextfield(
            onPressed: widget.priceController,
            color: AppColors.textColor,
            textLabel: const Text('Price'),
          ),
          const SizedBox(height: 10),
          CustomTextfield(
            onPressed: widget.discountController,
            color: AppColors.textColor,
            textLabel: const Text('Discount (%)'),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: widget.selectedPaymentMethod,
            onChanged: (String? newValue) {
              // Handle payment method change
            },
            decoration: InputDecoration(
              labelText: 'Payment Method',
              labelStyle: const TextStyle(color: AppColors.textColor),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(10.0),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            ),
            dropdownColor: AppColors.primaryColor,
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
            style: const TextStyle(fontSize: 16.0, color: AppColors.textColor),
            icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
            isExpanded: true,
          ),
          Row(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Checkbox(
                    value: _isDiscountAppliedDirectly,
                    onChanged: (value) {
                      setState(() {
                        _isDiscountAppliedDirectly = value ?? false;
                        widget.onDiscountAppliedDirectlyChanged(
                            _isDiscountAppliedDirectly);
                        print(
                            'Discount Applied Directly: $_isDiscountAppliedDirectly');
                      });
                    },
                  ),
                  const Text(
                    'Direct deduction from price',
                    style: TextStyle(color: AppColors.textColor),
                  ),
                ],
              ),
              const Text(
                'Direct deduction from price',
                style: TextStyle(color: AppColors.textColor),
              ),
            ],
          ),
          Text(
            'The amount after calculation: \$${widget.calculatedPrice.toStringAsFixed(2)}',
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor),
          ),
          const SizedBox(height: 10),
          CustomButtonGroup(
            onCheckPhoneNumber: widget.checkPhoneNumber,
            onCalculateDiscount: widget.calculateDiscount,
            onGenerateRandomValues: widget.generateRandomValues,
            onShowPurchaseHistory: widget.showPurchaseHistory,
          ),
        ],
      ),
    );
  }
}
