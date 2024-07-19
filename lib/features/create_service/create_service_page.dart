import 'dart:io';

import 'package:eocout_flutter/bloc/service/service_bloc.dart';
import 'package:eocout_flutter/components/my_loading_dialog.dart';
import 'package:eocout_flutter/components/my_pick_image.dart';
import 'package:eocout_flutter/components/my_snackbar.dart';
import 'package:eocout_flutter/features/create_service/widget/picture_viewer.dart';
import 'package:eocout_flutter/models/service_data.dart';
import 'package:eocout_flutter/utils/app_error.dart';
import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddEventPage extends StatefulWidget {
  const AddEventPage({super.key});

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameTEC = TextEditingController();
  final _priceTEC = TextEditingController();
  final _descriptionTEC = TextEditingController();
  final _locationTEC = TextEditingController();
  final _companyNameTEC = TextEditingController();
  final _scrollController = ScrollController();

  final editableBusinessData = EditableServiceData();
  bool _isChecked = false;

  final ServiceBloc _serviceBloc = ServiceBloc();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Scrollbar(
          controller: _scrollController,
          thumbVisibility: true,
          thickness: 1,
          child: Center(
              child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tambahkan Layanan Kamu',
                    style: textTheme.headlineMedium,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Upload Foto",
                    style: textTheme.titleMedium,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 180,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: GestureDetector(
                            onTap: () async {
                              ImageSource? source = await showModalBottomSheet(
                                  context: context,
                                  builder: (context) => const MyPickImage());

                              if (source == null) return;

                              final pickedImage = await ImagePicker().pickImage(
                                source: source,
                              );

                              if (pickedImage == null) {
                                return;
                              }

                              File image = File(pickedImage.path);

                              int imageSize =
                                  image.readAsBytesSync().lengthInBytes;

                              if (imageSize / 1024 / 1024 > 2) {
                                if (context.mounted) {
                                  showMySnackBar(
                                      context,
                                      "Ukuran gambar tidak boleh melebihi 2 MB.",
                                      SnackbarStatus.error);
                                }
                                return;
                              }
                              setState(() {
                                editableBusinessData.images
                                    .add(File(image.path));
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(color: colorScheme.outline),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: editableBusinessData.images.length == 3
                                  ? _smallContainerPicture(
                                      editableBusinessData.images[2])
                                  : Center(
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/svg/camera_icon.svg',
                                            height: 30,
                                            color: colorScheme.onSurface,
                                          ),
                                          Positioned(
                                            bottom: -5,
                                            right: -5,
                                            child: CircleAvatar(
                                                radius: 8,
                                                backgroundColor:
                                                    colorScheme.tertiary,
                                                child: const Icon(
                                                  Icons.add,
                                                  size: 10,
                                                )),
                                          )
                                        ],
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Expanded(
                                  child: _smallContainerPicture(
                                      editableBusinessData.images.firstOrNull)),
                              const SizedBox(
                                height: 10,
                              ),
                              Expanded(
                                  child: _smallContainerPicture(
                                      editableBusinessData.images.length > 1
                                          ? editableBusinessData.images[1]
                                          : null)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const Divider(
                    height: 50,
                  ),
                  Text(
                    "Informasi Layanan",
                    style: textTheme.titleMedium,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _companyNameTEC,
                    decoration: const InputDecoration(labelText: "Nama EO"),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Nama EO tidak boleh kosong";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      editableBusinessData.companyName = value;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _nameTEC,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration:
                        const InputDecoration(labelText: "Nama Layanan"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Nama Layanan tidak boleh kosong";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      editableBusinessData.name = value;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _priceTEC,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(labelText: "Harga"),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Harga tidak boleh kosong";
                      }
                      if (int.parse(value) < 100000) {
                        return "Harga tidak boleh kurang dari Rp100.000";
                      }
                      if (int.parse(value) > 20000000) {
                        return "Harga tidak boleh lebih dari Rp20.000.000";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      if (value.isEmpty) {
                        editableBusinessData.price = 0;
                        return;
                      }
                      editableBusinessData.price = int.parse(value);
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _descriptionTEC,
                    maxLines: 5,
                    decoration: const InputDecoration(labelText: "Deskripsi"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Deskripsi tidak boleh kosong";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      editableBusinessData.description = value;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _locationTEC,
                    decoration: const InputDecoration(labelText: "Lokasi"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Lokasi tidak boleh kosong";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      editableBusinessData.location = value;
                    },
                  ),
                  const Divider(
                    height: 40,
                  ),
                  Text(
                    "Pemasaran",
                    style: textTheme.titleMedium,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Apakah layanan anda memiliki promosi pemasaran atau promosi acara?",
                          style: textTheme.titleSmall,
                        ),
                      ),
                      Checkbox(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        visualDensity: VisualDensity.compact,
                        activeColor: colorScheme.tertiary,
                        value: _isChecked,
                        onChanged: (_) {
                          setState(() {
                            _isChecked = !_isChecked;
                            editableBusinessData
                                .isAcceptPartyPromotionOrMarketing = _isChecked;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 54,
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) return;

                        FocusScope.of(context).requestFocus(FocusNode());

                        showDialog(
                            context: context,
                            builder: (context) {
                              return const MyLoadingDialog();
                            });

                        AppError? error = await _serviceBloc.createService(
                            editableBusinessData: editableBusinessData);

                        if (!context.mounted) return;
                        Navigator.pop(context);

                        if (error != null) {
                          showMySnackBar(
                              context, error.message, SnackbarStatus.error);
                          return;
                        }

                        showMySnackBar(context, "Layanan berhasil didaftarkan",
                            SnackbarStatus.success);

                        _nameTEC.clear();
                        _priceTEC.clear();
                        _descriptionTEC.clear();
                        _locationTEC.clear();
                        _companyNameTEC.clear();

                        context.read<PageController>().jumpToPage(0);
                      },
                      child: const Text("Daftarkan Layanan"),
                    ),
                  )
                ],
              ),
            ),
          )),
        ),
      ),
    );
  }

  Widget _smallContainerPicture(File? image) {
    return GestureDetector(
      onTap: image == null ? null : () => _showDeletePicture(image),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.outline),
          borderRadius: BorderRadius.circular(10),
          image: image == null
              ? null
              : DecorationImage(
                  image: MemoryImage(image.readAsBytesSync()),
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }

  void _showDeletePicture(File image) {
    showDialog(
        context: context,
        builder: (context) {
          return PictureViewer(
              onRemove: () {
                setState(() {
                  editableBusinessData.images.remove(image);
                });
                Navigator.pop(context);
              },
              image: image);
        });
  }
}
