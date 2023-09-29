import 'package:flutter/material.dart';
import 'package:cash_book_naufal/database/database_helper.dart';
import 'package:cash_book_naufal/screens/home_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  bool isPasswordCorrect = true;

  void _changePassword() async {
    final currentPassword = currentPasswordController.text;
    final newPassword = newPasswordController.text;

    // Verifikasi password saat ini
    final isCorrectPassword =
    await DatabaseHelper().checkCurrentPassword(currentPassword);

    if (isCorrectPassword) {
      // Simpan password baru ke database
      await DatabaseHelper().updatePassword(newPassword);

      // Password berhasil diperbarui
      setState(() {
        isPasswordCorrect = true;
      });

      // Tampilkan pesan Snackbar berhasil
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password berhasil diperbarui.'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      setState(() {
        isPasswordCorrect = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password saat ini tidak sesuai.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password Saat Ini",
              ),
            ),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password Baru",
              ),
            ),
            ElevatedButton(
              onPressed: _changePassword,
              child: const Text("Simpan"),
            ),
            if (!isPasswordCorrect)
              const Text(
                "Password saat ini tidak sesuai.",
                style: TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
              child: const Text("Kembali"),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Image.asset(
                      "assets/images/dfgag.png",
                      width: 100,
                      height: 100,
                    ),
                  ],
                ),
                const SizedBox(width: 20.0),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Cash Book Naufal",
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Aplikasi ini dibuat oleh",
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Text(
                        "Nama: Naufal Rozan",
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Text(
                        "NIM: 2141764124",
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Text(
                        "Tanggal: 29 September 2023",
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }
}