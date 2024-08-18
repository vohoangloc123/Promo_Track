import 'package:flutter/material.dart';
import 'package:promo_track/utils/colors.dart';
import 'custom_button_group.dart'; // Import nếu CustomButtonGroup ở file khác
import 'custom_textfield.dart'; // Import nếu CustomTextfield ở file khác

class CustomForm extends StatelessWidget {
  final TextEditingController productNameController;
  final TextEditingController quantityController;
  final TextEditingController phoneController;
  final TextEditingController priceController;
  final TextEditingController discountController;
  final String? selectedPaymentMethod;
  final bool isDiscountAppliedDirectly;
  final double calculatedPrice;
  final VoidCallback calculateDiscount;
  final VoidCallback generateRandomValues;
  final VoidCallback showPurchaseHistory;

  const CustomForm({
    Key? key,
    required this.productNameController,
    required this.quantityController,
    required this.phoneController,
    required this.priceController,
    required this.discountController,
    required this.selectedPaymentMethod,
    required this.isDiscountAppliedDirectly,
    required this.calculatedPrice,
    required this.calculateDiscount,
    required this.generateRandomValues,
    required this.showPurchaseHistory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 10),
          CustomTextfield(
            onPressed: productNameController,
            color: AppColors.textColor,
            textLabel: const Text('Product Name'),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: quantityController,
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
                icon: const Icon(Icons.remove),
                onPressed: () {
                  int currentQuantity =
                      int.tryParse(quantityController.text) ?? 0;
                  if (currentQuantity > 0) {
                    quantityController.text = (currentQuantity - 1).toString();
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  int currentQuantity =
                      int.tryParse(quantityController.text) ?? 0;
                  quantityController.text = (currentQuantity + 1).toString();
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          CustomTextfield(
            onPressed: phoneController,
            color: AppColors.textColor,
            textLabel: const Text('Phone Number'),
          ),
          const SizedBox(height: 10),
          CustomTextfield(
            onPressed: priceController,
            color: AppColors.textColor,
            textLabel: const Text('Price'),
          ),
          const SizedBox(height: 10),
          CustomTextfield(
            onPressed: discountController,
            color: AppColors.textColor,
            textLabel: const Text('Discount (%)'),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: selectedPaymentMethod,
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
            style: const TextStyle(fontSize: 16.0, color: AppColors.textColor),
            icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
            isExpanded: true,
          ),
          Row(
            children: <Widget>[
              Checkbox(
                value: isDiscountAppliedDirectly,
                onChanged: (value) {
                  // Handle checkbox change
                },
              ),
              const Text(
                'Direct deduction from price',
                style: TextStyle(color: AppColors.textColor),
              ),
            ],
          ),
          Text(
            'The amount after calculation: \$${calculatedPrice.toStringAsFixed(2)}',
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor),
          ),
          const SizedBox(height: 10),
          CustomButtonGroup(
            onCalculateDiscount: calculateDiscount,
            onGenerateRandomValues: generateRandomValues,
            onShowPurchaseHistory: showPurchaseHistory,
          ),
        ],
      ),
    );
  }
}
