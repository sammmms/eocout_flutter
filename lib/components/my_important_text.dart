import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';

class MyImportantText extends StatelessWidget {
  final String text;

  const MyImportantText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: '$text ',
        children: [
          TextSpan(
            text: '*',
            style: TextStyle(color: colorScheme.error),
          ),
        ],
      ),
    );
  }
}
