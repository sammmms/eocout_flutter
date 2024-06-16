import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MySearchBar extends StatelessWidget {
  final void Function(String) onChanged;
  final String label;
  final bool isRounded;
  const MySearchBar(
      {super.key,
      required this.onChanged,
      required this.label,
      this.isRounded = false});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius:
              isRounded ? BorderRadius.circular(30) : BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius:
              isRounded ? BorderRadius.circular(30) : BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        hintText: label,
        hintStyle: TextStyle(color: colorScheme.secondaryContainer),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SvgPicture.asset(
            'assets/svg/search_icon.svg',
            width: 10,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
