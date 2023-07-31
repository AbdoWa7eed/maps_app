import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_app/app/app_preferences.dart';
import 'package:maps_app/app/di.dart';
import 'package:maps_app/presentation/home/cubit/cubit.dart';
import 'package:maps_app/presentation/phone_auth/cubit/cubit.dart';
import 'package:maps_app/presentation/places_history/cubit/cubit.dart';
import 'package:maps_app/presentation/register/cubit/cubit.dart';
import 'package:maps_app/presentation/resourses/routes_manager.dart';
import 'package:maps_app/presentation/resourses/theme_manager.dart';

class MyApp extends StatefulWidget {
  const MyApp._internal();

  static const MyApp _instance = MyApp._internal();

  factory MyApp() => _instance;

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final AppPreferences _appPreferences = instance<AppPreferences>();
  @override
  void didChangeDependencies() {
    _appPreferences.getLocale().then((value) {
      context.setLocale(value);
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => instance<PhoneAuthCubit>()),
        BlocProvider(create: (context) => instance<RegisterCubit>()),
        BlocProvider(create: (context) => instance<HomeCubit>()),
        BlocProvider(create: (context) => instance<PlacesHistoryCubit>()),
      ],
      child: MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.defaultRoute,
        onGenerateRoute: RouteGenerator.getRoute,
        theme: getApplicationTheme(),
      ),
    );
  }
}
