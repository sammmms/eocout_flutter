import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class MyPickImage extends StatelessWidget {
  const MyPickImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
            leading: SvgPicture.asset(
              "assets/svg/camera_icon.svg",
              width: 20,
              // ignore: deprecated_member_use
              color: colorScheme.onBackground,
            ),
            title: const Text("Ambil Foto"),
            onTap: () {
              Navigator.pop(context, ImageSource.camera);
            }),
        ListTile(
            leading: SvgPicture.asset(
              "assets/svg/gallery_icon.svg",
              width: 20,
              // ignore: deprecated_member_use
              color: colorScheme.onBackground,
            ),
            title: const Text("Pilih dari Galeri"),
            onTap: () {
              Navigator.pop(context, ImageSource.gallery);
            }),
        ListTile(
            leading: Icon(
              Icons.close,
              color: colorScheme.onSurface,
            ),
            title: const Text("Batal"),
            onTap: () {
              Navigator.pop(context);
            })
      ],
    );
  }
}
