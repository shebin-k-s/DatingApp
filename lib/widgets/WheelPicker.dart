import 'package:flutter/material.dart';

Widget WheelPicker(
    List<String> items, int selectedItem, Function(int) onSelectedItemChanged) {
  return ListWheelScrollView.useDelegate(
    itemExtent: 60,
    perspective: 0.009,
    diameterRatio: 6,
    physics: const FixedExtentScrollPhysics(),
    controller: FixedExtentScrollController(initialItem: selectedItem),
    onSelectedItemChanged: onSelectedItemChanged,
    childDelegate: ListWheelChildBuilderDelegate(
      childCount: items.length,
      builder: (context, index) {
        return Center(
          child: Text(
            items[index],
            style: TextStyle(
              color: index == selectedItem
                  ? const Color(0xffE94057)
                  : Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    ),
  );
}
