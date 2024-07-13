import 'package:eocout_flutter/bloc/authentication/authentication_bloc.dart';
import 'package:eocout_flutter/bloc/authentication/authentication_state.dart';
import 'package:eocout_flutter/features/dashboard_page.dart';
import 'package:eocout_flutter/features/welcome_page.dart';
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
    }
  }
  // await Store.clearStore();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final AuthBloc _authBloc = AuthBloc();

  @override
  void initState() {
    _authBloc.checkLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthBloc>.value(value: _authBloc),
      ],
      child: MaterialApp(
        theme: lightThemeData,
        home: StreamBuilder<AuthState>(
            stream: _authBloc.stream,
            builder: (context, snapshot) {
              return const DashboardPage();
              if (snapshot.hasData) {
                if (snapshot.data!.user != null) {
                  return const DashboardPage();
                }
              }
              return const WelcomePage();
            }),
      ),
    );
  }
}
