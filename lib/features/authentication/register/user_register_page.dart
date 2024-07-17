import 'package:eocout_flutter/bloc/authentication/authentication_bloc.dart';
import 'package:eocout_flutter/bloc/authentication/authentication_state.dart';
import 'package:eocout_flutter/components/my_background.dart';
import 'package:eocout_flutter/components/my_logo.dart';
import 'package:eocout_flutter/components/my_snackbar.dart';
import 'package:eocout_flutter/components/my_transition.dart';
import 'package:eocout_flutter/features/authentication/login/login_page.dart';
import 'package:eocout_flutter/features/authentication/register/otp_page.dart';
import 'package:eocout_flutter/features/authentication/widget/action_button.dart';
import 'package:eocout_flutter/features/authentication/widget/button_divider.dart';
import 'package:eocout_flutter/features/authentication/widget/google_button.dart';
import 'package:eocout_flutter/features/authentication/widget/password_text_field.dart';
import 'package:eocout_flutter/models/register_data.dart';
import 'package:eocout_flutter/utils/app_error.dart';
import 'package:eocout_flutter/utils/data.dart';
import 'package:eocout_flutter/utils/store.dart';
import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserRegisterPage extends StatefulWidget {
  const UserRegisterPage({super.key});

  @override
  State<UserRegisterPage> createState() => _UserRegisterPageState();
}

class _UserRegisterPageState extends State<UserRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  final registerSubject = RegisterData();
  late AuthBloc bloc;

  @override
  void initState() {
    bloc = context.read<AuthBloc>();
    super.initState();
  }

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
                    style: textTheme.headlineLarge,
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
                        registerSubject.username = value;
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
                    PasswordTextField(
                      onChanged: (value) {
                        registerSubject.password = value;
                      },
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    StreamBuilder<AuthState>(
                        stream: bloc.stream,
                        builder: (context, snapshot) {
                          bool isLoading = !snapshot.hasData ||
                              (snapshot.data?.isAuthenticating ?? false);
                          return AuthActionButton(
                            label: "Daftar",
                            onPressed: isLoading ? null : _registerUser,
                          );
                        }),
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

  void _registerUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      AppError? status = await bloc.register(registerSubject);
      if (!mounted) return;
      if (status == null) {
        showMySnackBar(
            context,
            "Registrasi berhasil, silahkan login kembali untuk verifikasi",
            SnackbarStatus.success);
        await Store.saveResendOTPTime();
        if (!mounted) return;
        navigateTo(context, const OtpPage(from: UserRegisterPage()),
            transition: TransitionType.slideInFromBottom, replace: true);
        return;
      }
      showMySnackBar(context, status.message, SnackbarStatus.error);
    }
  }
}
