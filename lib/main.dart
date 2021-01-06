import 'package:dev_libraries/blocs/configuration/configuration.dart';
import 'package:dev_libraries/blocs/navigation_cubit.dart';
import 'package:dev_libraries/dev_libraries.dart';
import 'package:dev_libraries/models/navigationitem.dart';
import 'package:dev_libraries/services/authentication/firebaseauthenticationrepository.dart';
import 'package:dev_libraries/services/userservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:leonpierre_mememaker/app.dart';
import 'package:leonpierre_mememaker/repositories/staticassetrepository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //TODO move to happening after the configuration if possible
  await FlutterDownloader.initialize(debug: true);

  var pages = [
    NavigationItemModel(0, null),
    NavigationItemModel(1, null),
    NavigationItemModel(2, null)
  ];

  runApp(MultiBlocProvider(providers: [
    BlocProvider<ConfigurationBloc>(
        create: (BuildContext context) =>
            ConfigurationBloc(repositories: [StaticAssetRepository()])..add(ConfigurationIntializedEvent())),
    BlocProvider<AuthenticationBloc>(
      create: (BuildContext context) => AuthenticationBloc(
        authenticationService: FirebaseAuthenticationRepository()..initialize(),
        userService: UserService("https://mrmeme.io/api/users"))),
    BlocProvider<NavigationCubit>(
        create: (BuildContext context) => NavigationCubit(pages)..toPage(1)),
  ], child: App()));
}