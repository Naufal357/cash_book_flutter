import 'package:flutter/material.dart';
import 'package:cash_book_naufal/components/date_picker.dart';
import 'package:cash_book_naufal/screens/home_screen.dart';
import 'package:cash_book_naufal/database/database_helper.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({Key? key}) : super(key: key);

  @override
  AddExpenseScreenState createState() => AddExpenseScreenState();
}

class AddExpenseScreenState extends State<AddExpenseScreen> {
  DateTime selectedDate = DateTime.now();
  TextEditingController nominalController = TextEditingController();
  TextEditingController keteranganController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20.0),
            const Text(
              'Tambah Pengeluaran',
              style: TextStyle(
                fontSize: 21.0,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            DatePickerComponent(
              onDateSelected: (date) {
                setState(() {
                  selectedDate = date;
                });
              },
            ),
            const SizedBox(height: 20.0),
            TextField(
              decoration: const InputDecoration(
                labelText: "Nominal",
                hintText: "",
              ),
              keyboardType: TextInputType.number,
              controller: nominalController,
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: "Keterangan",
                hintText: "",
              ),
              controller: keteranganController,
            ),
            const SizedBox(height: 20.0),
            Column(
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedDate = DateTime.now();
                      nominalController.clear();
                      keteranganController.clear();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    minimumSize: const Size(double.infinity, 30),
                  ),
                  child: const Text("Reset", style: TextStyle(color: Colors.black)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    DateTime date = selectedDate;
                    double amount = double.parse(nominalController.text);
                    String description = keteranganController.text;

                    int result = await DatabaseHelper().insertExpense(date, amount, description);

                    if (result != -1) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Data pengeluaran berhasil disimpan.'),
                        ),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Gagal menyimpan data pengeluaran.'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    minimumSize: const Size(double.infinity, 30),
                  ),
                  child: const Text("Simpan", style: TextStyle(color: Colors.black)),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(double.infinity, 30),
                  ),
                  child: const Text("<<< Kembali", style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
