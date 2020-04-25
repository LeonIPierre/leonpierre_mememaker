import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leonpierre_mememaker/app.dart';
import 'package:dev_libraries/dev_libraries.dart';
import 'package:leonpierre_mememaker/blocs/appbloc.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  
  var bloc = AppBloc()..add(AppIntializedEvent());
  runApp(BlocProvider<AppBloc>(
    create: (BuildContext context) {
      BlocSupervisor.delegate = BlocSupervisor.delegate ?? BlocManager(loggingService: AppSpectorService(bloc.configuration));
      return bloc;
    },
    child: App(),
  ));
}