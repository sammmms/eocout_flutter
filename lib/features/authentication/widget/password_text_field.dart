import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class PasswordTextField extends StatefulWidget {
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final String? label;
  final Function(String)? validator;
  const PasswordTextField(
      {super.key, this.onChanged, this.controller, this.label, this.validator});

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  final _mustObscure = BehaviorSubject<bool>.seeded(true);

  @override
  void dispose() {
    _mustObscure.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: _mustObscure,
        initialData: true,
        builder: (context, snapshot) {
          return TextFormField(
            controller: widget.controller,
            onChanged: widget.onChanged,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              labelText: widget.label ?? 'Password',
              suffixIcon: GestureDetector(
                onTap: () {
                  _mustObscure.add(!_mustObscure.value);
                },
                child: Icon(
                    snapshot.data! ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey.withOpacity(0.6)),
              ),
            ),
            obscureText: snapshot.data!,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password wajib diisi.';
              }
              if (value.length < 8) {
                return 'Password minimal 8 karakter.';
              }
              RegExp passwordRegex = RegExp(
                  r'((?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[^A-Za-z0-9]).{8,64})');
              if (passwordRegex.hasMatch(value) == false) {
                return 'Password harus mengandung setidaknya satu huruf besar, satu huruf kecil, satu angka, dan satu karakter spesial.';
              }
              if (widget.validator != null) {
                return widget.validator!(value);
              }
              return null;
            },
          );
        });
  }
}
