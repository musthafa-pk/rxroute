import 'package:flutter/material.dart';

import '../../../app_colors.dart';

class AddChemist extends StatefulWidget {
  const AddChemist({super.key});

  @override
  State<AddChemist> createState() => _AddChemistState();
}

class _AddChemistState extends State<AddChemist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color:AppColors.primaryColor, // Replace with your desired color
              borderRadius: BorderRadius.circular(6),
            ),
            child: InkWell(onTap: (){
              Navigator.pop(context);
            },
                child: const Icon(Icons.arrow_back, color: Colors.white)), // Adjust icon color
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Add Chemist',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
