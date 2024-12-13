import 'package:ajar/utils/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class DetailRow extends StatelessWidget {
  final String title;
  final IconData? icon1; // First icon for the first row
  final IconData? icon2; // Second icon for the second row (optional)
  final String value1; // First row value
  final String? value2; // Second row value (optional)
  final Color? color;

  const DetailRow({
    super.key,
    required this.title,
    this.icon1, // First optional icon
    this.icon2, // Second optional icon
    required this.value1, // First row value
    this.value2, // Second optional value
    this.color, // First optional color
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: fMainColor,
          ),
        ),
        const SizedBox(
          height: 14,
        ),

        // First Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // First icon section (optional)
            if (icon1 != null) ...[
              Icon(icon1, size: 24),
              const SizedBox(width: 15),
            ],

            // Text value for the first row
            Expanded(
              child: Text(
                value1,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),

        // Second Row (optional)
        if (icon2 != null || value2 != null) ...[
          const SizedBox(height: 12), // Add spacing between the rows
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Second icon section (optional)
              if (icon2 != null) ...[
                Icon(
                  icon2,
                  size: 24,
                  color: icon2 == IconlyLight.dangerCircle ? Colors.red : null,
                ),
                const SizedBox(width: 15),
              ],
              // Text value for the second row
              Expanded(
                child: Text(
                  value2 ?? '',
                  style: TextStyle(fontSize: 14, color: color),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
