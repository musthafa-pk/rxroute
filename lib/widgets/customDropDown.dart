import 'package:flutter/material.dart';
class CustomDropdown extends StatelessWidget {
  final List<String> options;
  final ValueChanged<String?>? onChanged;
  final String? value;

  const CustomDropdown({super.key, 
    required this.options,
    this.onChanged,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      items: options.map((String option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: const InputDecoration(
        hintText: 'select',
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        border: InputBorder.none
      ),
    );
  }
}