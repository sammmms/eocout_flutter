import 'dart:io';

import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NewEvent {
  String eventOrganizerName;
  String eventName;
  int eventPrice;
  String eventDescription;
  String eventLocation;

  NewEvent({
    required this.eventOrganizerName,
    required this.eventName,
    required this.eventPrice,
    required this.eventDescription,
    required this.eventLocation,
  });

  Map<String, dynamic> toJson() {
    return {
      'eventOrganizerName': eventOrganizerName,
      'eventName': eventName,
      'eventPrice': eventPrice,
      'eventDescription': eventDescription,
      'eventLocation': eventLocation,
    };
  }
}

class AddEventPage extends StatefulWidget {
  const AddEventPage({super.key});

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _formKey = GlobalKey<FormState>();
  final newEvent = NewEvent(
    eventOrganizerName: '',
    eventName: '',
    eventPrice: 0,
    eventDescription: '',
    eventLocation: '',
  );

  List<File> images = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambahkan Layanan Kamu'),
        backgroundColor: colorScheme.surface,
        scrolledUnderElevation: 0,
      ),
      body: Center(
          child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Upload Foto",
                style: textStyle.titleMedium,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: colorScheme.outline),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/svg/camera_icon.svg',
                          height: 30,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        AspectRatio(
                          aspectRatio: 1 / 1,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: colorScheme.outline),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        AspectRatio(
                          aspectRatio: 1 / 1,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: colorScheme.outline),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const Divider(
                height: 40,
              ),
              Text(
                "Informasi Layanan",
                style: textStyle.titleMedium,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Nama EO"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Nama EO tidak boleh kosong";
                  }
                  return null;
                },
                onChanged: (value) {
                  newEvent.eventOrganizerName = value;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Nama Layanan"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Nama Layanan tidak boleh kosong";
                  }
                  return null;
                },
                onChanged: (value) {
                  newEvent.eventName = value;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Harga"),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Harga tidak boleh kosong";
                  }
                  return null;
                },
                onChanged: (value) {
                  newEvent.eventPrice = int.parse(value);
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Deskripsi"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Deskripsi tidak boleh kosong";
                  }
                  return null;
                },
                onChanged: (value) {
                  newEvent.eventDescription = value;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Lokasi"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Lokasi tidak boleh kosong";
                  }
                  return null;
                },
                onChanged: (value) {
                  newEvent.eventLocation = value;
                },
              ),
              const Divider(
                height: 40,
              ),
              Text(
                "Pemasaran",
                style: textStyle.titleMedium,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Apakah layanan anda memiliki promosi pemasaran atau promosi acara?",
                      style: textStyle.titleSmall,
                    ),
                  ),
                  Checkbox(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    visualDensity: VisualDensity.compact,
                    activeColor: colorScheme.tertiary,
                    value: true,
                    onChanged: (_) {},
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
                  onPressed: () {},
                  child: const Text("Daftarkan Layanan"),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
