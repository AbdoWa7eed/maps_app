import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_app/app/app.dart';
import 'package:maps_app/app/di.dart';
import 'package:maps_app/firebase_options.dart';
import 'package:maps_app/presentation/common/bloc_observer/bloc_observer.dart';
import 'package:maps_app/presentation/resourses/language_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = MyBlocObserver();
  await initAppModule();
  runApp(EasyLocalization(
    path: assetPathLocalization,
    supportedLocales: const [arabicLocal, englishLocal],
    child: MyApp(),
  ));
}
