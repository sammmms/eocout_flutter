import 'package:flutter/material.dart';

class MyLoadingDialog extends StatelessWidget {
  final String? label;
  const MyLoadingDialog({super.key, this.label});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 10),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text(
                label ?? "Loading...",
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ));
  }
}
