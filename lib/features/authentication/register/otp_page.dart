import 'package:eocout_flutter/bloc/authentication/authentication_bloc.dart';
import 'package:eocout_flutter/components/my_background.dart';
import 'package:eocout_flutter/components/my_duration_countdown.dart';
import 'package:eocout_flutter/components/my_snackbar.dart';
import 'package:eocout_flutter/components/my_transition.dart';
import 'package:eocout_flutter/features/authentication/widget/logo_with_title.dart';
import 'package:eocout_flutter/features/dashboard_page.dart';
import 'package:eocout_flutter/features/welcome_page.dart';
import 'package:eocout_flutter/utils/app_error.dart';
import 'package:eocout_flutter/utils/countdown_timer.dart';
import 'package:eocout_flutter/utils/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final _formKey = GlobalKey<FormState>();
  final _pinInput = TextEditingController();
  final _timer = CountdownTimer();
  late AuthBloc _authBloc;
  String? token;

  @override
  void initState() {
    _authBloc = context.read<AuthBloc>();

    // Remove token on land to page OTP, to prevent user from going to this page on launch (when not verified)

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      token = await Store.removeToken();
      DateTime? resendTime = await Store.getResendOTPTime();

      // Check if resend time is not null
      if (resendTime != null) {
        int diff = DateTime.now().difference(resendTime).inSeconds;
        if (diff > 0) {
          _timer.startTimer(60 - diff);
          return;
        } else {
          await Store.removeResendOTPTime();
        }
      }

      _trySendOTPCode();
    });

    super.initState();
  }

  @override
  void dispose() {
    _pinInput.dispose();
    _timer.cancelTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyBackground(
      body: Form(
        child: Column(
          children: [
            Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    const LogoWithTitle(
                      title: 'Verifikasi OTP',
                      subtitle:
                          'Masukkan kode OTP yang dikirimkan ke email Anda.',
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          navigateTo(context, const WelcomePage(),
                              clearStack: true);
                        },
                      ),
                    ),
                  ],
                )),
            Form(
              key: _formKey,
              child: Expanded(
                flex: 7,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      Pinput(
                        controller: _pinInput,
                        length: 6,
                        onChanged: (value) {
                          if (value.length == 6) {
                            FocusScope.of(context).requestFocus(FocusNode());
                            _validateAndNavigate();
                          }
                        },
                        pinputAutovalidateMode: PinputAutovalidateMode.disabled,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Kode OTP wajib diisi.';
                          }
                          if (value.length < 4) {
                            return 'Kode OTP harus 4 digit.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 60),
                      SizedBox(
                        height: 60,
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: _validateAndNavigate,
                          child: const Text('Verifikasi OTP'),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DurationCountdown(
                              timer: _timer,
                              builder: (context, remainingTime) {
                                if (remainingTime <= 0) {
                                  return const SizedBox();
                                }
                                return Text(
                                    'Kirim ulang kode dalam $remainingTime detik');
                              }),
                          const SizedBox(
                            width: 10,
                          ),
                          StreamBuilder<int>(
                              stream: _timer.timer,
                              builder: (context, snapshot) {
                                return TextButton(
                                  onPressed: (snapshot.data ?? 0) > 0
                                      ? null
                                      : _trySendOTPCode,
                                  child: const Text('Kirim kode'),
                                );
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _validateAndNavigate() async {
    if (_formKey.currentState!.validate()) {
      AppError? error = await _authBloc.verifyEmail(_pinInput.text);

      if (!mounted) return;
      if (error != null) {
        showMySnackBar(context, error.message, SnackbarStatus.error);
        return;
      }

      showMySnackBar(
          context, "Email berhasil diverfiikasi", SnackbarStatus.success);

      await Store.saveToken(token!);

      var response = await _authBloc.checkLogin();

      if (!mounted) return;

      if (response is AppError) {
        showMySnackBar(context, response.message, SnackbarStatus.error);
        return;
      }

      navigateTo(context, const DashboardPage(), clearStack: true);
    }
  }

  void _trySendOTPCode() async {
    AppError? error = await _authBloc.resendOTPCode();

    if (!mounted) return;

    if (error != null) {
      showMySnackBar(context, error.message, SnackbarStatus.error);
      if (error.code == 401) {
        navigateTo(context, const WelcomePage(), clearStack: true);
        return;
      }
      return;
    }

    _timer.startTimer(60);

    showMySnackBar(
        context,
        "Kode OTP dikirim ke email anda. \nSilahkan cek email anda.",
        SnackbarStatus.success);
  }
}
