import 'package:eocout_flutter/components/my_background.dart';
import 'package:eocout_flutter/components/my_button_textfield.dart';
import 'package:eocout_flutter/components/my_transition.dart';
import 'package:eocout_flutter/features/authentication/forgot_password/choosen_method_page.dart';
import 'package:eocout_flutter/features/authentication/widget/logo_with_title.dart';
import 'package:eocout_flutter/models/register_data.dart';
import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final registerData = RegisterData();

  @override
  Widget build(BuildContext context) {
    return MyBackground(
      body: Column(
        children: [
          const Expanded(
            child: Align(
              alignment: Alignment.center,
              child: LogoWithTitle(
                  title: "Lupa Password",
                  subtitle: "Pilih metode verifikasi untuk melanjutkan"),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                MyButtonTextField(
                  icon: Icon(Icons.email_outlined, color: colorScheme.outline),
                  label: const Text("Verifikasi dengan Email"),
                  onTap: () {
                    navigateTo(
                        context,
                        const ChoosenMethodPage(
                            choosenMethod: ChoosenForgotPasswordMethod.email));
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                MyButtonTextField(
                  icon: Icon(Icons.person_outlined, color: colorScheme.outline),
                  label: const Text("Verifikasi dengan Username"),
                  onTap: () {
                    navigateTo(
                        context,
                        const ChoosenMethodPage(
                            choosenMethod:
                                ChoosenForgotPasswordMethod.username));
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                MyButtonTextField(
                  icon: Icon(Icons.call_outlined, color: colorScheme.outline),
                  label: const Text("Verifikasi dengan Nomor Telepon"),
                  onTap: () {
                    navigateTo(
                        context,
                        const ChoosenMethodPage(
                            choosenMethod: ChoosenForgotPasswordMethod.phone));
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
