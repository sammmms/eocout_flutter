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
import 'package:eocout_flutter/models/login_data.dart';
import 'package:eocout_flutter/utils/app_error.dart';
import 'package:eocout_flutter/utils/data.dart';
import 'package:eocout_flutter/utils/role_type_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final Widget? from;
  const LoginPage({super.key, this.from});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailTEC = TextEditingController();
  final _passwordTEC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late AuthBloc bloc;
  final loginData = LoginData();

  @override
  void initState() {
    bloc = context.read<AuthBloc>();
    super.initState();
  }

  @override
  void dispose() {
    _emailTEC.dispose();
    _passwordTEC.dispose();
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
                        controller: _emailTEC,
                        onChanged: (value) {
                          loginData.email = value;
                        },
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
                        controller: _passwordTEC,
                        onChanged: (value) {
                          loginData.password = value;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Expanded(child: Text("Masuk sebagai :")),
                          const SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: DropdownButton<UserRole>(
                              isExpanded: true,
                              value: loginData.role,
                              onChanged: (UserRole? value) {
                                setState(() {
                                  loginData.role = value!;
                                });
                              },
                              items: UserRole.values.map((UserRole value) {
                                return DropdownMenuItem<UserRole>(
                                  value: value,
                                  child:
                                      Text(UserRoleUtil.readableTextOf(value)),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
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
                                label: "Masuk",
                                onPressed: isLoading ? null : _loginUser);
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

  void _loginUser() async {
    if (_formKey.currentState!.validate()) {
      if (kDebugMode) {
        print("Login data : ${loginData.toJson()}");
      }
      AppError? status = await bloc.login(loginData);
      if (status == null) {
        if (!mounted) return;
        navigateTo(context, const DashboardPage(),
            transition: TransitionType.fadeIn, clearStack: true);
        return;
      }
      if (!mounted) return;
      showMySnackBar(context, status.message, SnackbarStatus.error);
    }
  }
}
