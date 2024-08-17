import 'package:flutter/material.dart';
import 'package:promo_track/models/PaymentHistory.dart';

class PaymentHistoryItem extends StatelessWidget {
  const PaymentHistoryItem({super.key, required this.paymentHistory});
  final PaymentHistory paymentHistory;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(paymentHistory.productName,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('\$${paymentHistory.price.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                const Spacer(),
                Row(
                  children: [
                    const Icon(Icons.alarm),
                    Text(paymentHistory.dateTime.toString()),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text('Discount: ${paymentHistory.discount.toStringAsFixed(2)}%'),
            Text(
                'Applied Directly: ${paymentHistory.appliedDirectly ? "Yes" : "No"}'),
            Text('Payment Method: ${paymentHistory.paymentMethod}'),
          ],
        ),
      ),
    );
  }
}
