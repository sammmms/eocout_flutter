import 'package:flutter/material.dart';

class EOServicePage extends StatefulWidget {
  const EOServicePage({super.key});

  @override
  State<EOServicePage> createState() => _EOServicePageState();
}

class _EOServicePageState extends State<EOServicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back),
        ),
        title: const Text('Layanan Kamu'),
      ),
      body: ListView(),
    );
  }
}
