import 'package:eocout_flutter/bloc/authentication/authentication_bloc.dart';
import 'package:eocout_flutter/bloc/notification/notification_bloc.dart';
import 'package:eocout_flutter/bloc/profile/profile_bloc.dart';
import 'package:eocout_flutter/splash_page.dart';
import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  if (dotenv.isInitialized) {
    if (kDebugMode) {
      print('The .env file has been loaded');
      print('The BASE URL is ${dotenv.env['BASE_URL']}');
      print('The WS URL is ${dotenv.env['WS_URL']}');
    }
  }

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final AuthBloc _authBloc = AuthBloc();
  late ProfileBloc _profileBloc;
  final NotificationBloc _notificationBloc = NotificationBloc();

  @override
  void initState() {
    _profileBloc = ProfileBloc(_authBloc);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthBloc>.value(value: _authBloc),
        Provider<ProfileBloc>.value(
          value: _profileBloc,
        ),
        Provider<NotificationBloc>.value(value: _notificationBloc),
      ],
      child: MaterialApp(
        theme: lightThemeData,
        home: const SplashPage(),
      ),
    );
  }
}
