import 'package:eocout_flutter/components/my_background.dart';
import 'package:eocout_flutter/components/my_logo.dart';
import 'package:eocout_flutter/components/my_transition.dart';
import 'package:eocout_flutter/features/authentication/login/login_page.dart';
import 'package:eocout_flutter/features/authentication/register/user_register/otp_page.dart';
import 'package:eocout_flutter/features/authentication/widget/action_button.dart';
import 'package:eocout_flutter/features/authentication/widget/button_divider.dart';
import 'package:eocout_flutter/features/authentication/widget/google_button.dart';
import 'package:eocout_flutter/features/authentication/widget/password_text_field.dart';
import 'package:eocout_flutter/models/register_data.dart';
import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';

class UserRegisterPage extends StatefulWidget {
  const UserRegisterPage({super.key});

  @override
  State<UserRegisterPage> createState() => _UserRegisterPageState();
}

class _UserRegisterPageState extends State<UserRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  final registerData = RegisterData();

  @override
  Widget build(BuildContext context) {
    return MyBackground(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                    "Daftar Sebagai Pengguna",
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
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: _scrollController,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Username',
                      ),
                      onChanged: (value) {
                        registerData.username = value;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Username wajib diisi.';
                        }
                        if (value.length < 4) {
                          return 'Username minimal 4 karakter.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                      onChanged: (value) {
                        registerData.email = value;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email wajib diisi.';
                        }
                        RegExp emailRegex = RegExp(
                            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");
                        if (emailRegex.hasMatch(value) == false) {
                          return 'Email tidak valid.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    PasswordTextField(
                      onChanged: (value) {
                        registerData.password = value;
                      },
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    AuthActionButton(
                      label: "Daftar",
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          navigateTo(
                            context,
                            const OtpPage(),
                            transition: TransitionType.fadeIn,
                          );
                        }
                      },
                    ),
                    const AuthButtonDivider(),
                    const GoogleAuthButton(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Sudah memiliki akun?'),
                        TextButton(
                          onPressed: () {
                            navigateTo(
                                context,
                                LoginPage(
                                  from: widget,
                                ),
                                transition: TransitionType.fadeIn,
                                replace: true);
                          },
                          child: const Text('Masuk'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
