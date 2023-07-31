import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maps_app/app/di.dart';
import 'package:maps_app/presentation/home/cubit/cubit.dart';
import 'package:maps_app/presentation/home/cubit/states.dart';
import 'package:maps_app/presentation/resourses/assets_manager.dart';
import 'package:maps_app/presentation/resourses/color_manager.dart';
import 'package:maps_app/presentation/resourses/fonts_manager.dart';
import 'package:maps_app/presentation/resourses/strings_manager.dart';
import 'package:maps_app/presentation/resourses/values_manager.dart';

class DistanceAndTimeWidget extends StatelessWidget {
  const DistanceAndTimeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = instance<HomeCubit>();
          return Visibility(
              visible: cubit.isVisible,
              child: cubit.directionsModel != null
                  ? Positioned(
                      width: MediaQuery.of(context).size.width,
                      bottom: MediaQuery.of(context).size.height * 0.8,
                      child: Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: AppSize.s16),
                        child: Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: Card(
                                color: ColorManager.white,
                                elevation: AppSize.s4,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(AppSize.s8)),
                                child: SizedBox(
                                  height: AppSize.s50,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: AppPadding.p8),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(ImageAssets.time),
                                        const SizedBox(
                                          width: AppSize.s8,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(AppStrings.duration.tr(),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displaySmall),
                                              Text(
                                                cubit.directionsModel!.duration,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      fontSize: FontSize.s16,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: AppSize.s40,
                            ),
                            Flexible(
                              flex: 1,
                              child: Card(
                                color: ColorManager.white,
                                elevation: AppSize.s4,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(AppSize.s8)),
                                child: SizedBox(
                                  height: AppSize.s50,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: AppPadding.p8),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(ImageAssets.distance),
                                        const SizedBox(
                                          width: AppSize.s8,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(AppStrings.distance.tr(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displaySmall),
                                            Text(
                                              cubit.directionsModel!.distance,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    fontSize: FontSize.s16,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))
                  : Container());
        });
  }
}
