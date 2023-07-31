import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:maps_app/presentation/resourses/color_manager.dart';
import 'package:maps_app/presentation/resourses/strings_manager.dart';
import 'package:maps_app/presentation/resourses/values_manager.dart';

Widget showLoadingDialog(BuildContext context) {
  return Dialog(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: AppPadding.p18),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const CircularProgressIndicator(
          color: ColorManager.blue,
        ),
        const SizedBox(
          height: AppSize.s24,
        ),
        Text(AppStrings.loading.tr(),
            style: Theme.of(context).textTheme.displayLarge),
      ]),
    ),
  );
}

_isCurrentDialogActive(BuildContext context) =>
    ModalRoute.of(context)?.isCurrent != true;

dismissDialog(BuildContext context) {
  if (_isCurrentDialogActive(context)) {
    Navigator.of(context, rootNavigator: true).pop(true);
  }
}

Widget buildElevatedButton(
    {required Function onPressed,
    required String text,
    double hight = AppSize.s50,
    double width = AppSize.s120}) {
  return SizedBox(
    height: hight,
    width: width,
    child: ElevatedButton(
      onPressed: () {
        onPressed.call();
      },
      style: ElevatedButton.styleFrom(
        alignment: AlignmentDirectional.center,
      ),
      child: Text(text),
    ),
  );
}

showSnackBar(BuildContext context, {required String text}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: ColorManager.black,
      duration: const Duration(seconds: 3),
      content: Text(text,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: ColorManager.white))));
}
