import 'package:eocout_flutter/bloc/authentication/authentication_bloc.dart';
import 'package:eocout_flutter/bloc/notification/notification_bloc.dart';
import 'package:eocout_flutter/components/my_transition.dart';
import 'package:eocout_flutter/features/dashboard_page.dart';
import 'package:eocout_flutter/features/welcome_page.dart';
import 'package:eocout_flutter/models/user_data.dart';
import 'package:eocout_flutter/utils/my_firebase_messaging.dart';
import 'package:eocout_flutter/utils/print_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late AuthBloc _authBloc;

  @override
  void initState() {
    _authBloc = context.read<AuthBloc>();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      try {
        MyFirebaseMessaging(notificationBloc: context.read<NotificationBloc>())
            .initialize();
      } catch (err) {
        printError(err, method: "initialize myFirebaseMessaging");
      }

      await _authBloc.checkLogin();

      UserData? user = _authBloc.state?.user;
      if (!mounted) return;
      if (user != null) {
        navigateTo(context, const DashboardPage(), replace: true);
      } else {
        navigateTo(context, const WelcomePage(), replace: true);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
