import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';

class MyBackground extends StatelessWidget {
  final Widget body;
  final bool needPadding;
  const MyBackground({super.key, required this.body, this.needPadding = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorScheme.background,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Positioned(
            top: -175,
            right: -250,
            child: Container(
              height: 330,
              width: 330,
              decoration: BoxDecoration(
                color: colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(1000),
              ),
            ),
          ),
          Positioned(
            bottom: -225,
            left: -125,
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.5),
                borderRadius: BorderRadius.circular(1000),
              ),
            ),
          ),
          Scaffold(
              backgroundColor: Colors.transparent,
              body: SafeArea(
                  child: Padding(
                padding: needPadding
                    ? const EdgeInsets.fromLTRB(25, 25, 25, 0)
                    : EdgeInsets.zero,
                child: body,
              )))
        ],
      ),
    );
  }
}
