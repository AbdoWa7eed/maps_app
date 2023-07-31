import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maps_app/app/app_preferences.dart';
import 'package:maps_app/app/di.dart';
import 'package:maps_app/presentation/resourses/color_manager.dart';
import 'package:maps_app/presentation/resourses/routes_manager.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  late Timer _timer;
  final AppPreferences _appPreferences = instance<AppPreferences>();
  @override
  void initState() {
    _timer = Timer(const Duration(milliseconds: 100), _goNext);
    super.initState();
  }

  _goNext() {
    if (_appPreferences.isUserRegistered()) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(Routes.homeRoute, (route) => false);
    } else {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(Routes.loginRoute, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: ColorManager.white,
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
