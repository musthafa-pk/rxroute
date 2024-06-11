import 'package:flutter/material.dart';
class Bubble extends StatelessWidget {
  final double size;
  final Color color;

  const Bubble({super.key, 
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}