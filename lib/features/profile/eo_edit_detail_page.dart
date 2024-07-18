import 'package:eocout_flutter/bloc/profile/profile_bloc.dart';
import 'package:eocout_flutter/components/my_background.dart';
import 'package:eocout_flutter/components/my_button_textfield.dart';
import 'package:eocout_flutter/components/my_important_text.dart';
import 'package:eocout_flutter/components/my_snackbar.dart';
import 'package:eocout_flutter/components/my_transition.dart';
import 'package:eocout_flutter/features/profile/eo_edit_business_page.dart';
import 'package:eocout_flutter/features/authentication/widget/action_button.dart';
import 'package:eocout_flutter/features/authentication/widget/eo_register_bottomsheet.dart';
import 'package:eocout_flutter/features/authentication/widget/logo_with_title.dart';
import 'package:eocout_flutter/models/profile_data.dart';
import 'package:eocout_flutter/models/user_data.dart';
import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EOEditDetailDataPage extends StatefulWidget {
  final bool canPop;
  const EOEditDetailDataPage({super.key, this.canPop = false});

  @override
  State<EOEditDetailDataPage> createState() => _EOEditDetailDataPageState();
}

class _EOEditDetailDataPageState extends State<EOEditDetailDataPage> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  late EditableProfileData profileData;
  final _nikTEC = TextEditingController();
  final _phoneTEC = TextEditingController();
  final _provinceTEC = TextEditingController();
  final _cityTEC = TextEditingController();
  final _bankNumberTEC = TextEditingController();
  final _npwpTEC = TextEditingController();

  @override
  void initState() {
    final UserData userData =
        context.read<ProfileBloc>().controller.valueOrNull?.profile ??
            UserData();

    if (kDebugMode) {
      print(userData.toString());
    }

    profileData = EditableProfileData.fromProfileData(userData.profileData);

    _nikTEC.text = profileData.identityNumber;
    _phoneTEC.text = profileData.phoneNumber;
    _provinceTEC.text = profileData.province ?? "";
    _cityTEC.text = profileData.city;
    _bankNumberTEC.text = profileData.bankNumber;
    _npwpTEC.text = profileData.taxIdentityNumber;
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
    return PopScope(
      canPop: widget.canPop,
      child: MyBackground(
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
                        controller: _nikTEC,
                        decoration: const InputDecoration(
                          label: MyImportantText('NIK'),
                        ),
                        onChanged: (value) {
                          profileData.identityNumber = value;
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
                        controller: _phoneTEC,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: MyImportantText("Nomor Telepon"),
                        ),
                        onChanged: (value) {
                          profileData.phoneNumber = value;
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Provinsi wajib diisi.';
                              }
                              return null;
                            },
                            onTap: () async {
                              FocusScope.of(context).requestFocus(FocusNode());
                              String? selectedProvince =
                                  await showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      useSafeArea: true,
                                      builder: (context) =>
                                          const EORegisterBottomsheet());
                              if (selectedProvince != null) {
                                if (profileData.province != selectedProvince) {
                                  profileData.province = selectedProvince;
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
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                if (profileData.province == null ||
                                    profileData.province!.isEmpty) {
                                  showMySnackBar(
                                      context,
                                      "Pilih provinsi terlebih dahulu.",
                                      SnackbarStatus.error);
                                  return;
                                }
                                String? selectedCity =
                                    await showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        useSafeArea: true,
                                        builder: (context) =>
                                            EORegisterBottomsheet(
                                              province: profileData.province,
                                            ));
                                if (selectedCity != null) {
                                  if (profileData.city != selectedCity) {
                                    profileData.city = selectedCity;
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
                        controller: _bankNumberTEC,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                          labelText: 'Nomor Rekening',
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) {
                          profileData.bankNumber = value;
                        },
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Nomor Rekening wajib diisi.";
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
                        controller: _npwpTEC,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                          labelText: 'Nomor NPWP',
                        ),
                        onChanged: (value) {
                          profileData.taxIdentityNumber = value;
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
                            print("Register Data: ${profileData.toJson()}");
                          }
                          if (_formKey.currentState!.validate()) {
                            navigateTo(
                              context,
                              Provider<EditableProfileData>.value(
                                  value: profileData,
                                  child: const EOEditBusinessDataPage()),
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
