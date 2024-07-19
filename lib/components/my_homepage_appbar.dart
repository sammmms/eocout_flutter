import 'package:eocout_flutter/bloc/authentication/authentication_bloc.dart';
import 'package:eocout_flutter/bloc/authentication/authentication_state.dart';
import 'package:eocout_flutter/bloc/category/category_bloc.dart';
import 'package:eocout_flutter/bloc/category/category_state.dart';
import 'package:eocout_flutter/bloc/notification/notification_bloc.dart';
import 'package:eocout_flutter/bloc/notification/notification_state.dart';
import 'package:eocout_flutter/components/my_avatar_loader.dart';
import 'package:eocout_flutter/components/my_transition.dart';
import 'package:eocout_flutter/features/notification/notification_page.dart';
import 'package:eocout_flutter/features/profile/profile_page.dart';
import 'package:eocout_flutter/models/user_data.dart';
import 'package:eocout_flutter/utils/role_type_util.dart';
import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MyHomepageAppBar extends StatefulWidget {
  const MyHomepageAppBar({super.key});

  @override
  State<MyHomepageAppBar> createState() => _MyHomepageAppBarState();
}

class _MyHomepageAppBarState extends State<MyHomepageAppBar> {
  late AuthBloc authBloc;
  late NotificationBloc _notificationBloc;

  @override
  void initState() {
    authBloc = context.read<AuthBloc>();
    _notificationBloc = context.read<NotificationBloc>();
    _notificationBloc.fetchNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
        stream: authBloc.stream,
        builder: (context, snapshot) {
          UserData? user = snapshot.data?.user;
          bool isLoading = snapshot.data?.isAuthenticating ??
              false || user == null || !snapshot.hasData;
          user ??= UserData.dummy();
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Skeletonizer(
                  enabled: isLoading,
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
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await navigateTo(context, const NotificationPage(),
                            transition: TransitionType.slideInFromRight);
                        _notificationBloc.fetchNotifications();
                      },
                      child: StreamBuilder<NotificationState>(
                          stream: _notificationBloc.stream,
                          builder: (context, snapshot) {
                            int totalUnread = snapshot.data?.totalUnread ?? 0;

                            return Stack(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  child: SvgPicture.asset(
                                    "assets/svg/notification_icon.svg",
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                if (totalUnread > 0)
                                  Positioned(
                                    right: 0,
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Center(
                                        child: Text(
                                            totalUnread > 99
                                                ? "99"
                                                : totalUnread.toString(),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10)),
                                      ),
                                    ),
                                  )
                              ],
                            );
                          }),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
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
                      child: MyAvatarLoader(
                        user: user,
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }
}
