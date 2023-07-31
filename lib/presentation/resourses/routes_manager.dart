import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:maps_app/app/di.dart';
import 'package:maps_app/presentation/done/done.dart';
import 'package:maps_app/presentation/home/map_view.dart';
import 'package:maps_app/presentation/phone_auth/login/login.dart';
import 'package:maps_app/presentation/phone_auth/otp/otp_view.dart';
import 'package:maps_app/presentation/places_history/places_history.dart';
import 'package:maps_app/presentation/register/register_view.dart';
import 'package:maps_app/presentation/resourses/color_manager.dart';
import 'package:maps_app/presentation/resourses/strings_manager.dart';
import 'package:maps_app/presentation/splash/splash_view.dart';

class Routes {
  static const String loginRoute = "/login";
  static const String defaultRoute = "/";
  static const String otbRoute = "/otp";
  static const String registerRoute = "/register";
  static const String doneRoute = "/done";
  static const String homeRoute = "/home";
  static const String placesHistoryRoute = "/places";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.loginRoute:
        initPhoneAuthModule();
        return MaterialPageRoute(builder: (_) => LoginView());
      case Routes.otbRoute:
        return MaterialPageRoute(builder: (_) => OTPView());
      case Routes.registerRoute:
        initRegisterModule();
        return MaterialPageRoute(builder: (_) => RegisterView());
      case Routes.doneRoute:
        return MaterialPageRoute(builder: (_) => const DoneView());
      case Routes.homeRoute:
        initHomeModule();
        return MaterialPageRoute(builder: (_) => const MapView());
      case Routes.defaultRoute:
        return MaterialPageRoute(builder: (_) => const SplashView());
      case Routes.placesHistoryRoute:
        initPlacesHistoryModule();
        return MaterialPageRoute(builder: (_) => const PlacesHistoryView());
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              backgroundColor: ColorManager.white,
              appBar: AppBar(
                title: const Text(AppStrings.noRouteFound).tr(),
              ),
              body: Center(child: const Text(AppStrings.noRouteFound).tr()),
            ));
  }
}
