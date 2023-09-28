import 'package:flutter/material.dart';
import 'package:cash_book_naufal/screens/home_screen.dart';
import 'package:cash_book_naufal/database/database_helper.dart';


class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final DatabaseHelper db = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aplikasi Keuangan'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120.0,
                height: 120.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue, // Ganti warna sesuai desain Anda
                ),
                child: const Icon(
                  Icons.account_balance_wallet, // Ganti ikon sesuai desain Anda
                  size: 80.0,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Aplikasi Keuangan', // Ganti dengan nama aplikasi Anda
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: usernameController, // Tambahkan controller di sini
                decoration: const InputDecoration(
                  labelText: 'Username',
                  hintText: 'Masukkan username',
                ),
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: passwordController, // Tambahkan controller di sini
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'Masukkan password',
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  final username = usernameController.text;
                  final password = passwordController.text;

                  bool isLoggedIn = await db.checkLogin(username, password);

                  if (isLoggedIn) {
                    // Jika berhasil login, buka halaman "HomeScreen"
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    );
                  } else {
                    // Menampilkan pesan kesalahan jika login gagal
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Login gagal. Periksa username dan password Anda.'),
                      ),
                    );
                  }
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
