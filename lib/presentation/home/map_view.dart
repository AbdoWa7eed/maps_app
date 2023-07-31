import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app/app/di.dart';
import 'package:maps_app/presentation/common/widgets/widgets.dart';
import 'package:maps_app/presentation/home/cubit/cubit.dart';
import 'package:maps_app/presentation/home/cubit/states.dart';
import 'package:maps_app/presentation/home/distance_time.dart';
import 'package:maps_app/presentation/home/drawer.dart';
import 'package:maps_app/presentation/home/search_bar.dart';
import 'package:maps_app/presentation/resourses/assets_manager.dart';
import 'package:maps_app/presentation/resourses/color_manager.dart';
import 'package:maps_app/presentation/resourses/values_manager.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        if (state is HomeErrorStates) {
          showSnackBar(context, text: state.errorMessage);
        }
      },
      builder: (context, state) {
        var cubit = instance<HomeCubit>();
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: Scaffold(
            backgroundColor: ColorManager.white,
            drawer: const SearchBarDrawer(),
            body: Stack(
              fit: StackFit.expand,
              children: [
                _buildContent(cubit),
                SearchBarWidget(),
                const DistanceAndTimeWidget(),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                cubit.goToLocation();
              },
              shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSize.s2)),
              backgroundColor: ColorManager.blue,
              child: SvgPicture.asset(
                ImageAssets.cursorIcon,
                clipBehavior: Clip.antiAliasWithSaveLayer,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(HomeCubit cubit) {
    return cubit.myPosistion == null
        ? const Center(child: CircularProgressIndicator())
        : _buildMap(cubit);
  }

  Widget _buildMap(HomeCubit cubit) {
    return GoogleMap(
      markers: cubit.markers,
      initialCameraPosition: cubit.getCurrentCameraPosistion(),
      mapType: MapType.normal,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      myLocationEnabled: true,
      onMapCreated: (controller) {
        cubit.controller = Completer();
        cubit.controller?.complete(controller);
      },
      polylines: _createPolyLines(cubit),
    );
  }

  Set<Polyline> _createPolyLines(HomeCubit cubit) {
    if (cubit.isVisible && cubit.directionsModel != null) {
      List<PointLatLng> result =
          polylinePoints.decodePolyline(cubit.directionsModel!.points);
      polylineCoordinates.clear();
      polylineCoordinates.addAll(
          result.map((point) => LatLng(point.latitude, point.longitude)));

      return <Polyline>{
        Polyline(
            polylineId: const PolylineId('1'),
            points: polylineCoordinates,
            width: AppSize.s4.toInt(),
            color: ColorManager.black),
      };
    }
    return {};
  }
}
