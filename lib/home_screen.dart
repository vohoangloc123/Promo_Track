import 'package:flutter/material.dart';
import 'package:promo_track/utils/colors.dart';
import 'package:promo_track/widgets/custom_button.dart';
import 'package:promo_track/widgets/payment_history_list.dart';
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
    final isWideScreen = MediaQuery.of(context).size.width > 600;

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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SizedBox(
              width: double.infinity, // Đảm bảo chiều rộng bằng màn hình
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 200,
                    color: const Color.fromARGB(100, 255, 255, 255),
                  ),
                  const SizedBox(height: 40),
                  isWideScreen
                      ? LayoutBuilder(
                          builder: (context, constraints) {
                            final buttonPadding = constraints.maxWidth > 600
                                ? const EdgeInsets.symmetric(horizontal: 100.0)
                                : const EdgeInsets.all(16.0);

                            return Padding(
                              padding: buttonPadding,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: CustomButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CheckoutScreen()),
                                        );
                                      },
                                      backgroundColor: AppColors.primaryColor,
                                      textColor: AppColors.textColor,
                                      text: 'Add Order',
                                    ),
                                  ),
                                  const SizedBox(
                                      width: 10), // Khoảng cách giữa các nút
                                  Expanded(
                                    child: CustomButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const PaymentHistoryList()),
                                        );
                                      },
                                      backgroundColor: AppColors.primaryColor,
                                      textColor: AppColors.textColor,
                                      text: 'View Purchase History',
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : Column(
                          children: [
                            CustomButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CheckoutScreen()),
                                );
                              },
                              backgroundColor: AppColors.primaryColor,
                              textColor: AppColors.textColor,
                              text: 'Add Order',
                            ),
                            const SizedBox(
                                height: 10), // Khoảng cách giữa các nút
                            CustomButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const PaymentHistoryList()),
                                );
                              },
                              backgroundColor: AppColors.primaryColor,
                              textColor: AppColors.textColor,
                              text: 'View Purchase History',
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
