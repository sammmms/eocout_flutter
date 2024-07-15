import 'package:eocout_flutter/utils/app_error.dart';
import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';

class MyErrorComponent extends StatelessWidget {
  final Function() onRefresh;
  final AppError? error;
  const MyErrorComponent({super.key, required this.onRefresh, this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(onTap: onRefresh, child: const Icon(Icons.refresh)),
        const SizedBox(
          height: 20,
        ),
        Text(
          error?.message ?? 'Terjadi kesalahan, silahkan coba lagi',
          style: textTheme.bodyLarge,
        ),
      ],
    ));
  }
}
