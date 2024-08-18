import 'package:flutter/material.dart';
import 'package:promo_track/utils/colors.dart';
import 'package:promo_track/widgets/custom_button.dart';

class CustomButtonGroup extends StatelessWidget {
  final VoidCallback onCalculateDiscount;
  final VoidCallback onGenerateRandomValues;
  final VoidCallback onShowPurchaseHistory;

  const CustomButtonGroup({
    Key? key,
    required this.onCalculateDiscount,
    required this.onGenerateRandomValues,
    required this.onShowPurchaseHistory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          CustomButton(
            onPressed: onCalculateDiscount,
            backgroundColor: AppColors.primaryColor,
            textColor: AppColors.textColor,
            text: 'Calculate Discount',
          ),
          const SizedBox(height: 10),
          CustomButton(
            onPressed: onGenerateRandomValues,
            backgroundColor: AppColors.primaryColor,
            textColor: AppColors.textColor,
            text: 'Generate Random Values',
          ),
          const SizedBox(height: 10),
          CustomButton(
            onPressed: onShowPurchaseHistory,
            backgroundColor: AppColors.primaryColor,
            textColor: AppColors.textColor,
            text: 'Show Purchase History',
          ),
        ],
      ),
    );
  }
}
