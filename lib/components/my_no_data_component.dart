import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MyNoDataComponent extends StatelessWidget {
  final String? label;
  const MyNoDataComponent({super.key, this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Lottie.asset("assets/lottie/empty_animation.json", height: 200),
        const SizedBox(
          height: 20,
        ),
        Text(
          label ?? 'Tidak ada data',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
