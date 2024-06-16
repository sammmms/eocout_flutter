import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';

class MyButtonTextField extends StatelessWidget {
  final Widget? icon;
  final Widget? label;
  final Function()? onTap;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;
  const MyButtonTextField(
      {super.key,
      this.icon,
      this.label,
      this.onTap,
      this.controller,
      this.validator,
      this.autovalidateMode});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: TextFormField(
        validator: validator,
        controller: controller,
        autovalidateMode: autovalidateMode,
        decoration: InputDecoration(
            enabled: false,
            contentPadding: const EdgeInsets.fromLTRB(20, 20, 10, 20),
            disabledBorder: Theme.of(context)
                .inputDecorationTheme
                .disabledBorder
                ?.copyWith(
                    borderSide:
                        BorderSide(color: colorScheme.secondaryContainer)),
            label: label,
            prefixIcon: icon),
      ),
    );
  }
}
