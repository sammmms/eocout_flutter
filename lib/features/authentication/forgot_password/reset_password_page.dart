import 'package:eocout_flutter/components/my_background.dart';
import 'package:eocout_flutter/features/authentication/widget/logo_with_title.dart';
import 'package:flutter/material.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MyBackground(
        body: Column(
      children: [
        const Expanded(
          child: Align(
            alignment: Alignment.center,
            child: LogoWithTitle(
              title: "Reset Password",
              subtitle: "Masukkan password baru yang ingin Anda gunakan.",
            ),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              TextFormField(
                validator: (value) {
                  RegExp passwordRegex = RegExp(
                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                  if (value!.isEmpty) {
                    return 'Password wajib diisi.';
                  }
                  if (value.length < 8) {
                    return 'Password minimal 8 karakter.';
                  }
                  if (passwordRegex.hasMatch(value) == false) {
                    return 'Password harus mengandung setidaknya satu huruf besar, satu huruf kecil, satu angka, dan satu karakter spesial.';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  labelText: "Password Baru",
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                validator: (value) {
                  RegExp passwordRegex = RegExp(
                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                  if (value!.isEmpty) {
                    return 'Password wajib diisi.';
                  }
                  if (value.length < 8) {
                    return 'Password minimal 8 karakter.';
                  }
                  if (passwordRegex.hasMatch(value) == false) {
                    return 'Password harus mengandung setidaknya satu huruf besar, satu huruf kecil, satu angka, dan satu karakter spesial.';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  labelText: "Konfirmasi Password Baru",
                ),
              ),
              const SizedBox(
                height: 60,
              ),
            ],
          ),
        )
      ],
    ));
  }
}
