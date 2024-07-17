// bottom_sheet_utils.dart
import 'package:flutter/material.dart';
import 'package:datingapp/widgets/WheelPicker.dart';

void GenderBottomSheet({
  required BuildContext context,
  required Function(String) onGenderSelect,
}) {
  final List<String> genders = ['Male', 'Female', 'Other'];
  final ValueNotifier<int?> selectedGenderNotifier = ValueNotifier(1);

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.4,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Select Gender',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ValueListenableBuilder<int?>(
                  valueListenable: selectedGenderNotifier,
                  builder: (context, value, child) {
                    return WheelPicker(genders, value ?? 1, (index) {
                      selectedGenderNotifier.value = index;
                    });
                  },
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
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
                  onGenderSelect(genders[selectedGenderNotifier.value??0]);

                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
