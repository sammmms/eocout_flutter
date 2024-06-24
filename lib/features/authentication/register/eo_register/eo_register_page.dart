import 'package:eocout_flutter/components/my_background.dart';
import 'package:eocout_flutter/components/my_transition.dart';
import 'package:eocout_flutter/features/authentication/login/login_page.dart';
import 'package:eocout_flutter/features/authentication/register/eo_register/eo_register_detail_page.dart';
import 'package:eocout_flutter/features/authentication/widget/action_button.dart';
import 'package:eocout_flutter/features/authentication/widget/button_divider.dart';
import 'package:eocout_flutter/features/authentication/widget/google_button.dart';
import 'package:eocout_flutter/features/authentication/widget/logo_with_title.dart';
import 'package:eocout_flutter/features/authentication/widget/password_text_field.dart';
import 'package:eocout_flutter/models/register_data.dart';
import 'package:eocout_flutter/utils/data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EORegisterPage extends StatefulWidget {
  const EORegisterPage({super.key});

  @override
  State<EORegisterPage> createState() => _EORegisterPageState();
}

class _EORegisterPageState extends State<EORegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final registerSubject = EOREgisterData();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyBackground(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Expanded(
                flex: 3,
                child: LogoWithTitle(
                  title: "Daftar sebagai \nEvent Organizer atau Vendor",
                )),
            Expanded(
              flex: 7,
              child: SingleChildScrollView(
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
                        registerSubject.username = value;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Username wajib diisi.';
                        }
                        if (value.length < 4) {
                          return 'Username harus terdiri dari 4 karakter atau lebih.';
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
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        registerSubject.email = value;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email wajib diisi.';
                        }
                        if (emailRegex.hasMatch(value) == false) {
                          return 'Email tidak valid.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    PasswordTextField(onChanged: (value) {
                      registerSubject.password = value;
                    }),
                    const SizedBox(
                      height: 60,
                    ),
                    AuthActionButton(
                      label: "Daftar",
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (kDebugMode) {
                            print(
                                'Register Data : ${registerSubject.toJson()}');
                          }
                          navigateTo(
                            context,
                            Provider<EOREgisterData>.value(
                                value: registerSubject,
                                child: const EODetailData()),
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
                        const Text('Sudah punya akun?'),
                        TextButton(
                          onPressed: () {
                            navigateTo(
                                context,
                                LoginPage(
                                  from: widget,
                                ),
                                transition: TransitionType.slideInFromBottom,
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
