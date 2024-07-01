import 'package:datingapp/widgets/WheelPicker.dart';
import 'package:flutter/material.dart';

void CalendarBottomSheet({
  required BuildContext context,
  required DateTime initialDate,
  required Function(DateTime) onDateSelected,
}) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return CustomCalendarBottomSheet(
        initialDate: initialDate,
        onDateSelected: onDateSelected,
      );
    },
  );
}

class CustomCalendarBottomSheet extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateSelected;

  const CustomCalendarBottomSheet({
    Key? key,
    required this.initialDate,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  _CustomCalendarBottomSheetState createState() =>
      _CustomCalendarBottomSheetState();
}

class _CustomCalendarBottomSheetState extends State<CustomCalendarBottomSheet> {
  late int _selectedDay;
  late int _selectedMonth;
  late int _selectedYear;

  final List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.initialDate.day;
    _selectedMonth = widget.initialDate.month;
    _selectedYear = widget.initialDate.year;
  }

  int _daysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Date of birth',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: WheelPicker(
                    List.generate(_daysInMonth(_selectedYear, _selectedMonth),
                        (index) => (index + 1).toString().padLeft(2, '0')),
                    _selectedDay - 1,
                    (index) => setState(() => _selectedDay = index + 1),
                  ),
                ),
                Expanded(
                  child: WheelPicker(
                    _months,
                    _selectedMonth - 1,
                    (index) {
                      setState(() {
                        _selectedMonth = index + 1;
                        int daysInNewMonth =
                            _daysInMonth(_selectedYear, _selectedMonth);
                        if (_selectedDay > daysInNewMonth) {
                          _selectedDay = daysInNewMonth;
                        }
                      });
                    },
                  ),
                ),
                Expanded(
                  child: WheelPicker(
                    List.generate(
                        100,
                        (index) =>
                            (DateTime.now().year - 50 + index).toString()),
                    _selectedYear - (DateTime.now().year - 50),
                    (index) => setState(
                        () => _selectedYear = DateTime.now().year - 50 + index),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(
                double.infinity,
                50,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Color(0xffE94057),
            ),
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            onPressed: () {
              widget.onDateSelected(
                  DateTime(_selectedYear, _selectedMonth, _selectedDay));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
