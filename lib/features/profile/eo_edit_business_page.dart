import 'package:eocout_flutter/bloc/profile/profile_bloc.dart';
import 'package:eocout_flutter/bloc/profile/profile_state.dart';
import 'package:eocout_flutter/components/my_background.dart';
import 'package:eocout_flutter/components/my_business_category_dropdown.dart';
import 'package:eocout_flutter/components/my_important_text.dart';
import 'package:eocout_flutter/components/my_snackbar.dart';
import 'package:eocout_flutter/components/my_transition.dart';
import 'package:eocout_flutter/features/authentication/widget/action_button.dart';
import 'package:eocout_flutter/features/authentication/widget/logo_with_title.dart';
import 'package:eocout_flutter/features/dashboard_page.dart';
import 'package:eocout_flutter/models/profile_data.dart';
import 'package:eocout_flutter/models/user_data.dart';
import 'package:eocout_flutter/utils/app_error.dart';
import 'package:eocout_flutter/utils/business_type_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EOEditBusinessDataPage extends StatefulWidget {
  const EOEditBusinessDataPage({super.key});

  @override
  State<EOEditBusinessDataPage> createState() => _EOEditBusinessDataPageState();
}

class _EOEditBusinessDataPageState extends State<EOEditBusinessDataPage> {
  final _formKey = GlobalKey<FormState>();
  final _nibTEC = TextEditingController();
  late ProfileBloc bloc;
  late EditableProfileData profileData;

  @override
  void initState() {
    bloc = context.read<ProfileBloc>();
    profileData = context.read<EditableProfileData>();
    _nibTEC.text = profileData.businessIdentityNumber;
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
                      controller: _nibTEC,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        label: MyImportantText('NIB (Nomor Induk Berusaha)'),
                      ),
                      onChanged: (value) {
                        profileData.businessIdentityNumber = value;
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
                    MyBusinessCategoryDropdown(
                      selectedBusinessId:
                          profileData.preferredBusinessCategoryId,
                      onChanged:
                          (BusinessType? businessType, String? businessId) {
                        if (businessType == null || businessId == null) return;
                        profileData.preferredBusinessCategoryId = businessId;
                        profileData.preferredBusinessCategory = businessType;
                      },
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    StreamBuilder<ProfileState>(
                        stream: bloc.controller,
                        builder: (context, snapshot) {
                          bool isLoading = !snapshot.hasData ||
                              (snapshot.data?.isLoading ?? false);
                          return AuthActionButton(
                            label: "Lanjut",
                            onPressed: isLoading ? null : _updateEoData,
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

  void _updateEoData() async {
    if (_formKey.currentState!.validate()) {
      AppError? status =
          await bloc.updateProfile(EditableUserData(profileData: profileData));
      if (!mounted) return;
      if (status == null) {
        navigateTo(context, const DashboardPage(), clearStack: true);
        return;
      } else {
        showMySnackBar(context, status.message, SnackbarStatus.error);
        return;
      }
    }
  }
}
