import 'package:eocout_flutter/components/my_background.dart';
import 'package:eocout_flutter/components/my_snackbar.dart';
import 'package:eocout_flutter/components/my_transition.dart';
import 'package:eocout_flutter/features/authentication/login/login_page.dart';
import 'package:eocout_flutter/features/authentication/widget/action_button.dart';
import 'package:eocout_flutter/features/authentication/widget/logo_with_title.dart';
import 'package:eocout_flutter/features/authentication/widget/password_text_field.dart';
import 'package:flutter/material.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordTEC = TextEditingController();
  final _confirmPasswordTEC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MyBackground(
        body: Column(
      children: [
        const Expanded(
          flex: 4,
          child: Align(
            alignment: AlignmentDirectional.center,
            child: LogoWithTitle(
              title: "Reset Password",
              subtitle: "Masukkan password baru yang ingin Anda gunakan",
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  PasswordTextField(
                    controller: _passwordTEC,
                    label: "Password Baru",
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  PasswordTextField(
                    controller: _confirmPasswordTEC,
                    label: "Konfirmasi Password Baru",
                    validator: (value) {
                      if (value != _passwordTEC.text) {
                        return 'Password tidak sama.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  AuthActionButton(
                    label: "Reset Password",
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        showMySnackBar(context, "Password berhasil diubah",
                            SnackbarStatus.success);
                        navigateTo(
                            context,
                            LoginPage(
                              from: widget,
                            ),
                            transition: TransitionType.slideInFromBottom,
                            clearStack: true);
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        )
      ],
    ));
  }
}
