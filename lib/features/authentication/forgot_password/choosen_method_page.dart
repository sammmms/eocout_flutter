import 'package:eocout_flutter/components/my_background.dart';
import 'package:eocout_flutter/components/my_transition.dart';
import 'package:eocout_flutter/features/authentication/register/user_register/otp_page.dart';
import 'package:eocout_flutter/features/authentication/widget/action_button.dart';
import 'package:eocout_flutter/features/authentication/widget/logo_with_title.dart';
import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum ChoosenForgotPasswordMethod { email, phone, username }

class ChoosenForgotPasswordMethodUtil {
  static const Map<ChoosenForgotPasswordMethod, String>
      choosenForgotPasswordMethodMap = {
    ChoosenForgotPasswordMethod.email: "Email",
    ChoosenForgotPasswordMethod.phone: "Nomor Telepon",
    ChoosenForgotPasswordMethod.username: "Username",
  };

  static String textOf(
      ChoosenForgotPasswordMethod choosenForgotPasswordMethod) {
    return choosenForgotPasswordMethodMap[choosenForgotPasswordMethod] ?? "";
  }

  static ChoosenForgotPasswordMethod valueOf(String text) {
    return choosenForgotPasswordMethodMap.entries
        .firstWhere((element) => element.value == text)
        .key;
  }

  static Icon iconOf(ChoosenForgotPasswordMethod choosenForgotPasswordMethod) {
    switch (choosenForgotPasswordMethod) {
      case ChoosenForgotPasswordMethod.email:
        return const Icon(Icons.email_outlined);
      case ChoosenForgotPasswordMethod.phone:
        return const Icon(Icons.phone_outlined);
      case ChoosenForgotPasswordMethod.username:
        return const Icon(Icons.person_outlined);
    }
  }
}

class ChoosenMethodPage extends StatefulWidget {
  final ChoosenForgotPasswordMethod choosenMethod;
  const ChoosenMethodPage({super.key, required this.choosenMethod});

  @override
  State<ChoosenMethodPage> createState() => _ChoosenMethodPageState();
}

class _ChoosenMethodPageState extends State<ChoosenMethodPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return MyBackground(
        body: Column(
      children: [
        Expanded(
          child: Align(
            alignment: AlignmentDirectional.center,
            child: LogoWithTitle(
                title: "Lupa Password",
                subtitle:
                    "Masukkan ${ChoosenForgotPasswordMethodUtil.textOf(widget.choosenMethod)} Anda"),
          ),
        ),
        Expanded(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  inputFormatters: [
                    if (widget.choosenMethod ==
                        ChoosenForgotPasswordMethod.phone)
                      FilteringTextInputFormatter.digitsOnly,
                  ],
                  keyboardType:
                      widget.choosenMethod == ChoosenForgotPasswordMethod.phone
                          ? TextInputType.phone
                          : widget.choosenMethod ==
                                  ChoosenForgotPasswordMethod.email
                              ? TextInputType.emailAddress
                              : TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Mohon masukkan ${ChoosenForgotPasswordMethodUtil.textOf(widget.choosenMethod)} Anda";
                    }
                    RegExp emailRegex =
                        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

                    if (widget.choosenMethod ==
                            ChoosenForgotPasswordMethod.email &&
                        emailRegex.hasMatch(value) == false) {
                      return "Mohon masukkan email yang valid";
                    }

                    if (widget.choosenMethod ==
                            ChoosenForgotPasswordMethod.phone &&
                        value.length < 10) {
                      return "Nomor telepon harus terdiri dari 10 digit";
                    }

                    if (widget.choosenMethod ==
                            ChoosenForgotPasswordMethod.username &&
                        value.length < 4) {
                      return "Username harus terdiri dari 4 karakter";
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: ChoosenForgotPasswordMethodUtil.iconOf(
                        widget.choosenMethod),
                    labelText: ChoosenForgotPasswordMethodUtil.textOf(
                        widget.choosenMethod),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                AuthActionButton(
                  label: "Kirim kode OTP",
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      navigateTo(
                          context,
                          OtpPage(
                            from: widget,
                          ),
                          replace: true);
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Kode OTP akan dikirimkan ke email yang tersambung ke akun Anda.",
                  textAlign: TextAlign.center,
                  style: textStyle.titleSmall,
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
