import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maps_app/presentation/resourses/color_manager.dart';
import 'package:maps_app/presentation/resourses/fonts_manager.dart';
import 'package:maps_app/presentation/resourses/styles_manager.dart';
import 'package:maps_app/presentation/resourses/values_manager.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
      appBarTheme: const AppBarTheme(
          elevation: AppSize.s0,
          backgroundColor: ColorManager.white,
          foregroundColor: ColorManager.black,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarBrightness: Brightness.dark,
              statusBarIconBrightness: Brightness.dark)),
      inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSize.s10),
              borderSide: const BorderSide(color: ColorManager.lightGray)),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSize.s10),
              borderSide: const BorderSide(color: ColorManager.blue)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSize.s10),
              borderSide: const BorderSide(color: ColorManager.error)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSize.s10),
              borderSide: const BorderSide(color: ColorManager.blue)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSize.s10),
              borderSide: const BorderSide(color: ColorManager.blue)),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSize.s10),
              borderSide: const BorderSide(color: ColorManager.blue)),
          hintStyle:
              getRegularStyle(color: ColorManager.gray, fontSize: FontSize.s14),
          errorStyle: getRegularStyle(
              color: ColorManager.error, fontSize: FontSize.s12)),
      textTheme: TextTheme(
        titleLarge:
            getBoldStyle(color: ColorManager.black, fontSize: FontSize.s24),
        titleMedium:
            getRegularStyle(color: ColorManager.black, fontSize: FontSize.s16),
        titleSmall:
            getRegularStyle(color: ColorManager.black, fontSize: FontSize.s14),
        bodyLarge:
            getSemiBoldStyle(color: ColorManager.black, fontSize: FontSize.s22),
        bodyMedium:
            getSemiBoldStyle(color: ColorManager.blue, fontSize: FontSize.s18),
        bodySmall:
            getSemiBoldStyle(color: ColorManager.blue, fontSize: FontSize.s10),
        displayLarge:
            getRegularStyle(color: ColorManager.black, fontSize: FontSize.s18),
        displayMedium:
            getRegularStyle(color: ColorManager.gray, fontSize: FontSize.s14),
        displaySmall:
            getRegularStyle(color: ColorManager.gray, fontSize: FontSize.s12),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        elevation: AppSize.s0,
        backgroundColor: ColorManager.black,
        textStyle:
            getRegularStyle(color: ColorManager.black, fontSize: FontSize.s14),
      )));
}
