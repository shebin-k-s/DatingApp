import 'package:flutter/material.dart';
import 'package:datingapp/widgets/WheelPicker.dart';

class GenderSelector extends StatelessWidget {
  final Function(String) onGenderSelect;
  final ValueNotifier<int?> _selectedGenderNotifier = ValueNotifier(null);
  final List<String> _genders = ['Male', 'Female', 'Other'];

  GenderSelector({Key? key, required this.onGenderSelect}) : super(key: key);

  void _showGenderBottomSheet(BuildContext context) {
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
                    valueListenable: _selectedGenderNotifier,
                    builder: (context, value, child) {
                      return WheelPicker(_genders, value ?? 1, (index) {
                        _selectedGenderNotifier.value = index;
                        onGenderSelect(_genders[index]);
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
                _showGenderBottomSheet(context);
                if (_selectedGenderNotifier.value == null) {
                  _selectedGenderNotifier.value = 1;
                  onGenderSelect(_genders[1]);
                }
                state.didChange(_genders[_selectedGenderNotifier.value ?? 1]);
              },
              child: ValueListenableBuilder<int?>(
                valueListenable: _selectedGenderNotifier,
                builder: (context, index, child) {
                  return SizedBox(
                    height: 80,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: index != null ? 'Gender' : null,
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
                        index != null ? _genders[index] : 'Choose Gender',
                        style: TextStyle(
                          color: index != null
                              ? Colors.grey[800]
                              : const Color.fromARGB(255, 72, 71, 71),
                          fontSize: 18,
                          fontWeight: index != null
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
