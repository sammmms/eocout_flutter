import 'package:eocout_flutter/components/my_logo.dart';
import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';

class LogoWithTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  const LogoWithTitle({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        const MyLogo(size: 100),
        const SizedBox(
          height: 20,
        ),
        Text(
          title,
          style: textTheme.headlineLarge,
          textAlign: TextAlign.center,
        ),
        if (subtitle != null)
          Text(
            subtitle!,
            style: textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
