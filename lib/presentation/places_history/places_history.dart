import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_app/app/di.dart';
import 'package:maps_app/domain/models/models.dart';
import 'package:maps_app/presentation/home/cubit/cubit.dart';
import 'package:maps_app/presentation/places_history/cubit/cubit.dart';
import 'package:maps_app/presentation/places_history/cubit/states.dart';
import 'package:maps_app/presentation/resourses/color_manager.dart';
import 'package:maps_app/presentation/resourses/fonts_manager.dart';
import 'package:maps_app/presentation/resourses/strings_manager.dart';
import 'package:maps_app/presentation/resourses/values_manager.dart';

class PlacesHistoryView extends StatelessWidget {
  const PlacesHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlacesHistoryCubit, PlacesHistoryStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = instance<PlacesHistoryCubit>();
        return Scaffold(
          backgroundColor: ColorManager.white,
          appBar: AppBar(
            automaticallyImplyLeading: true,
            foregroundColor: ColorManager.white,
            backgroundColor: ColorManager.blue,
            systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarIconBrightness: Brightness.light),
            actions: [
              IconButton(
                  onPressed: () {
                    cubit.deleteAllPlace();
                  },
                  icon: const Icon(Icons.delete))
            ],
          ),
          body: _buildContent(cubit, context),
        );
      },
    );
  }

  Widget _buildContent(PlacesHistoryCubit cubit, BuildContext context) {
    if (cubit.placesHistory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.bookmark_sharp,
                color: ColorManager.gray, size: AppSize.s100),
            Text(
              AppStrings.historyIsEmpty.tr(),
              style: Theme.of(context).textTheme.bodyLarge,
            )
          ],
        ),
      );
    }
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
              itemBuilder: (context, index) {
                return _buildItem(cubit.placesHistory[index], cubit, context);
              },
              separatorBuilder: (context, index) {
                return _buildDivider();
              },
              itemCount: cubit.placesHistory.length),
        )
      ],
    );
  }

  Widget _buildItem(
      PlaceModel placeModel, PlacesHistoryCubit cubit, BuildContext context) {
    return Dismissible(
      background: Container(
        color: ColorManager.error,
        child: const Icon(
          Icons.delete,
          color: ColorManager.white,
        ),
      ),
      onDismissed: (direction) {
        cubit.deletePlace(placeModel.placeId);
      },
      key: Key(placeModel.placeId),
      child: InkWell(
        onTap: () {
          instance<HomeCubit>().reInitialzePlaceModel(placeModel);
          int count = 0;
          Navigator.of(context).popUntil((route) => count++ >= 2);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppPadding.p20, vertical: AppPadding.p18),
          child: Row(
            children: [
              const CircleAvatar(
                radius: AppSize.s24,
                backgroundColor: ColorManager.lightBlue,
                child: Icon(Icons.place, color: ColorManager.blue),
              ),
              const SizedBox(
                width: AppSize.s20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(placeModel.name,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontSize: FontSize.s20)),
                    Text(placeModel.description!,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge
                            ?.copyWith(fontSize: FontSize.s16)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      color: ColorManager.lightGray,
      height: AppSize.s1,
    );
  }
}
