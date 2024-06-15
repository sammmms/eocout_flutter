import 'package:eocout_flutter/components/my_background.dart';
import 'package:eocout_flutter/components/my_logo.dart';
import 'package:eocout_flutter/components/my_snackbar.dart';
import 'package:eocout_flutter/components/my_transition.dart';
import 'package:eocout_flutter/features/authentication/register/user_register/user_register_page.dart';
import 'package:eocout_flutter/features/authentication/widget/action_button.dart';
import 'package:eocout_flutter/features/authentication/widget/button_divider.dart';
import 'package:eocout_flutter/features/authentication/widget/google_button.dart';
import 'package:eocout_flutter/features/authentication/widget/password_text_field.dart';
import 'package:eocout_flutter/utils/theme_data.dart';
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
    return MyBackground(
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: ListView(
                    children: [
                      const MyLogo(size: 100),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Masuk",
                        style: textStyle.headlineLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Email',
                        ),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Tidak punya akun?'),
                          TextButton(
                            onPressed: () {
                              navigateTo(
                                  context,
                                  widget.from == null
                                      ? const UserRegisterPage()
                                      : widget.from!,
                                  transition: TransitionType.fadeIn,
                                  replace: true);
                            },
                            child: const Text('Daftar disini'),
                          ),
                        ],
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
