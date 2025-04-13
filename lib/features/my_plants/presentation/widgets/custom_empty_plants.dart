import 'package:flutter/material.dart';

class CustomEmptyPlants extends StatelessWidget {
  const CustomEmptyPlants({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_florist,
            size: 80,
            color: Colors.green.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'No plants yet. Add some!',
            style: TextStyle(
              fontSize: 18,
              color: Colors.green.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
