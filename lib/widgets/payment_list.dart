import 'package:flutter/material.dart';
import 'package:promo_track/models/PaymentHistory.dart';
import 'package:promo_track/utils/colors.dart';
import 'package:promo_track/widgets/purchased_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentHistoryList extends StatelessWidget {
  const PaymentHistoryList({super.key});

  Future<List<PaymentHistory>> _loadPaymentHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? historyStrings =
        prefs.getStringList('purchase_history') ?? [];

    return historyStrings.map((historyString) {
      // Tách chuỗi dữ liệu theo định dạng
      List<String> parts = historyString.split(', ');
      Map<String, dynamic> historyMap = {};

      for (String part in parts) {
        List<String> keyValue = part.split(': ');
        if (keyValue.length == 2) {
          String key = keyValue[0].trim();
          String value = keyValue[1].trim();

          if (key == 'ID') {
            historyMap['id'] = int.parse(value);
          } else if (key == 'DateTime') {
            historyMap['dateTime'] = DateTime.parse(value);
          } else if (key == 'Product name') {
            historyMap['productName'] = value;
          } else if (key == 'Quantity') {
            historyMap['quantity'] = int.parse(value);
          } else if (key == 'Price') {
            historyMap['price'] = double.parse(value);
          } else if (key == 'Discount') {
            historyMap['discount'] = double.parse(value.replaceAll('%', ''));
          } else if (key == 'Applied Directly') {
            historyMap['appliedDirectly'] = value.toLowerCase() == 'true';
          } else if (key == 'Payment Method') {
            historyMap['paymentMethod'] = value;
          }
        }
      }

      return PaymentHistory(
        id: historyMap['id'],
        dateTime: historyMap['dateTime'],
        productName: historyMap['productName'],
        quantity: historyMap['quantity'],
        price: historyMap['price'],
        discount: historyMap['discount'],
        appliedDirectly: historyMap['appliedDirectly'],
        paymentMethod: historyMap['paymentMethod'],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase History',
            style: TextStyle(fontSize: 24, color: AppColors.textColor)),
        backgroundColor: AppColors.primaryColor,
        iconTheme: const IconThemeData(
          color: AppColors.textColor, // Màu của các icon, bao gồm nút back
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
        child: FutureBuilder<List<PaymentHistory>>(
          future: _loadPaymentHistory(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('An error occurred: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                  child: Text('No payment histories available.'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (ctx, index) =>
                    PaymentHistoryItem(paymentHistory: snapshot.data![index]),
              );
            }
          },
        ),
      ),
    );
  }
}
