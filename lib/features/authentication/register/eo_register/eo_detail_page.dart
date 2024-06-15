import 'package:eocout_flutter/components/my_background.dart';
import 'package:eocout_flutter/components/my_important_text.dart';
import 'package:eocout_flutter/components/my_logo.dart';
import 'package:eocout_flutter/components/my_snackbar.dart';
import 'package:eocout_flutter/components/my_transition.dart';
import 'package:eocout_flutter/features/authentication/register/eo_register/eo_business_page.dart';
import 'package:eocout_flutter/features/authentication/widget/action_button.dart';
import 'package:eocout_flutter/features/authentication/widget/eo_register_bottomsheet.dart';
import 'package:eocout_flutter/models/register_data.dart';
import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EODetailData extends StatefulWidget {
  const EODetailData({super.key});

  @override
  State<EODetailData> createState() => _EODetailDataState();
}

class _EODetailDataState extends State<EODetailData> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  late EOREgisterData registerData;
  final _provinceTEC = TextEditingController();
  final _cityTEC = TextEditingController();

  @override
  void initState() {
    registerData = context.read<EOREgisterData>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MyBackground(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
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
                      "Pengisian Data Pribadi",
                      style: textStyle.headlineLarge,
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
                        height: 10,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          label: MyImportantText('NIK'),
                        ),
                        onChanged: (value) {
                          registerData.identityNumber = value;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'NIK wajib diisi.';
                          }
                          if (value.length < 16) {
                            return 'NIK harus terdiri dari 16 karakter.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: MyImportantText("Nomor Telepon"),
                        ),
                        onChanged: (value) {
                          registerData.phoneNumber = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nomor telepon wajib diisi.';
                          }
                          if (value.length < 10) {
                            return 'Nomor telepon harus terdiri dari 10 digit';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: GestureDetector(
                            onTap: () async {
                              String? selectedProvince =
                                  await showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      useSafeArea: true,
                                      builder: (context) =>
                                          const EORegisterBottomsheet(
                                            province: null,
                                          ));
                              if (selectedProvince != null) {
                                if (registerData.province != selectedProvince) {
                                  registerData.province = selectedProvince;
                                  registerData.city = null;
                                  _provinceTEC.text = selectedProvince;
                                  _cityTEC.clear();
                                  _formKey.currentState?.validate();
                                }
                              }
                            },
                            child: TextFormField(
                              controller: _provinceTEC,
                              autovalidateMode: AutovalidateMode.always,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Provinsi wajib diisi.';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                enabled: false,
                                disabledBorder: Theme.of(context)
                                    .inputDecorationTheme
                                    .disabledBorder
                                    ?.copyWith(
                                        borderSide: BorderSide(
                                            color: colorScheme.outline)),
                                label: const MyImportantText("Provinsi"),
                              ),
                            ),
                          )),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                if (registerData.province == null) {
                                  showMySnackBar(
                                      context,
                                      "Harap memilih provinsi terlebih dahulu.",
                                      SnackbarStatus.error);
                                  return;
                                }
                                String? selectedCity =
                                    await showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (context) =>
                                            EORegisterBottomsheet(
                                              province: registerData.province,
                                            ));
                                if (selectedCity != null) {
                                  registerData.city = selectedCity;
                                  _cityTEC.text = selectedCity;
                                  _formKey.currentState?.validate();
                                }
                              },
                              child: TextFormField(
                                controller: _cityTEC,
                                autovalidateMode: AutovalidateMode.always,
                                enabled: false,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Kota wajib diisi.';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  label: const MyImportantText('Kota'),
                                  disabledBorder: Theme.of(context)
                                      .inputDecorationTheme
                                      .disabledBorder
                                      ?.copyWith(
                                          borderSide: BorderSide(
                                              color: colorScheme.outline)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                          labelText: 'Nomor Rekening',
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) {
                          registerData.bankAccountNumber = value;
                        },
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null;
                          }
                          if (value.length < 8) {
                            return 'Nomor Rekening harus terdiri dari 8 digit atau lebih.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                          labelText: 'Nomor NPWP',
                        ),
                        onChanged: (value) {
                          registerData.npwpNumber = value;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null;
                          }
                          if (value.length < 8) {
                            return 'Nomor NPWP harus terdiri dari 8 digit atau lebih.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      AuthActionButton(
                        label: "Lanjut",
                        onPressed: () {
                          if (kDebugMode) {
                            print("Register Data: ${registerData.toJson()}");
                          }
                          if (_formKey.currentState!.validate()) {
                            navigateTo(
                              context,
                              Provider<EOREgisterData>.value(
                                  value: registerData,
                                  child: const EOBusinessData()),
                              transition: TransitionType.fadeIn,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
