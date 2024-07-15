import 'package:eocout_flutter/bloc/authentication/authentication_bloc.dart';
import 'package:eocout_flutter/bloc/authentication/authentication_state.dart';
import 'package:eocout_flutter/bloc/category/category_bloc.dart';
import 'package:eocout_flutter/bloc/category/category_state.dart';
import 'package:eocout_flutter/components/my_transition.dart';
import 'package:eocout_flutter/features/profile/profile_page.dart';
import 'package:eocout_flutter/models/user_data.dart';
import 'package:eocout_flutter/utils/role_type_util.dart';
import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MyHomepageAppBar extends StatefulWidget {
  const MyHomepageAppBar({super.key});

  @override
  State<MyHomepageAppBar> createState() => _MyHomepageAppBarState();
}

class _MyHomepageAppBarState extends State<MyHomepageAppBar> {
  late AuthBloc authBloc;

  @override
  void initState() {
    authBloc = context.read<AuthBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
        stream: authBloc.stream,
        builder: (context, snapshot) {
          UserData? user = snapshot.data?.user;
          if (user == null) {
            return _appBarShimmerLoading();
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello, ${user.fullname.isEmpty ? user.username : user.fullname}",
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.headlineSmall,
                    ),
                    Text(user.role == UserRole.user
                        ? "Ayo lihat EO terbaru yang kami sediakan!"
                        : "Ayo lihat informasi terbaru terkait usaha kamu!")
                  ],
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      List<EOCategory>? category = context
                          .read<CategoryBloc>()
                          .controller
                          .valueOrNull
                          ?.categories;

                      navigateTo(
                          context,
                          ProfilePage(
                            categories: category ?? [],
                          ),
                          transition: TransitionType.slideInFromRight);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CircleAvatar(
                        child: user.profilePicture != null
                            ? Image.file(
                                user.profilePicture!,
                                height: 200,
                                width: 200,
                                fit: BoxFit.cover,
                              )
                            : const Icon(
                                Icons.person,
                              ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  Widget _appBarShimmerLoading() {
    UserData user = UserData.dummy();

    return Skeletonizer(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello, ${user.fullname}",
                overflow: TextOverflow.ellipsis,
                style: textTheme.headlineSmall,
              ),
              Text(user.role == UserRole.user
                  ? "Ayo lihat EO terbaru yang kami sediakan!"
                  : "Ayo lihat informasi terbaru terkait usaha kamu!")
            ],
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: null,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: const CircleAvatar(
                  child: Icon(
                    Icons.person,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    ));
  }
}
