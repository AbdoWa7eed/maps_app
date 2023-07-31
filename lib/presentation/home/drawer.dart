import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maps_app/app/di.dart';
import 'package:maps_app/presentation/common/widgets/widgets.dart';
import 'package:maps_app/presentation/home/cubit/cubit.dart';
import 'package:maps_app/presentation/home/cubit/states.dart';
import 'package:maps_app/presentation/resourses/assets_manager.dart';
import 'package:maps_app/presentation/resourses/color_manager.dart';
import 'package:maps_app/presentation/resourses/constants_manager.dart';
import 'package:maps_app/presentation/resourses/routes_manager.dart';
import 'package:maps_app/presentation/resourses/strings_manager.dart';
import 'package:maps_app/presentation/resourses/values_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:restart_app/restart_app.dart';

class ListTileModel {
  final Widget icon;
  final String text;
  final Function()? onTap;
  final Widget? trailing;
  final Color? trailingColor;

  ListTileModel(this.icon, this.text,
      {this.trailing, this.onTap, this.trailingColor});
}

class SearchBarDrawer extends StatefulWidget {
  const SearchBarDrawer({super.key});

  @override
  State<SearchBarDrawer> createState() => _SearchBarDrawerState();
}

class _SearchBarDrawerState extends State<SearchBarDrawer> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = instance<HomeCubit>();
        return Drawer(
          child: Column(
            children: [
              _buildInfoWidget(cubit),
              _buildListViewWidget(cubit),
              _buildSocialMediaIcons(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoWidget(HomeCubit cubit) {
    return Container(
      padding: const EdgeInsets.only(
          top: AppPadding.p48, left: AppPadding.p12, right: AppPadding.p12),
      height: MediaQuery.of(context).size.height * 0.35,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: ColorManager.lightBlue,
        shape: BoxShape.rectangle,
      ),
      child: Column(
        children: [
          Container(
            height: AppSize.s120,
            width: AppSize.s120,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(AppSize.s10)),
            child: Image.network(
              cubit.userModel!.imageLink,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: AppSize.s10,
          ),
          Text("${cubit.userModel!.firstName} ${cubit.userModel!.lastName}",
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyLarge),
          Text(cubit.userModel!.phoneNumber,
              style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildListViewWidget(HomeCubit cubit) {
    return Expanded(
      child: ListView.separated(
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            return _buildListTileItemWidget(context,
                model: _buildListTileModels(context, cubit)[index]);
          },
          separatorBuilder: (context, index) {
            return _buildDeviderWidget();
          },
          itemCount: _buildListTileModels(context, cubit).length),
    );
  }

  Widget _buildSocialMediaIcons() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.p16, vertical: AppPadding.p20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.followUs.tr(),
            style: Theme.of(context)
                .textTheme
                .displayLarge
                ?.copyWith(color: ColorManager.black60),
          ),
          const SizedBox(
            height: AppSize.s15,
          ),
          Row(
            children: [
              InkWell(
                  onTap: () => _launchUrl(AppConstants.facebook, context),
                  child: SvgPicture.asset(ImageAssets.facebook)),
              const SizedBox(
                width: AppSize.s12,
              ),
              InkWell(
                  onTap: () => _launchUrl(AppConstants.linkedIn, context),
                  child: SvgPicture.asset(
                    ImageAssets.linkedIn,
                    colorFilter: const ColorFilter.mode(
                        ColorManager.blue, BlendMode.srcIn),
                    height: AppSize.s36,
                    width: AppSize.s36,
                  )),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildListTileItemWidget(
    context, {
    required ListTileModel model,
  }) {
    return ListTile(
      leading: model.icon,
      title: Text(
        model.text,
        style: Theme.of(context).textTheme.displayLarge,
      ),
      trailing: model.trailing ??
          Icon(Icons.arrow_forward_ios_rounded,
              color: model.trailingColor ?? ColorManager.blue),
      onTap: model.onTap,
    );
  }

  Widget _buildDeviderWidget() {
    return Container(
      height: AppSize.s1,
      width: double.infinity,
      color: ColorManager.lightGray,
    );
  }

  List<ListTileModel> _buildListTileModels(
      BuildContext context, HomeCubit cubit) {
    return [
      ListTileModel(
        SvgPicture.asset(ImageAssets.bookMark),
        AppStrings.plcesHistory.tr(),
        onTap: () {
          Navigator.of(context).pushNamed(Routes.placesHistoryRoute);
        },
      ),
      ListTileModel(
          SvgPicture.asset(ImageAssets.language), AppStrings.language.tr(),
          trailing: SizedBox(
            width: AppSize.s80,
            child: Row(
              children: [
                Expanded(
                    child: InkWell(
                  onTap: () {
                    if (!cubit.isEnglishLanguage) {
                      cubit.changeAppLanguage();
                      Restart.restartApp(webOrigin: Routes.defaultRoute);
                    }
                  },
                  child: Container(
                    height: AppSize.s30,
                    color: cubit.isEnglishLanguage
                        ? ColorManager.blue
                        : ColorManager.lightBlue,
                    child: Center(
                      child: Text(AppStrings.english.tr(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                  color: cubit.isEnglishLanguage
                                      ? ColorManager.white
                                      : ColorManager.black)),
                    ),
                  ),
                )),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    if (cubit.isEnglishLanguage) {
                      cubit.changeAppLanguage();
                      Restart.restartApp(webOrigin: Routes.defaultRoute);
                    }
                  },
                  child: Container(
                    height: AppSize.s30,
                    color: !cubit.isEnglishLanguage
                        ? ColorManager.blue
                        : ColorManager.lightBlue,
                    child: Center(
                      child: Text(AppStrings.arabic.tr(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                  color: !cubit.isEnglishLanguage
                                      ? ColorManager.white
                                      : ColorManager.black)),
                    ),
                  ),
                )),
              ],
            ),
          )),
      ListTileModel(
          SvgPicture.asset(ImageAssets.logOut), AppStrings.logout.tr(),
          onTap: () async {
        if (await cubit.logout()) {
          _goToLogin();
        }
      }, trailingColor: ColorManager.error)
    ];
  }

  void _goToLogin() {
    Navigator.of(context)
        .pushNamedAndRemoveUntil(Routes.loginRoute, (route) => false);
  }

  void _launchUrl(String url, context) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      showSnackBar(context, text: AppStrings.invalidLink.tr());
    }
  }
}
