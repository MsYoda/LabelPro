import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  final Function() onPressed;
  final bool isSelected;
  final String title;
  final IconData icon;

  const MenuButton({
    super.key,
    required this.onPressed,
    required this.title,
    required this.icon,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return ElevatedButton(
      statesController: WidgetStatesController(),
      style: ButtonStyle(
        elevation: WidgetStateProperty.all(isSelected ? 0 : 0),
        backgroundColor: WidgetStateProperty.all(
          isSelected ? colors.primary.withValues(alpha: 0.1) : Colors.transparent,
        ),
        animationDuration: Duration.zero,
        padding: WidgetStateProperty.all(const EdgeInsets.all(16)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      onPressed: !isSelected ? onPressed : null,
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            color: isSelected ? colors.primary : colors.onSurface.withValues(alpha: 0.7),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              color: isSelected ? colors.primary : colors.onSurface.withValues(alpha: 0.7),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
