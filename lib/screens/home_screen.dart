import 'package:flutter/material.dart';
import 'package:cash_book_naufal/components/home_nav_btn.dart';
import 'package:cash_book_naufal/screens/add_income_screen.dart';
import 'package:cash_book_naufal/screens/add_expense_screen.dart';
import 'package:cash_book_naufal/screens/cash_flow_detail_screen.dart';
import 'package:cash_book_naufal/screens/settings_screen.dart';
import 'package:cash_book_naufal/database/database_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20.0),
              const Text(
                'Rangkuman Bulan Ini',
                style: TextStyle(
                  fontSize: 21.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20.0),
              FutureBuilder<double>(
                future: databaseHelper.getTotalExpense(),
                builder: (context, snapshot) {
                  double totalExpense = snapshot.data ?? 0.0;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Pengeluaran: ',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Rp ${totalExpense.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 10.0),
              // Total Pemasukan
              FutureBuilder<double>(
                future: databaseHelper.getTotalIncome(),
                builder: (context, snapshot) {
                  double totalIncome = snapshot.data ?? 0.0;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Pemasukan: ',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Rp ${totalIncome.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20.0),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20.0,
                mainAxisSpacing: 20.0,
                shrinkWrap: true,
                children: [
                  HomeNavigationButton(
                    label: 'Buat Pemasukan',
                    icon: Icons.add_circle_outline,
                    iconColor: Colors.white,
                    buttonColor: Colors.blue,
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const AddIncomeScreen()),
                      );
                    },
                  ),
                  HomeNavigationButton(
                    label: 'Buat Pengeluaran',
                    icon: Icons.remove_circle_outline,
                    iconColor: Colors.white,
                    buttonColor: Colors.blue,
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20.0,
                mainAxisSpacing: 20.0,
                shrinkWrap: true,
                children: [
                  HomeNavigationButton(
                    label: 'Detail Cash Flow',
                    icon: Icons.list,
                    iconColor: Colors.white,
                    buttonColor: Colors.blue,
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const CashFlowDetailScreen()),
                      );
                    },
                  ),
                  HomeNavigationButton(
                    label: 'Pengaturan',
                    icon: Icons.settings,
                    iconColor: Colors.white,
                    buttonColor: Colors.blue,
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingsScreen()),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
