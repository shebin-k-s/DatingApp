import 'package:flutter/material.dart';

const Color kPrimaryColor = Color(0xffE94057);

Future<Map<String, dynamic>?> FilterBottomSheet({
  required BuildContext context,
  required String interestedIn,
  required double distance,
  required RangeValues ageRange,
  required String location,
}) async {
  return await showModalBottomSheet<Map<String, dynamic>>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: FilterBottomSheetContent(
          interestedIn: interestedIn,
          distance: distance,
          ageRange: ageRange,
          location: location,
        ),
      );
    },
  );
}

class FilterBottomSheetContent extends StatefulWidget {
  const FilterBottomSheetContent({
    super.key,
    required this.interestedIn,
    required this.distance,
    required this.ageRange,
    required this.location,
  });

  final String interestedIn;
  final double distance;
  final RangeValues ageRange;
  final String location;

  @override
  _FilterBottomSheetContentState createState() =>
      _FilterBottomSheetContentState();
}

class _FilterBottomSheetContentState extends State<FilterBottomSheetContent> {
  late String interestedIn;
  late double distance;
  late RangeValues ageRange;
  late TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    interestedIn = widget.interestedIn;
    distance = widget.distance;
    ageRange = widget.ageRange;
    _locationController = TextEditingController(text: widget.location);
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        height: MediaQuery.of(context).size.height * 0.6,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filters',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  child: const Text(
                    'Clear',
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 16,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      distance = 50;
                      ageRange = const RangeValues(18, 40);
                      interestedIn = 'Any';
                      _locationController.text = widget.location;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Interested in',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInterestButton('Any'),
                const SizedBox(width: 8),
                _buildInterestButton('Male'),
                const SizedBox(width: 8),
                _buildInterestButton('Female'),
                const SizedBox(width: 8),
                _buildInterestButton('Other'),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Location',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                hintText: 'Enter location',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Distance',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text('${distance.round()}km'),
                  ],
                ),
                Slider(
                  value: distance,
                  min: 0,
                  max: 300,
                  label: distance.round().toString(),
                  activeColor: kPrimaryColor,
                  onChanged: (value) {
                    setState(() {
                      distance = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Age',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text('${ageRange.start.round()}-${ageRange.end.round()}'),
                  ],
                ),
                RangeSlider(
                  values: ageRange,
                  min: 18,
                  max: 100,
                  labels: RangeLabels(
                    ageRange.start.round().toString(),
                    ageRange.end.round().toString(),
                  ),
                  activeColor: kPrimaryColor,
                  onChanged: (value) {
                    setState(() {
                      ageRange = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.pop(context, {
                  'interestedIn': interestedIn,
                  'distance': distance,
                  'ageRange': ageRange,
                  'location': _locationController.text
                });
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInterestButton(String label) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: interestedIn == label ? kPrimaryColor : Colors.white,
        foregroundColor: interestedIn == label ? Colors.white : Colors.black,
      ),
      onPressed: () {
        setState(() {
          interestedIn = label;
        });
      },
      child: Text(label),
    );
  }
}
