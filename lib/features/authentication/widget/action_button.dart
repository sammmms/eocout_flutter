import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';

class AuthActionButton extends StatelessWidget {
  final Function()? onPressed;
  final String label;
  const AuthActionButton({super.key, this.onPressed, required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: onPressed == null
              ? colorScheme.tertiaryContainer
              : colorScheme.primary,
        ),
        onPressed: onPressed,
        child: Text(label,
            style:
                textStyle.titleLarge!.copyWith(color: colorScheme.onPrimary)),
      ),
    );
  }
}
