import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String? text;
  final bool isLoading;

  const SubmitButton({
    required this.onPressed,
    this.isLoading = false,
    this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
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
        child: isLoading
            ? CupertinoActivityIndicator(
                color: Colors.white,
              )
            : Text(
                text ?? 'Submit',
                style: TextStyle(color: Colors.white),
              ),
      ),
    );
  }
}
