import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leonpierre_mememaker/app.dart';
import 'package:leonpierre_mememaker/blocs/blocmanager.dart';
import 'package:dev_libraries/external/appspectorservice.dart';
import 'package:dev_libraries/external/facebookappeventservice.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  Map<String, String> configuration = Map<String, String>();
  configuration["androidApiKey"] = "android_ZDRkYjk5ZjYtOGJjYy00ZGM1LWFmY2UtYTAwOWY1NzMzZTA2";
  configuration["iosApiKey"] = "ios_NWYwZjQyOTQtNWYxMi00ZjQyLTk2ODctODMzNzY4Y2M5YzM1";

  BlocSupervisor.delegate = BlocManager(analyticsService: FacebookAppEventService(), loggingService: AppSpectorService(configuration));
  //debugPrintGestureArenaDiagnostics = true;
  runApp(App());
}