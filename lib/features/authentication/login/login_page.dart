import 'package:eocout_flutter/bloc/authentication/authentication_bloc.dart';
import 'package:eocout_flutter/bloc/authentication/authentication_state.dart';
import 'package:eocout_flutter/components/my_background.dart';
import 'package:eocout_flutter/components/my_snackbar.dart';
import 'package:eocout_flutter/components/my_transition.dart';
import 'package:eocout_flutter/features/authentication/authentication_page.dart';
import 'package:eocout_flutter/features/authentication/forgot_password/forgot_password_page.dart';
import 'package:eocout_flutter/features/authentication/register/eo_register/eo_register_page.dart';
import 'package:eocout_flutter/features/authentication/register/user_register/user_register_page.dart';
import 'package:eocout_flutter/features/authentication/widget/action_button.dart';
import 'package:eocout_flutter/features/authentication/widget/button_divider.dart';
import 'package:eocout_flutter/features/authentication/widget/google_button.dart';
import 'package:eocout_flutter/features/authentication/widget/logo_with_title.dart';
import 'package:eocout_flutter/features/authentication/widget/password_text_field.dart';
import 'package:eocout_flutter/features/dashboard_page.dart';
import 'package:eocout_flutter/models/user_data.dart';
import 'package:eocout_flutter/utils/dummy_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final Widget? from;
  const LoginPage({super.key, this.from});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final bloc = AuthenticationBloc();

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;

        if (widget.from == null) {
          Navigator.pop(context);
          return;
        }
        if (widget.from is UserRegisterPage || widget.from is EORegisterPage) {
          navigateTo(context, widget.from!,
              transition: TransitionType.slideInFromBottom, replace: true);
          return;
        }
        navigateTo(context, const AuthenticationPage(),
            transition: TransitionType.slideInFromBottom, replace: true);
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
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller:
                            TextEditingController(text: "hello@hello.hello"),
                        decoration: const InputDecoration(
                          labelText: 'Email',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email wajib diisi.';
                          }
                          if (!emailRegex.hasMatch(value)) {
                            return 'Email tidak valid.';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      PasswordTextField(
                        controller: TextEditingController(text: "helloHello@1"),
                        onChanged: (value) {},
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      StreamBuilder<AuthenticationState>(
                          stream: bloc.stream,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const AuthActionButton(
                                label: "Not Available",
                                onPressed: null,
                              );
                            }
                            if (snapshot.data!.isAuthenticating) {
                              return const AuthActionButton(
                                label: "Logging in...",
                                onPressed: null,
                              );
                            }
                            if (snapshot.data!.isAuthenticated) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                // TODO : Passing token, dan user data, buat new object untuk terima token dan data user, maybe UserData()
                                navigateTo(
                                    context,
                                    Provider<UserData>.value(
                                        value: dummyData,
                                        child: const DashboardPage()),
                                    transition:
                                        TransitionType.slideInFromBottom,
                                    clearStack: true);
                              });
                            }
                            return AuthActionButton(
                                label: 'Masuk',
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    bloc.login();
                                  } else {
                                    showMySnackBar(
                                        context,
                                        'Mohon periksa kembali data yang diinput.',
                                        SnackbarStatus.error);
                                  }
                                });
                          }),
                      const AuthButtonDivider(),
                      const GoogleAuthButton(),
                      Center(
                        child: TextButton(
                            onPressed: () {
                              navigateTo(context, const ForgotPasswordPage(),
                                  transition: TransitionType.slideInFromBottom);
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
