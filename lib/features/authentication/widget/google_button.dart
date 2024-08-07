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
          backgroundColor: WidgetStateProperty.all(
            colorScheme.secondary,
          ),
          side: WidgetStateProperty.all(
            BorderSide(
              color: colorScheme.outline,
            ),
          ),
        ),
        onPressed: () async {
          // GoogleSignInAccount? googleUser = await googleSignIn.signIn();

          // TODO: Login using googleUser
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/google_icon.png', width: 20, height: 20),
            const SizedBox(width: 10),
            Text('Google',
                style: textTheme.titleLarge!
                    .copyWith(color: colorScheme.shadow.withOpacity(0.6))),
          ],
        ),
      ),
    );
  }
}
