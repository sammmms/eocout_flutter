import 'package:eocout_flutter/components/my_background.dart';
import 'package:eocout_flutter/components/my_duration_countdown.dart';
import 'package:eocout_flutter/components/my_transition.dart';
import 'package:eocout_flutter/features/authentication/forgot_password/choosen_method_page.dart';
import 'package:eocout_flutter/features/authentication/forgot_password/reset_password_page.dart';
import 'package:eocout_flutter/features/authentication/login/login_page.dart';
import 'package:eocout_flutter/features/authentication/widget/logo_with_title.dart';
import 'package:eocout_flutter/utils/countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OtpPage extends StatefulWidget {
  final Widget? from;
  const OtpPage({super.key, this.from});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final _formKey = GlobalKey<FormState>();
  final _pinInput = TextEditingController();
  final _timer = CountdownTimer();

  @override
  void dispose() {
    _pinInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyBackground(
      body: Form(
        child: Column(
          children: [
            const Expanded(
                flex: 3,
                child: LogoWithTitle(
                  title: 'Verifikasi OTP',
                  subtitle: 'Masukkan kode OTP yang dikirimkan ke email Anda.',
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
                        onChanged: (value) {
                          if (value.length == 4) {
                            FocusScope.of(context).unfocus();
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
                          StreamBuilder<int>(
                              stream: _timer.timer,
                              builder: (context, snapshot) {
                                return TextButton(
                                  onPressed: snapshot.data! > 0
                                      ? null
                                      : () {
                                          _timer.startTimer(30);
                                        },
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

  void _validateAndNavigate() {
    if (_formKey.currentState!.validate()) {
      if (widget.from is ChoosenMethodPage) {
        navigateTo(context, const ResetPasswordPage(), replace: true);
      } else {
        navigateTo(
            context,
            LoginPage(
              from: widget,
            ),
            clearStack: true);
      }
    }
  }
}
