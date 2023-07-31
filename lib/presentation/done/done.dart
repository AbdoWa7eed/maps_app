import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maps_app/presentation/common/widgets/widgets.dart';
import 'package:maps_app/presentation/resourses/assets_manager.dart';
import 'package:maps_app/presentation/resourses/color_manager.dart';
import 'package:maps_app/presentation/resourses/routes_manager.dart';
import 'package:maps_app/presentation/resourses/strings_manager.dart';
import 'package:maps_app/presentation/resourses/values_manager.dart';

class DoneView extends StatelessWidget {
  const DoneView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p20),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SvgPicture.asset(ImageAssets.checkIcon),
            const SizedBox(
              height: AppSize.s40,
            ),
            Text(
              AppStrings.almostDone.tr(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: AppSize.s100,
            ),
            buildElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      Routes.homeRoute, (route) => false);
                },
                text: AppStrings.done.tr(),
                width: double.infinity)
          ]),
        ),
      ),
    );
  }
}
