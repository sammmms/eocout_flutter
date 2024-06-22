import 'package:eocout_flutter/models/user_data.dart';
import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfilePage extends StatelessWidget {
  final UserData user;
  const ProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.transparent)),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
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
                        child: CircleAvatar(
                          radius: 80,
                          child: user.photo.isEmpty
                              ? const Icon(
                                  Icons.person,
                                  size: 80,
                                )
                              : Image.network(
                                  user.photo,
                                  fit: BoxFit.cover,
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
                            child:
                                SvgPicture.asset("assets/svg/camera_icon.svg")),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    user.name,
                    style: textStyle.headlineMedium,
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
            _showLabel(label: "Alamat", value: user.address),
            const SizedBox(
              height: 10,
            ),
            _showLabel(label: "Nomor Telepon", value: user.phone),
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
                      color: colorScheme.onBackground,
                      fontWeight: FontWeight.w400),
                ))
          ],
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
          value,
          style: textStyle.titleMedium,
        ),
      ],
    );
  }
}
