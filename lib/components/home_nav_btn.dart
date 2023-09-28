import 'package:flutter/material.dart';

class HomeNavigationButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color iconColor;
  final Color buttonColor;
  final VoidCallback onPressed;

  const HomeNavigationButton({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.buttonColor,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 48.0, // Ukuran icon
            color: iconColor,
          ),
          const SizedBox(height: 8.0),
          Text(label), // Keterangan tombol
        ],
      ),
    );
  }
}
