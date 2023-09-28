import 'package:flutter/material.dart';
import 'package:cash_book_naufal/components/date_picker.dart';
import 'package:cash_book_naufal/screens/home_screen.dart';
import 'package:cash_book_naufal/database/database_helper.dart';

class AddIncomeScreen extends StatefulWidget {
  const AddIncomeScreen({super.key});

  @override
  AddIncomeScreenState createState() => AddIncomeScreenState();
}

class AddIncomeScreenState extends State<AddIncomeScreen> {
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
              'Tambah Pemasukan',
              style: TextStyle(
                fontSize: 21.0,
                fontWeight: FontWeight.bold,
                color: Colors.red, // Warna sesuai keinginan Anda
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
              controller: nominalController, // Tambahkan controller untuk input nominal
            ),

            TextField(
              decoration: const InputDecoration(
                labelText: "Keterangan",
                hintText: "",
              ),
              controller: keteranganController, // Tambahkan controller untuk input keterangan
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
                    backgroundColor: Colors.yellow, // Warna latar belakang untuk tombol reset (kuning)
                    minimumSize: const Size(double.infinity, 30), // Tombol memenuhi lebar layar
                  ),
                  child: const Text("Reset", style: TextStyle(color: Colors.black)), // Warna teks hitam
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Mengambil nilai dari inputan
                    DateTime date = selectedDate;
                    double amount = double.parse(nominalController.text);
                    String description = keteranganController.text;

                    // Memanggil fungsi untuk menyimpan pemasukan ke database
                    int result = await DatabaseHelper().insertIncome(date, amount, description);

                    // Memeriksa apakah data berhasil disimpan
                    if (result != -1) {
                      // Data berhasil disimpan, tampilkan Snackbar "Tersimpan" dan kembali ke halaman "Beranda"
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Data berhasil disimpan.'),
                        ),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                      );
                    } else {
                      // Terjadi kesalahan saat menyimpan data, tampilkan Snackbar "Gagal"
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Gagal menyimpan data.'),
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
                    backgroundColor: Colors.blue, // Warna latar belakang untuk tombol kembali (biru)
                    minimumSize: const Size(double.infinity, 30), // Tombol memenuhi lebar layar
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
