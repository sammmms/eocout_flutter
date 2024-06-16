import 'package:eocout_flutter/components/my_background.dart';
import 'package:eocout_flutter/components/my_button_textfield.dart';
import 'package:eocout_flutter/components/my_important_text.dart';
import 'package:eocout_flutter/components/my_snackbar.dart';
import 'package:eocout_flutter/components/my_transition.dart';
import 'package:eocout_flutter/features/authentication/register/eo_register/eo_register_business_page.dart';
import 'package:eocout_flutter/features/authentication/widget/action_button.dart';
import 'package:eocout_flutter/features/authentication/widget/eo_register_bottomsheet.dart';
import 'package:eocout_flutter/features/authentication/widget/logo_with_title.dart';
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
  void dispose() {
    _provinceTEC.dispose();
    _cityTEC.dispose();
    super.dispose();
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
              child: LogoWithTitle(
                title: "Masukkan Data Anda",
                subtitle:
                    "Data yang dimasukkan akan digunakan untuk keperluan verifikasi",
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
                            child: MyButtonTextField(
                          icon: Icon(Icons.location_on_outlined,
                              color: colorScheme.outline),
                          label: const MyImportantText("Provinsi"),
                          controller: _provinceTEC,
                          onTap: () async {
                            String? selectedProvince =
                                await showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    useSafeArea: true,
                                    builder: (context) =>
                                        const EORegisterBottomsheet());
                            if (selectedProvince != null) {
                              if (registerData.province != selectedProvince) {
                                registerData.province = selectedProvince;
                                _provinceTEC.text = selectedProvince;
                                _cityTEC.text = "";
                                _formKey.currentState?.validate();
                              }
                            }
                          },
                        )),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: MyButtonTextField(
                            icon: Icon(Icons.location_city_outlined,
                                color: colorScheme.outline),
                            label: const MyImportantText("Kota"),
                            onTap: () async {
                              if (registerData.province == null) {
                                showMySnackBar(
                                    context,
                                    "Pilih provinsi terlebih dahulu.",
                                    SnackbarStatus.error);
                                return;
                              }
                              String? selectedCity = await showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  useSafeArea: true,
                                  builder: (context) => EORegisterBottomsheet(
                                        province: registerData.province,
                                      ));
                              if (selectedCity != null) {
                                if (registerData.city != selectedCity) {
                                  registerData.city = selectedCity;
                                  _cityTEC.text = selectedCity;
                                  _formKey.currentState?.validate();
                                }
                              }
                            },
                            controller: _cityTEC,
                            autovalidateMode: AutovalidateMode.always,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Kota wajib diisi.';
                              }
                              return null;
                            },
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
    );
  }
}
