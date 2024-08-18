import 'package:flutter/material.dart';
import 'package:promo_track/utils/colors.dart';
import 'package:promo_track/widgets/payment_list.dart';
import 'checkout_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Discount Management',
          style: TextStyle(
              fontSize: 24,
              color: AppColors.textColor), // Thay đổi màu chữ tiêu đề
        ),
        backgroundColor: AppColors.primaryColor, // Thay đổi màu nền của AppBar
        iconTheme: const IconThemeData(
          color: AppColors.textColor, // Thay đổi màu của các icon trong AppBar
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CheckoutScreen()),
                  );
                },
                child: const Text('Add Order'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PaymentHistoryList()),
                  );
                },
                child: const Text('View Purchase History'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
