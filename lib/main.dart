//import 'package:dev_libraries/services/analytics/facebookappeventservice.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leonpierre_mememaker/app.dart';
import 'package:leonpierre_mememaker/blocs/blocmanager.dart';
import 'package:dev_libraries/services/logging/appspectorservice.dart';
//import 'package:appspector/appspector.dart' as appSpector;


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

// enum LogLevel {
//   Info,
//   Log,
//   Warn,
//   Debug,
//   Error,
//   Fatal
// }

// abstract class LogService {
//   void initialize();
  
//   void log(LogLevel level, Exception exception, String message);
// }

// class AppSpectorService extends LogService {
//   final Map<String, String> configuration;
//   AppSpectorService(this.configuration) : assert(configuration != null) {
//     initialize();
//   }

//   @override
//   void log(LogLevel level, Exception exception, String message) async {
//     //the sdk picks up whatever is logged to the console
//   }

//   @override
//   void initialize() async {
//     if(!configuration.containsKey("androidApiKey"))
//       throw Exception("Missing key from configuration androidApiKey");

//     if(!configuration.containsKey("iosApiKey"))
//       throw Exception("Missing key from configuration iosApiKey");

//     var config = appSpector.Config();
//     //..androidApiKey = configuration["androidApiKey"];
//     config.iosApiKey = configuration["iosApiKey"];
//     config.androidApiKey = configuration["androidApiKey"];
//     appSpector.AppSpectorPlugin.run(config);
//   }
// }

// abstract class AnalyticsService {
//   activate();
//   send(String event, Map<String, dynamic> parameters);
// }

// abstract class LoggableState {
//   Map<String, dynamic> toLogState();
// }

// abstract class LoggableEvent {
//   Map<String, dynamic> toLogState();
// }