import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';

class AuthButtonDivider extends StatelessWidget {
  const AuthButtonDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          const Expanded(
            child: Divider(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'atau',
              style: textTheme.bodyLarge!.copyWith(
                color: colorScheme.shadow.withOpacity(0.4),
              ),
            ),
          ),
          const Expanded(
            child: Divider(),
          ),
        ],
      ),
    );
  }
}
