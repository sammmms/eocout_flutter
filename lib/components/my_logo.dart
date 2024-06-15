import 'package:flutter/material.dart';

class MyLogo extends StatelessWidget {
  final double size;
  const MyLogo({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/images/logo.png",
      width: size,
      height: size,
    );
  }
}
