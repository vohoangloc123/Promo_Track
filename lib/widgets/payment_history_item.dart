import 'package:flutter/material.dart';
import 'package:promo_track/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Đảm bảo import SharedPreferences
import 'package:promo_track/models/PaymentHistory.dart';

class PaymentHistoryItem extends StatelessWidget {
  const PaymentHistoryItem({super.key, required this.paymentHistory});
  final PaymentHistory paymentHistory;

  Future<void> _showDetailDialog(BuildContext context) async {
    // Lấy SharedPreferences
    final prefs = await SharedPreferences.getInstance();

    // Lấy danh sách chi tiết từ SharedPreferences
    final history = prefs.getStringList('detail_payment_history') ?? [];
    print('detail history $history');
    // Tìm chi tiết dựa trên ID
    final detailHistoryEntry = history.firstWhere(
      (entry) => entry.startsWith('ID: ${paymentHistory.id}'),
      orElse: () => 'No details found for this ID.',
    );
    print('detail history $detailHistoryEntry');
    // Hiển thị popup với chi tiết
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detail for ID: ${paymentHistory.id}'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(detailHistoryEntry),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.secondaryColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Phone: ${paymentHistory.phoneNumber ?? 'N/A'}',
                style:
                    const TextStyle(fontSize: 20, color: AppColors.textColor)),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.alarm),
                const SizedBox(width: 8),
                Text(
                  paymentHistory.dateTime.toString(),
                  style: const TextStyle(color: AppColors.textColor),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => _showDetailDialog(context),
                  child: const Text(
                    'View detail',
                    style: TextStyle(color: AppColors.textColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text('Payment Method: ${paymentHistory.paymentMethod}',
                style: const TextStyle(color: AppColors.textColor)),
          ],
        ),
      ),
    );
  }
}
