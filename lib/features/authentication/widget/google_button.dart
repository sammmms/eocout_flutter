import 'package:eocout_flutter/components/my_snackbar.dart';
import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';

class GoogleAuthButton extends StatelessWidget {
  const GoogleAuthButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: OutlinedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            colorScheme.secondary,
          ),
          side: MaterialStateProperty.all(
            BorderSide(
              color: colorScheme.outline,
            ),
          ),
        ),
        onPressed: () {
          showMySnackBar(context, "Google sedang dalam maintenance.",
              SnackbarStatus.error);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/google_icon.png', width: 20, height: 20),
            const SizedBox(width: 10),
            Text('Google',
                style: textStyle.titleLarge!
                    .copyWith(color: colorScheme.shadow.withOpacity(0.6))),
          ],
        ),
      ),
    );
  }
}
