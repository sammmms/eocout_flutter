import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';

class MyErrorComponent extends StatelessWidget {
  final Function() onRefresh;
  final String? label;
  const MyErrorComponent({super.key, required this.onRefresh, this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.refresh),
        const SizedBox(
          height: 20,
        ),
        Text(
          label ?? 'Terjadi kesalahan, silahkan coba lagi',
          style: textStyle.bodyLarge,
        ),
      ],
    ));
  }
}
