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
    return Material(
      type: MaterialType.transparency,
      child: Ink(
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
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed,
          splashColor: Colors.white.withValues(alpha: 0.15),
          child: Center(
            child: isLoading
                ? CupertinoActivityIndicator(
                    color: Colors.white,
                  )
                : Text(
                    textAlign: TextAlign.center,
                    text ?? 'Завершить',
                    style: TextStyle(color: Colors.white),
                  ),
          ),
        ),
      ),
    );
  }
}
