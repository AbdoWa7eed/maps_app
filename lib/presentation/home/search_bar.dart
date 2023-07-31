import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:maps_app/app/constants.dart';
import 'package:maps_app/app/di.dart';
import 'package:maps_app/domain/models/models.dart';
import 'package:maps_app/presentation/home/cubit/cubit.dart';
import 'package:maps_app/presentation/home/cubit/states.dart';
import 'package:maps_app/presentation/resourses/color_manager.dart';
import 'package:maps_app/presentation/resourses/constants_manager.dart';
import 'package:maps_app/presentation/resourses/strings_manager.dart';
import 'package:maps_app/presentation/resourses/values_manager.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBarWidget extends StatelessWidget {
  SearchBarWidget({super.key});
  final FloatingSearchBarController _searchBarController =
      FloatingSearchBarController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = instance<HomeCubit>();
        return FloatingSearchBar(
          margins: const EdgeInsetsDirectional.only(
              top: AppMargin.m40, start: AppMargin.m20, end: AppMargin.m20),
          automaticallyImplyBackButton: false,
          automaticallyImplyDrawerHamburger: false,
          leadingActions: _buildLeadingsList(),
          controller: _searchBarController,
          elevation: AppSize.s4,
          hint: AppStrings.findAPlace.tr(),
          hintStyle: Theme.of(context)
              .textTheme
              .displayLarge
              ?.copyWith(color: ColorManager.black60),
          iconColor: ColorManager.blue,
          scrollPadding: const EdgeInsets.only(top: AppSize.s16, bottom: 50),
          transitionDuration:
              const Duration(milliseconds: AppConstants.transistionDuration),
          debounceDelay:
              const Duration(milliseconds: AppConstants.debounceDelay),
          physics: const BouncingScrollPhysics(),
          onQueryChanged: (place) {
            if (place.isNotEmpty) {
              cubit.getSuggestedPlaces(place);
            }
          },
          onFocusChanged: (isFocused) {
            if (isFocused) {
              cubit.hideDistanceAndTime();
            }
          },
          onSubmitted: (place) {
            if (place.isNotEmpty) {
              cubit.getSuggestedPlaces(place);
            }
          },
          transition: CircularFloatingSearchBarTransition(),
          actions: _buildActionsList(),
          builder: (context, transition) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildPlacesList(cubit),
              ],
            );
          },
        );
      },
    );
  }

  List<Widget> _buildLeadingsList() {
    return [
      FloatingSearchBarAction(
        showIfClosed: true,
        builder: (context, animation) {
          return FloatingSearchBarAction.hamburgerToBack();
        },
      ),
      FloatingSearchBarAction.icon(
        showIfClosed: false,
        showIfOpened: true,
        icon: Icons.arrow_back_ios,
        onTap: () {
          _searchBarController.close();
        },
      ),
    ];
  }

  List<Widget> _buildActionsList() {
    return [
      FloatingSearchBarAction.icon(
        showIfClosed: true,
        showIfOpened: false,
        icon: const Icon(Icons.place, color: ColorManager.black60),
        onTap: () {
          _searchBarController.clear();
        },
      ),
      FloatingSearchBarAction.icon(
        showIfClosed: false,
        showIfOpened: true,
        icon: const Icon(Icons.cancel, color: ColorManager.black60),
        onTap: () {
          _searchBarController.query = Constants.empty;
        },
      ),
    ];
  }

  Widget _buildPlacesList(HomeCubit cubit) {
    return ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return _buildPlaceItem(
              context, cubit.placesMap.values.toList()[index], cubit);
        },
        separatorBuilder: (context, index) {
          return Container(
            height: AppSize.s10,
          );
        },
        itemCount: cubit.placesMap.values.length);
  }

  Widget _buildPlaceItem(
      BuildContext context, SuggestedPlaceModel placeModel, HomeCubit cubit) {
    return InkWell(
        onTap: () async {
          await onSearchedItemClicked(cubit, placeModel);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSize.s10),
            color: ColorManager.white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppPadding.p16, vertical: AppPadding.p8),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: AppSize.s20,
                  backgroundColor: ColorManager.lightBlue,
                  child: Icon(Icons.place, color: ColorManager.blue),
                ),
                const SizedBox(
                  width: AppSize.s16,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _buildTitleText(placeModel.description),
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(
                        height: AppSize.s4,
                      ),
                      Text(
                        _buildAddressText(placeModel.description),
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  _buildTitleText(String address) {
    return address.split(',')[0];
  }

  _buildAddressText(String address) {
    return address.substring(address.indexOf(',') + 1).trim();
  }

  onSearchedItemClicked(HomeCubit cubit, SuggestedPlaceModel placeModel) async {
    await cubit.getPlaceDetails(placeModel.placeId);
    _searchBarController.close();
  }
}
