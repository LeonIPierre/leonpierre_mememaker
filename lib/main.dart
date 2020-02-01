import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leonpierre_mememaker/app.dart';
import 'package:leonpierre_mememaker/blocs/blocmanager.dart';
import 'package:leonpierre_mememaker/services/analytics/FacebookAppEventsService.dart';

void main()
{
  BlocSupervisor.delegate = BlocManager(new FacebookAppEventService());
  //debugPrintGestureArenaDiagnostics = true;
  runApp(App());
}