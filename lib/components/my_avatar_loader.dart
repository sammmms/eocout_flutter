import 'package:eocout_flutter/models/user_data.dart';
import 'package:flutter/material.dart';

class MyAvatarLoader extends StatelessWidget {
  final UserData user;
  final double? radius;
  const MyAvatarLoader({super.key, required this.user, this.radius});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(10000),
        child: CircleAvatar(
          radius: radius,
          child: user.profilePicture == null
              ? const Icon(Icons.person)
              : FadeInImage(
                  placeholder:
                      const AssetImage("assets/images/placeholder.png"),
                  image: FileImage(user.profilePicture!),
                  imageErrorBuilder: (context, _, __) {
                    return const Icon(Icons.person);
                  },
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
        ));
  }
}
