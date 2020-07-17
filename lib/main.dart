import 'package:dev_libraries/bloc/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leonpierre_mememaker/app.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();

  runApp(BlocProvider<AppBloc>(
    create: (BuildContext context) => AppBloc()..add(AppIntializedEvent()),
    child: App(),
  ));
}