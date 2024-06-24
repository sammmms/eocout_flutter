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

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightThemeData,
      home: const WelcomePage(),
    );
  }
}
