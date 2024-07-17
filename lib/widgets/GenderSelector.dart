import 'package:datingapp/utils/GenderBottomSheet.dart';
import 'package:flutter/material.dart';
import 'package:datingapp/widgets/WheelPicker.dart';

class GenderSelector extends StatelessWidget {
  final Function(String) onGenderSelect;
  final ValueNotifier<String?> _selectedGenderNotifier = ValueNotifier(null);
  GenderSelector({super.key, required this.onGenderSelect});

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: (value) {
        if (_selectedGenderNotifier.value == null) {
          return 'Please select a gender';
        }
        return null;
      },
      builder: (FormFieldState<String> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                GenderBottomSheet(
                    context: context,
                    onGenderSelect: (gender) {
                      _selectedGenderNotifier.value = gender;
                      onGenderSelect(gender);
                    });
              },
              child: ValueListenableBuilder<String?>(
                valueListenable: _selectedGenderNotifier,
                builder: (context, gender, child) {
                  return SizedBox(
                    height: 80,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: gender != null ? 'Gender' : null,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        suffixIcon: const Icon(Icons.arrow_drop_down),
                        errorText: state.hasError ? state.errorText : null,
                        errorStyle: const TextStyle(
                          fontSize: 14,
                        ),
                        errorMaxLines: 1,
                      ),
                      child: Text(
                        gender ?? 'Choose Gender',
                        style: TextStyle(
                          color: gender != null
                              ? Colors.grey[800]
                              : const Color.fromARGB(255, 72, 71, 71),
                          fontSize: 18,
                          fontWeight: gender != null
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
