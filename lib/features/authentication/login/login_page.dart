import 'package:eocout_flutter/components/my_background.dart';
import 'package:eocout_flutter/components/my_snackbar.dart';
import 'package:eocout_flutter/components/my_transition.dart';
import 'package:eocout_flutter/features/authentication/authentication_page.dart';
import 'package:eocout_flutter/features/authentication/forgot_password/forgot_password_page.dart';
import 'package:eocout_flutter/features/authentication/register/user_register/otp_page.dart';
import 'package:eocout_flutter/features/authentication/widget/action_button.dart';
import 'package:eocout_flutter/features/authentication/widget/button_divider.dart';
import 'package:eocout_flutter/features/authentication/widget/google_button.dart';
import 'package:eocout_flutter/features/authentication/widget/logo_with_title.dart';
import 'package:eocout_flutter/features/authentication/widget/password_text_field.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final Widget? from;
  const LoginPage({super.key, this.from});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;

        if (widget.from != null && widget.from is! OtpPage) {
          navigateTo(context, widget.from!,
              transition: TransitionType.fadeIn, replace: true);
        } else {
          navigateTo(context, const AuthenticationPage(),
              transition: TransitionType.fadeIn, replace: true);
        }
      },
      child: MyBackground(
        body: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Expanded(flex: 3, child: LogoWithTitle(title: "Masuk")),
                Expanded(
                  flex: 7,
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Email',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email wajib diisi.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      PasswordTextField(
                        onChanged: (value) {},
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      AuthActionButton(
                          label: 'Masuk',
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              showMySnackBar(context, "Mencoba masuk...",
                                  SnackbarStatus.nothing);
                            }
                          }),
                      const AuthButtonDivider(),
                      const GoogleAuthButton(),
                      Center(
                        child: TextButton(
                            onPressed: () {
                              navigateTo(context, const ForgotPasswordPage(),
                                  transition: TransitionType.fadeIn);
                            },
                            child: const Text('Lupa password? ')),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
