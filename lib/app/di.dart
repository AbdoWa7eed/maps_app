import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:maps_app/app/app_preferences.dart';
import 'package:maps_app/data/data_source/local_data_source/local_data_source.dart';
import 'package:maps_app/data/data_source/remote_data_source/auth_data_source.dart';
import 'package:maps_app/data/data_source/remote_data_source/home_data_source.dart';
import 'package:maps_app/data/data_source/remote_data_source/register_data_source.dart';
import 'package:maps_app/data/network/app_api.dart';
import 'package:maps_app/data/network/dio_factory.dart';
import 'package:maps_app/data/network/network_info.dart';
import 'package:maps_app/data/network/sql_database.dart';
import 'package:maps_app/data/repository/auth_repo_impl.dart';
import 'package:maps_app/data/repository/home_repo_impl.dart';
import 'package:maps_app/data/repository/places_history_repo_impl.dart';
import 'package:maps_app/data/repository/register_repo_impl.dart';
import 'package:maps_app/domain/repository/auth_repo.dart';
import 'package:maps_app/domain/repository/home_repo.dart';
import 'package:maps_app/domain/repository/places_history_repo.dart';
import 'package:maps_app/domain/repository/register_repo.dart';
import 'package:maps_app/domain/usecases/home_usecase.dart';
import 'package:maps_app/domain/usecases/places_history_usecase.dart';
import 'package:maps_app/domain/usecases/register_use_case.dart';
import 'package:maps_app/presentation/home/cubit/cubit.dart';
import 'package:maps_app/presentation/phone_auth/cubit/cubit.dart';
import 'package:maps_app/presentation/places_history/cubit/cubit.dart';
import 'package:maps_app/presentation/register/cubit/cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final instance = GetIt.instance;

initAppModule() async {
  final sharedPrefs = await SharedPreferences.getInstance();
  instance.registerLazySingleton<DioFactory>(() => DioFactory());
  instance
      .registerLazySingleton<AppPreferences>(() => AppPreferences(sharedPrefs));

  Dio dio = await instance<DioFactory>().getDio();
  instance.registerLazySingleton<AppServiceClient>(
      () => AppServiceClientImpl(dio, instance<AppPreferences>()));

  instance.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(InternetConnectionChecker()));
  instance.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance);

  instance.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  instance.registerLazySingleton<LocalDataSource>(
      () => LocalDataSourceImpl(instance<DatabaseHelper>()));
}

initPhoneAuthModule() {
  if (!GetIt.I.isRegistered<AuthDataSource>()) {
    instance.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
    instance.registerLazySingleton<AuthDataSource>(() => AuthDataSourceImpl(
        instance<FirebaseAuth>(), instance<FirebaseFirestore>()));
    instance.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
        instance<AuthDataSource>(), instance<NetworkInfo>()));
  }

  if (!GetIt.I.isRegistered<PhoneAuthCubit>()) {
    instance.registerLazySingleton<PhoneAuthCubit>(() => PhoneAuthCubit());
  }
}

initRegisterModule() {
  if (!GetIt.I.isRegistered<RegisterDataSource>()) {
    instance
        .registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);
    instance.registerLazySingleton<RegisterDataSource>(() =>
        RegisterDataSourceImpl(
            instance<FirebaseFirestore>(), instance<FirebaseStorage>()));
    instance.registerLazySingleton<RegisterRepository>(() =>
        RegisterRepositoryImpl(
            instance<RegisterDataSource>(), instance<NetworkInfo>()));

    instance.registerLazySingleton<UploadImageUseCase>(
      () => UploadImageUseCase(instance<RegisterRepository>()),
    );

    instance.registerLazySingleton<AddUserDataUseCase>(
      () => AddUserDataUseCase(instance<RegisterRepository>()),
    );
  }

  if (!GetIt.I.isRegistered<RegisterCubit>()) {
    instance.registerLazySingleton<ImagePicker>(() => ImagePicker());
    instance.registerLazySingleton<RegisterCubit>(() => RegisterCubit());
  }
}

initHomeModule() async {
  if (!GetIt.I.isRegistered<HomeDataSource>()) {
    instance.registerLazySingleton<HomeDataSource>(() => HomeDataSourceImpl(
        instance<FirebaseFirestore>(), instance<AppServiceClient>()));
    instance.registerLazySingleton<HomeRepository>(() => HomeRepositortImpl(
        instance<HomeDataSource>(),
        instance<NetworkInfo>(),
        instance<LocalDataSource>()));
    initHomeUseCases();
  }
  if (!GetIt.I.isRegistered<HomeCubit>()) {
    instance.registerLazySingleton<HomeCubit>(() => HomeCubit());
  }
  await instance<HomeCubit>().getAppLanguage();
  await instance<HomeCubit>().getUserData();
  await instance<HomeCubit>().getCurrentLocation();
}

initHomeUseCases() {
  instance.registerLazySingleton<GetUserDataUseCase>(
    () => GetUserDataUseCase(instance<HomeRepository>()),
  );
  instance.registerLazySingleton<GetSuggestedPlacesUseCase>(
    () => GetSuggestedPlacesUseCase(instance<HomeRepository>()),
  );

  instance.registerLazySingleton<GetPlaceDetailsUseCase>(
    () => GetPlaceDetailsUseCase(instance<HomeRepository>()),
  );

  instance.registerLazySingleton<GetDirectionsUseCase>(
    () => GetDirectionsUseCase(instance<HomeRepository>()),
  );

  instance.registerLazySingleton<SavePlaceUseCase>(
    () => SavePlaceUseCase(instance<HomeRepository>()),
  );
}

initPlacesHistoryModule() async {
  if (!GetIt.I.isRegistered<SavedPlacesRepository>()) {
    instance.registerLazySingleton<SavedPlacesRepository>(
        () => SavedPlacesReposImpl(instance<LocalDataSource>()));
    initPlcesHistoryUseCases();
  }
  if (!GetIt.I.isRegistered<PlacesHistoryCubit>()) {
    instance
        .registerLazySingleton<PlacesHistoryCubit>(() => PlacesHistoryCubit());
  }
  await instance<PlacesHistoryCubit>().getSavedPlaces();
}

initPlcesHistoryUseCases() {
  instance.registerLazySingleton<GetPlacesUseCase>(
    () => GetPlacesUseCase(instance<SavedPlacesRepository>()),
  );

  instance.registerLazySingleton<DeletePlaceUseCase>(
    () => DeletePlaceUseCase(instance<SavedPlacesRepository>()),
  );

  instance.registerLazySingleton<DeleteAllPlacesUseCase>(
    () => DeleteAllPlacesUseCase(instance<SavedPlacesRepository>()),
  );
}
