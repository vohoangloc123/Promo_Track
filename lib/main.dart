import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Database _database;

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  void _initializeDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'discounts.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE orders(id INTEGER PRIMARY KEY AUTOINCREMENT, customer_id INTEGER, order_date TEXT, total_amount REAL, discount_applied REAL)',
        ).then((_) {
          return db.execute(
            'CREATE TABLE discounts(id INTEGER PRIMARY KEY AUTOINCREMENT, percentage REAL, valid_from TEXT, valid_until TEXT, is_applied_directly INTEGER)',
          );
        }).then((_) {
          return db.execute(
            'CREATE TABLE order_discounts(id INTEGER PRIMARY KEY AUTOINCREMENT, order_id INTEGER, discount_id INTEGER, applied_amount REAL)',
          );
        }).then((_) {
          return db.execute(
            'CREATE TABLE discount_history(id INTEGER PRIMARY KEY AUTOINCREMENT, discount_id INTEGER, order_id INTEGER, applied_amount REAL, date TEXT)',
          );
        });
      },
      version: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Discount Management')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Thực hiện các thao tác với cơ sở dữ liệu
          },
          child: Text('Add Order'),
        ),
      ),
    );
  }
}
