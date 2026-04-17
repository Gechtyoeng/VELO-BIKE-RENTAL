import 'package:flutter/material.dart';

class SquareMapActionButton extends StatelessWidget {
  final Color backgroundColor;
  final Color iconColor;
  final IconData icon;
  final VoidCallback onTap;

  const SquareMapActionButton({super.key, required this.backgroundColor, required this.iconColor, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(18),
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: SizedBox(width: 60, height: 60, child: Icon(icon, color: iconColor)),
      ),
    );
  }
}
