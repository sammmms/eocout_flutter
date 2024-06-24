import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum Confirmation { positive, negative, noAnswer }

class MyConfirmationDialog extends StatelessWidget {
  final String? headingLabel;
  final String label;
  final String? subLabel;
  final String? positiveLabel;
  final String? noAnswerLabel;
  final String? negativeLabel;
  const MyConfirmationDialog(
      {super.key,
      this.headingLabel,
      required this.label,
      this.subLabel,
      this.positiveLabel,
      this.negativeLabel,
      this.noAnswerLabel});

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (headingLabel != null)
                Text(
                  headingLabel!,
                  style: textStyle.headlineSmall,
                ),
              const SizedBox(height: 10),
              Text(
                label,
                style: textStyle.bodyMedium,
              ),
              if (subLabel != null) ...[
                const SizedBox(height: 10),
                Text(
                  subLabel!,
                  style: textStyle.bodySmall,
                )
              ],
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: negativeLabel != null &&
                        noAnswerLabel != null &&
                        positiveLabel != null
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.end,
                children: [
                  if (negativeLabel != null) ...[
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red.shade400)),
                        onPressed: () {
                          Navigator.pop(context, Confirmation.negative);
                        },
                        child: Text(negativeLabel!)),
                    const SizedBox(width: 10)
                  ],
                  if (noAnswerLabel != null) ...[
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Colors.grey.shade400)),
                        onPressed: () {
                          Navigator.pop(context, Confirmation.noAnswer);
                        },
                        child: Text(noAnswerLabel!)),
                    const SizedBox(width: 10)
                  ],
                  if (positiveLabel != null)
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Colors.green.shade400)),
                        onPressed: () {
                          Navigator.pop(context, Confirmation.positive);
                        },
                        child: Text(positiveLabel!)),
                ],
              )
            ],
          ),
        ));
  }
}
