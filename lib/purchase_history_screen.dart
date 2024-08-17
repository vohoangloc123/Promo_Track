import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PurchaseHistoryScreen extends StatefulWidget {
  @override
  _PurchaseHistoryScreenState createState() => _PurchaseHistoryScreenState();
}

class _PurchaseHistoryScreenState extends State<PurchaseHistoryScreen> {
  List<String> _history = [];

  @override
  void initState() {
    super.initState();
    print('Loading history...');
    _loadHistory();
  }

  // Tải lịch sử mua từ SharedPreferences
  void _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _history = prefs.getStringList('purchase_history') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Purchase History')),
      body: _history.isEmpty
          ? Center(child: Text('No purchase history available.'))
          : ListView.builder(
        itemCount: _history.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_history[index]),
          );
        },
      ),
    );
  }
}
