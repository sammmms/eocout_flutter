import 'package:eocout_flutter/components/my_background.dart';
import 'package:eocout_flutter/components/my_logo.dart';
import 'package:eocout_flutter/components/my_transition.dart';
import 'package:eocout_flutter/features/authentication/login/login_page.dart';
import 'package:eocout_flutter/features/authentication/register/eo_register/eo_register_page.dart';
import 'package:eocout_flutter/features/authentication/register/user_register/user_register_page.dart';
import 'package:eocout_flutter/features/welcome_page.dart';
import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
          return;
        }
        navigateTo(context, const WelcomePage(),
            transition: TransitionType.slideInFromTop);
      },
      child: Scaffold(
        body: MyBackground(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const MyLogo(size: 150),
                const SizedBox(height: 20),
                SizedBox(
                  width: 200,
                  child: Text(
                    "Daftarkan diri kamu sekarang dibawah ini!",
                    style: Theme.of(context).textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 60),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: OutlinedButton(
                      onPressed: () {
                        navigateTo(context, const UserRegisterPage(),
                            transition: TransitionType.slideInFromBottom);
                      },
                      child: Text("Daftar Sebagai Pengguna",
                          style: textStyle.titleLarge!
                              .copyWith(color: colorScheme.onPrimary))),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                      onPressed: () {
                        navigateTo(context, const EORegisterPage(),
                            transition: TransitionType.slideInFromBottom);
                      },
                      child: Text(
                        "Daftar Sebagai EO atau Vendor",
                        style: textStyle.titleLarge!
                            .copyWith(color: colorScheme.onTertiary),
                      )),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Sudah punya akun? "),
                    TextButton(
                      onPressed: () {
                        navigateTo(context, const LoginPage(),
                            transition: TransitionType.slideInFromBottom);
                      },
                      child: const Text("Masuk disini"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
