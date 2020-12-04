import 'package:dev_libraries/blocs/configuration/configuration.dart';
import 'package:dev_libraries/blocs/navigation_cubit.dart';
import 'package:dev_libraries/models/navigationitem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leonpierre_mememaker/app.dart';
import 'package:leonpierre_mememaker/repositories/staticassetrepository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var pages = [
    NavigationItemModel(0, null),
    NavigationItemModel(1, null),
    NavigationItemModel(2, null)
  ];
  runApp(MultiBlocProvider(providers: [
    BlocProvider<ConfigurationBloc>(
        create: (BuildContext context) =>
            ConfigurationBloc(repositories: [StaticAssetRepository()])..add(ConfigurationIntializedEvent())),
    BlocProvider<NavigationCubit>(
        create: (BuildContext context) => NavigationCubit(pages)..toPage(0)),
  ], child: App()));
}