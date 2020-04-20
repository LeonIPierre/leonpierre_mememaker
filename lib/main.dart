import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leonpierre_mememaker/app.dart';
import 'package:dev_libraries/dev_libraries.dart';


void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  Map<String, String> configuration = Map<String, String>();
  configuration["androidApiKey"] = "android_ZDRkYjk5ZjYtOGJjYy00ZGM1LWFmY2UtYTAwOWY1NzMzZTA2";
  configuration["iosApiKey"] = "ios_NWYwZjQyOTQtNWYxMi00ZjQyLTk2ODctODMzNzY4Y2M5YzM1";

  BlocSupervisor.delegate = BlocManager(loggingService: AppSpectorService(configuration));
  //debugPrintGestureArenaDiagnostics = true;
  runApp(App());
}