import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SubmitButton({
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.blue,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 12,
          )
        ],
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          'Submit',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
