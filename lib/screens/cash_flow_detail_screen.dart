import 'package:flutter/material.dart';
import 'package:cash_book_naufal/database/database_helper.dart';
import 'package:cash_book_naufal/screens/home_screen.dart';

class CashFlowDetailScreen extends StatefulWidget {
  const CashFlowDetailScreen({Key? key}) : super(key: key);

  @override
  CashFlowDetailScreenState createState() => CashFlowDetailScreenState();
}

class CashFlowDetailScreenState extends State<CashFlowDetailScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Map<String, dynamic>> _cashFlowList = [];

  @override
  void initState() {
    super.initState();
    _loadCashFlowData();
  }

  Future<void> _loadCashFlowData() async {
    final cashFlowData = await _databaseHelper.getCashFlowData();

    setState(() {
      _cashFlowList = cashFlowData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Daftar Transaksi',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _cashFlowList.length,
              itemBuilder: (context, index) {
                final item = _cashFlowList[index];
                final type = item['type'];
                final amount = item['amount'];
                final description = item['description'];
                final date = DateTime.parse(item['date']);
                final isIncome = type == 'Income';

                return ListTile(
                  title: Text(
                    'Jumlah: Rp ${amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: isIncome ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tanggal: ${_formatDate(date)}'),
                      Text('Keterangan: $description'),
                    ],
                  ),
                  trailing: Icon(
                    isIncome ? Icons.arrow_forward : Icons.arrow_back,
                    color: isIncome ? Colors.green : Colors.red,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 16),
          child: FloatingActionButton.extended(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
            label: const Text('<< Kembali'),
            backgroundColor: Colors.blue, // Ganti dengan warna yang sesuai
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')} ${_getMonthName(date.month)} ${date.year}';
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'Januari';
      case 2:
        return 'Februari';
      case 3:
        return 'Maret';
      case 4:
        return 'April';
      case 5:
        return 'Mei';
      case 6:
        return 'Juni';
      case 7:
        return 'Juli';
      case 8:
        return 'Agustus';
      case 9:
        return 'September';
      case 10:
        return 'Oktober';
      case 11:
        return 'November';
      case 12:
        return 'Desember';
      default:
        return '';
    }
  }
}
