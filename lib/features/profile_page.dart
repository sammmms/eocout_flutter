import 'dart:io';

import 'package:eocout_flutter/bloc/authentication/authentication_bloc.dart';
import 'package:eocout_flutter/bloc/profile/profile_bloc.dart';
import 'package:eocout_flutter/components/my_confirmation_dialog.dart';
import 'package:eocout_flutter/components/my_loading_dialog.dart';
import 'package:eocout_flutter/components/my_pick_image.dart';
import 'package:eocout_flutter/components/my_snackbar.dart';
import 'package:eocout_flutter/models/user_data.dart';
import 'package:eocout_flutter/utils/error_status.dart';
import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final UserData user;
  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late EditableUserData editableUserData;
  late AuthBloc authBloc;
  late ProfileBloc bloc;
  final _formKey = GlobalKey<FormState>();

  bool isEdit = false;

  @override
  void initState() {
    authBloc = context.read<AuthBloc>();
    bloc = ProfileBloc(authBloc);
    editableUserData = EditableUserData.fromUserData(widget.user);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () async {
            bool notEdited = editableUserData.isEquals(widget.user);
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
        ),
        actions: [
          IconButton(
              style: const ButtonStyle(
                shape: WidgetStatePropertyAll(CircleBorder()),
                backgroundColor: WidgetStatePropertyAll(Colors.transparent),
              ),
              onPressed: !isEdit
                  ? () {
                      setState(() {
                        isEdit = !isEdit;
                      });
                    }
                  : _saveChanges,
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
                    ))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: isEdit
            ? () async {}
            : () async {
                await authBloc.refreshProfile();
              },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: GestureDetector(
                                onTap: isEdit ? _pickImage : null,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(200),
                                  child: CircleAvatar(
                                    radius: 60,
                                    child: isEdit &&
                                            editableUserData.picture != null
                                        ? Image.file(
                                            editableUserData.picture!,
                                            fit: BoxFit.cover,
                                            height: 200,
                                            width: 200,
                                          )
                                        : widget.user.profilePicture == null
                                            ? const Icon(
                                                Icons.person,
                                                size: 80,
                                              )
                                            : Image.file(
                                                widget.user.profilePicture!,
                                                fit: BoxFit.cover,
                                                height: 200,
                                                width: 200,
                                              ),
                                  ),
                                ),
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
                                  child: SvgPicture.asset(
                                      "assets/svg/camera_icon.svg")),
                            )
                          ],
                        ),
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
                                  hintText: widget.user.fullname.isEmpty
                                      ? "Username"
                                      : widget.user.username,
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                ),
                                style: textStyle.headlineMedium!,
                                textAlign: TextAlign.center,
                              )
                            : Text(
                                widget.user.username.isEmpty
                                    ? "Username"
                                    : widget.user.username,
                                style: textStyle.headlineMedium!.copyWith(
                                  color: widget.user.username.isEmpty
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
                  _showLabel(label: "Email", value: widget.user.email),
                  const SizedBox(
                    height: 10,
                  ),
                  isEdit
                      ? _editTextField(
                          label: "Nama Lengkap",
                          value: widget.user.fullname,
                          onChanged: (value) {
                            editableUserData.fullname = value;
                          })
                      : _showLabel(
                          label: "Nama Lengkap", value: widget.user.fullname),
                  const SizedBox(
                    height: 10,
                  ),
                  isEdit
                      ? _editTextField(
                          label: "Alamat",
                          value: widget.user.address,
                          onChanged: (value) {
                            editableUserData.address = value;
                          })
                      : _showLabel(label: "Alamat", value: widget.user.address),
                  const SizedBox(
                    height: 10,
                  ),
                  isEdit
                      ? _editTextField(
                          label: "Nomor Telepon",
                          value: widget.user.phone,
                          onChanged: (value) {
                            editableUserData.phone = value;
                          })
                      : _showLabel(
                          label: "Nomor Telepon", value: widget.user.phone),
                  const SizedBox(
                    height: 40,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                      onTap: () {},
                      child: Text(
                        "Keluar",
                        style: textStyle.labelLarge!.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w400),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _showLabel({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: textStyle.labelLarge!.copyWith(
                color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
        Text(
          value.isEmpty ? "-" : value,
          style: textStyle.titleMedium!.copyWith(
            color: value.isEmpty ? Colors.grey : Colors.black,
          ),
        ),
      ],
    );
  }

  void _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (editableUserData.isEquals(widget.user)) {
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
      editableUserData = EditableUserData.fromUserData(widget.user);
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

    ErrorStatus? status = await bloc.updateProfile(editableUserData);

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
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: textStyle.labelLarge!.copyWith(
                color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
        TextFormField(
          controller: TextEditingController(text: value),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              hintText: value.isEmpty ? "-" : value,
              hintStyle: textStyle.titleMedium!.copyWith(
                color: value.isEmpty ? Colors.grey : Colors.black,
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              )),
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

    if (image.readAsBytesSync().lengthInBytes / 1024 / 1024 > 3) {
      if (mounted) {
        showMySnackBar(context, "Ukuran gambar tidak boleh melebihi 3 MB.",
            SnackbarStatus.error);
      }
      return;
    }

    editableUserData.picture = image;
    setState(() {});
  }
}
