import 'dart:io';
import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';

class PictureViewer extends StatelessWidget {
  final Function() onRemove;
  final File image;
  const PictureViewer({super.key, required this.onRemove, required this.image});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      insetPadding: const EdgeInsets.all(10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.6),
                  child: Image.memory(
                    image.readAsBytesSync(),
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: onRemove,
                    child: Icon(
                      Icons.delete,
                      color: colorScheme.error,
                    ),
                  ),
                )
              ],
            ),
            Positioned(
              right: 0,
              child: IconButton(
                  style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(colorScheme.surface),
                      shape: WidgetStateProperty.all(const CircleBorder())),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close,
                    color: colorScheme.onSurface,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
