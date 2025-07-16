import 'package:flutter/material.dart';

class OrderStatusItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isCompleted;
  final bool isActive;

  const OrderStatusItem({
    super.key,
    required this.icon,
    required this.title,
    required this.isCompleted,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Status icon
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: isCompleted 
                ? const Color(0xFF002D72) 
                : isActive 
                    ? const Color(0xFF002D72)
                    : Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isCompleted || isActive ? Colors.white : Colors.grey.shade600,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        // Status title
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isCompleted || isActive ? Colors.black : Colors.grey.shade600,
            ),
          ),
        ),
      ],
    );
  }
}