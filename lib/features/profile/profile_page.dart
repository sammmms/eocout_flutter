import 'dart:io';
import 'package:collection/collection.dart';
import 'package:eocout_flutter/bloc/authentication/authentication_bloc.dart';
import 'package:eocout_flutter/bloc/authentication/authentication_state.dart';
import 'package:eocout_flutter/bloc/category/category_state.dart';
import 'package:eocout_flutter/bloc/profile/profile_bloc.dart';
import 'package:eocout_flutter/components/my_avatar_loader.dart';
import 'package:eocout_flutter/components/my_confirmation_dialog.dart';
import 'package:eocout_flutter/components/my_error_component.dart';
import 'package:eocout_flutter/components/my_loading_dialog.dart';
import 'package:eocout_flutter/components/my_pick_image.dart';
import 'package:eocout_flutter/components/my_snackbar.dart';
import 'package:eocout_flutter/components/my_transition.dart';
import 'package:eocout_flutter/features/profile/eo_edit_detail_page.dart';
import 'package:eocout_flutter/features/welcome_page.dart';
import 'package:eocout_flutter/models/profile_data.dart';
import 'package:eocout_flutter/models/user_data.dart';
import 'package:eocout_flutter/utils/app_error.dart';
import 'package:eocout_flutter/utils/service_type_util.dart';
import 'package:eocout_flutter/utils/role_type_util.dart';
import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final List<EOCategory> categories;
  const ProfilePage({super.key, this.categories = const []});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late EditableUserData editableUserData;
  final _formKey = GlobalKey<FormState>();

  late ProfileBloc bloc;
  late AuthBloc _authBloc;

  bool isEdit = false;

  @override
  void initState() {
    bloc = context.read<ProfileBloc>();
    _authBloc = bloc.authBloc;

    _authBloc.controller.listen((event) {
      if (event.user != null) {
        editableUserData = EditableUserData.fromUserData(event.user!);
      }
    });

    if (_authBloc.state?.user != null) {
      editableUserData = EditableUserData.fromUserData(_authBloc.state!.user!);
    } else {
      editableUserData = EditableUserData();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        leading: StreamBuilder<AuthState>(
            stream: _authBloc.controller,
            builder: (context, snapshot) {
              UserData? user = snapshot.data?.user;
              return IconButton(
                onPressed: () async {
                  if (user == null) {
                    Navigator.pop(context);
                  }
                  bool notEdited = editableUserData.isEquals(user!);
                  if (isEdit && !notEdited) {
                    Confirmation? confirmedEdit = await showDialog(
                        context: context,
                        builder: (context) => const MyConfirmationDialog(
                              label: "Apakah anda ingin menghapus perubahan?",
                              subLabel:
                                  "Anda akan meninggalkan halaman ini, dan menghapus semua perubahan.",
                              negativeLabel: "Hapus",
                              positiveLabel: "Tidak",
                            ));
                    if (confirmedEdit == null ||
                        confirmedEdit == Confirmation.positive) {
                      return;
                    }
                  }
                  if (!context.mounted) return;
                  Navigator.pop(context);
                },
                style: const ButtonStyle(
                  shape: WidgetStatePropertyAll(CircleBorder()),
                  backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                ),
                icon: const Icon(Icons.arrow_back),
              );
            }),
        actions: [
          StreamBuilder<AuthState>(
              stream: _authBloc.controller,
              builder: (context, snapshot) {
                UserData? user = snapshot.data?.user;
                if (user == null) {
                  return const SizedBox();
                }
                return IconButton(
                    style: const ButtonStyle(
                      shape: WidgetStatePropertyAll(CircleBorder()),
                      backgroundColor:
                          WidgetStatePropertyAll(Colors.transparent),
                    ),
                    onPressed: !isEdit
                        ? () {
                            setState(() {
                              isEdit = !isEdit;
                            });
                          }
                        : () => _saveChanges(user),
                    icon: isEdit
                        ? SvgPicture.asset(
                            "assets/svg/save_icon.svg",
                            // ignore: deprecated_member_use
                            color: colorScheme.onBackground,
                            width: 20,
                          )
                        : SvgPicture.asset(
                            "assets/svg/edit_icon.svg",
                            // ignore: deprecated_member_use
                            color: colorScheme.onBackground,
                            width: 20,
                          ));
              })
        ],
      ),
      body: RefreshIndicator(
        onRefresh: isEdit
            ? () async {}
            : () async {
                await _authBloc.refreshProfile();
              },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: StreamBuilder<AuthState>(
                stream: _authBloc.controller,
                builder: (context, snapshot) {
                  if (snapshot.data?.user == null || !snapshot.hasData) {
                    return MyErrorComponent(
                      onRefresh: () {
                        _authBloc.refreshProfile();
                      },
                      error: snapshot.data?.error,
                    );
                  }

                  UserData user = snapshot.data!.user!;
                  return Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              _showProfilePicture(user, editableUserData),
                              const SizedBox(
                                height: 10,
                              ),
                              isEdit
                                  ? TextFormField(
                                      onChanged: (value) {
                                        editableUserData.username = value;
                                      },
                                      decoration: InputDecoration(
                                        constraints:
                                            const BoxConstraints(maxWidth: 200),
                                        contentPadding: EdgeInsets.zero,
                                        hintText: user.username.isEmpty
                                            ? "Username"
                                            : user.username,
                                        enabledBorder:
                                            const UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                        ),
                                        focusedBorder:
                                            const UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                        ),
                                      ),
                                      style: textTheme.headlineMedium!,
                                      textAlign: TextAlign.center,
                                    )
                                  : Text(
                                      user.username.isEmpty
                                          ? "Username"
                                          : user.username,
                                      style: textTheme.headlineMedium!.copyWith(
                                        color: user.username.isEmpty
                                            ? Colors.grey
                                            : Colors.black,
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        _showLabel(label: "Email", value: user.email),
                        const SizedBox(
                          height: 10,
                        ),
                        isEdit
                            ? _editTextField(
                                label: "Nama Lengkap",
                                value: user.fullname,
                                onChanged: (value) {
                                  editableUserData.fullname = value;
                                })
                            : _showLabel(
                                label: "Nama Lengkap", value: user.fullname),
                        const SizedBox(
                          height: 10,
                        ),
                        isEdit
                            ? _editTextField(
                                label: "Alamat",
                                value: user.address,
                                onChanged: (value) {
                                  editableUserData.address = value;
                                })
                            : _showLabel(label: "Alamat", value: user.address),
                        const SizedBox(
                          height: 10,
                        ),
                        isEdit
                            ? _editTextField(
                                label: "Nomor Telepon",
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Nomor telepon tidak boleh kosong";
                                  }
                                  if (value.length < 10) {
                                    return "Nomor telepon minimal 10 digit";
                                  }
                                  return null;
                                },
                                value: user.profileData?.phoneNumber ?? "",
                                onChanged: (value) {
                                  editableUserData.profileData.phoneNumber =
                                      value;
                                })
                            : _showLabel(
                                label: "Nomor Telepon",
                                value: user.profileData?.phoneNumber ?? ""),
                        const SizedBox(
                          height: 20,
                        ),
                        if (user.role == UserRole.eventOrganizer)
                          Theme(
                            data: Theme.of(context).copyWith(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                            ),
                            child: ExpansionTile(
                                dense: true,
                                tilePadding: EdgeInsets.zero,
                                expandedCrossAxisAlignment:
                                    CrossAxisAlignment.start,
                                expandedAlignment: Alignment.centerLeft,
                                title: Row(
                                  children: [
                                    Text("Data Bisnis",
                                        style: textTheme.headlineSmall),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const Expanded(child: Divider()),
                                  ],
                                ),
                                childrenPadding: EdgeInsets.zero,
                                collapsedShape: const RoundedRectangleBorder(),
                                shape: const RoundedRectangleBorder(),
                                children: _showBusinessField(user)),
                          ),
                        const SizedBox(
                          height: 40,
                        ),
                        if (!isEdit) ...[
                          const Divider(),
                          const SizedBox(
                            height: 20,
                          ),
                          InkWell(
                              onTap: () {
                                _authBloc.logout();
                                navigateTo(context, const WelcomePage(),
                                    clearStack: true);
                              },
                              child: Container(
                                width: double.infinity,
                                color: Colors.transparent,
                                child: Text(
                                  "Keluar",
                                  style: textTheme.labelLarge!.copyWith(
                                      color: colorScheme.error,
                                      fontWeight: FontWeight.w400),
                                ),
                              ))
                        ]
                      ],
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }

  List<Widget> _showBusinessField(UserData user) {
    ProfileData profileData = user.profileData ?? ProfileData.empty();
    ServiceType? businessType = widget.categories
        .firstWhereOrNull(
            (element) => element.id == profileData.preferredBusinessCategoryId)
        ?.serviceType;
    return [
      const SizedBox(
        height: 10,
      ),
      _showLabel(label: "Nomor Identitas", value: profileData.identityNumber),
      const SizedBox(
        height: 10,
      ),
      _showLabel(label: "Nomor Rekening", value: profileData.bankNumber),
      const SizedBox(
        height: 10,
      ),
      _showLabel(label: "Nomor NPWP", value: profileData.taxIdentityNumber),
      const SizedBox(
        height: 10,
      ),
      _showLabel(label: "Nomor NIB", value: profileData.businessIdentityNumber),
      const SizedBox(
        height: 10,
      ),
      _showLabel(
          label: "Lokasi saat ini",
          value: profileData.province.isNotEmpty && profileData.city.isNotEmpty
              ? "${profileData.province}, ${profileData.city}"
              : ""),
      const SizedBox(
        height: 10,
      ),
      _showLabel(
          label: "Kategori Bisnis",
          value:
              businessType == null ? "" : ServiceTypeUtil.textOf(businessType)),
      const SizedBox(
        height: 10,
      ),
      isEdit
          ? OutlinedButton(
              onPressed: () {
                navigateTo(
                    context,
                    const EOEditDetailDataPage(
                      canPop: true,
                    ),
                    transition: TransitionType.slideInFromBottom);
              },
              child: const Text("Ubah Data Bisnis"))
          : const SizedBox()
    ];
  }

  Widget _showLabel({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: textTheme.labelLarge!.copyWith(
                color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
        Text(
          value.isEmpty ? "-" : value,
          style: textTheme.titleMedium!.copyWith(
            color: value.isEmpty ? Colors.grey : Colors.black,
          ),
        ),
      ],
    );
  }

  void _saveChanges(UserData oldUser) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (editableUserData.isEquals(oldUser)) {
      setState(() {
        isEdit = !isEdit;
      });
      return;
    }
    Confirmation? confirmedEdit = await showDialog(
        context: context,
        builder: (context) => const MyConfirmationDialog(
              label: "Apakah anda yakin ingin menyimpan perubahan?",
              negativeLabel: "Batal",
              noAnswerLabel: "Tunggu",
              positiveLabel: "Simpan",
            ));

    if (confirmedEdit == null || confirmedEdit == Confirmation.noAnswer) {
      return;
    }

    if (confirmedEdit == Confirmation.negative) {
      editableUserData = EditableUserData.fromUserData(oldUser);
      setState(() {
        isEdit = !isEdit;
      });
      return;
    }

    if (!mounted) return;
    showDialog(
        context: context,
        builder: (context) => const MyLoadingDialog(
              label: "Menyimpan perubahan...",
            ));

    AppError? status = await bloc.updateProfile(
        EditableUserData.getDifference(oldUser, editableUserData));

    // Pop loading dialog
    if (!mounted) return;
    Navigator.pop(context);

    if (status == null) {
      setState(() {
        isEdit = !isEdit;
      });
      return;
    }

    showMySnackBar(context, status.message, SnackbarStatus.error);
  }

  Widget _editTextField({
    required String label,
    required String value,
    required Function(String value) onChanged,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: textTheme.labelLarge!.copyWith(
                color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: TextEditingController(text: value),
          inputFormatters: inputFormatters ?? [],
          validator: validator,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            hintText: label,
            hintStyle: textTheme.titleMedium!.copyWith(
              color: Colors.grey,
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            errorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }

  void _pickImage() async {
    ImageSource? source = await showModalBottomSheet(
      context: context,
      builder: (context) => const MyPickImage(),
    );

    if (source == null) {
      return;
    }

    final picker = ImagePicker();

    XFile? pickedImage = await picker.pickImage(source: source);

    if (pickedImage == null) {
      return;
    }

    File image = File(pickedImage.path);

    if (image.readAsBytesSync().lengthInBytes / 1024 / 1024 > 2) {
      if (mounted) {
        showMySnackBar(context, "Ukuran gambar tidak boleh melebihi 2 MB.",
            SnackbarStatus.error);
      }
      return;
    }

    editableUserData.picture = image;
    setState(() {});
  }

  Widget _showProfilePicture(
      UserData user, EditableUserData? editableUserData) {
    File? image = editableUserData?.picture;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: GestureDetector(
            onTap: isEdit ? _pickImage : null,
            child: MyAvatarLoader(
                user: image != null && isEdit
                    ? UserData(profilePicture: image)
                    : user,
                radius: 80),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 15,
          child: Container(
              decoration: BoxDecoration(
                color: colorScheme.tertiary,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(10),
              child: SvgPicture.asset("assets/svg/camera_icon.svg")),
        )
      ],
    );
  }
}
