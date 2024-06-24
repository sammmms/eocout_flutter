import 'package:eocout_flutter/bloc/authentication/authentication_bloc.dart';
import 'package:eocout_flutter/bloc/authentication/authentication_state.dart';
import 'package:eocout_flutter/components/my_background.dart';
import 'package:eocout_flutter/components/my_important_text.dart';
import 'package:eocout_flutter/components/my_snackbar.dart';
import 'package:eocout_flutter/components/my_transition.dart';
import 'package:eocout_flutter/features/authentication/register/user_register/otp_page.dart';
import 'package:eocout_flutter/features/authentication/widget/action_button.dart';
import 'package:eocout_flutter/features/authentication/widget/logo_with_title.dart';
import 'package:eocout_flutter/models/register_data.dart';
import 'package:eocout_flutter/utils/business_type_util.dart';
import 'package:eocout_flutter/utils/error_status.dart';
import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class EOBusinessData extends StatefulWidget {
  const EOBusinessData({super.key});

  @override
  State<EOBusinessData> createState() => _EOBusinessDataState();
}

class _EOBusinessDataState extends State<EOBusinessData> {
  final _formKey = GlobalKey<FormState>();
  final _businessSelection = BehaviorSubject<BusinessType?>();
  late EOREgisterData registerData;
  late AuthBloc bloc;

  @override
  void initState() {
    registerData = context.read<EOREgisterData>();
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
            const Expanded(
                flex: 3,
                child: LogoWithTitle(title: "Masukkan Data Bisnis Anda")),
            Expanded(
              flex: 7,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        label: MyImportantText('NIB (Nomor Induk Berusaha)'),
                      ),
                      onChanged: (value) {
                        registerData.identityNumber = value;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'NIB wajib diisi.';
                        }
                        if (value.length < 13) {
                          return 'NIB harus terdiri dari 13 digit';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    StreamBuilder<BusinessType?>(
                        stream: _businessSelection,
                        initialData: registerData.businessType,
                        builder: (context, snapshot) {
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: colorScheme.outline,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: 55,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                  borderRadius: BorderRadius.circular(20),
                                  isExpanded: true,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  items: BusinessType.values
                                      .map((BusinessType businessType) =>
                                          DropdownMenuItem<BusinessType>(
                                              value: businessType,
                                              child: Text(
                                                  BusinessTypeUtil.textOf(
                                                      businessType))))
                                      .toList(),
                                  onChanged: (value) {
                                    registerData.businessType = value;
                                    _businessSelection.add(value);
                                  },
                                  hint: const Text("Pilih Kategori"),
                                  value: snapshot.data),
                            ),
                          );
                        }),
                    const SizedBox(
                      height: 60,
                    ),
                    StreamBuilder<AuthState>(
                        stream: bloc.stream,
                        builder: (context, snapshot) {
                          bool isLoading = !snapshot.hasData ||
                              (snapshot.data?.isAuthenticating ?? false);
                          return AuthActionButton(
                            label: "Lanjut",
                            onPressed: isLoading ? null : _registerEO,
                          );
                        }),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _registerEO() async {
    if (_formKey.currentState!.validate()) {
      ErrorStatus? status = await bloc.register(registerData);
      if (status == null) {
        if (!mounted) return;
        navigateTo(
          context,
          const OtpPage(),
          transition: TransitionType.fadeIn,
        );
        return;
      }
      if (!mounted) return;
      showMySnackBar(context, status.message, SnackbarStatus.error);
    }
  }
}
