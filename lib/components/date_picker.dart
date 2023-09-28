import 'package:flutter/material.dart';

class DatePickerComponent extends StatefulWidget {
  final Function(DateTime) onDateSelected;

  const DatePickerComponent({super.key, required this.onDateSelected});

  @override
  DatePickerComponentState createState() => DatePickerComponentState();
}

class DatePickerComponentState extends State<DatePickerComponent> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        widget.onDateSelected(selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          "Tanggal:",
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 3),
        GestureDetector(
          onTap: () => _selectDate(context),
          child: Row(
            children: <Widget>[
              const SizedBox(width: 5),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black), // Warna garis tepi
                    borderRadius: BorderRadius.circular(5.0), // Bentuk sudut
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${selectedDate.toLocal()}".split(' ')[0],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
              const Icon(Icons.calendar_today),
            ],
          ),
        ),
      ],
    );
  }
}
