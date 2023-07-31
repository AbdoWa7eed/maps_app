import 'package:flutter/material.dart';
import 'package:maps_app/presentation/resourses/language_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String prefsKeyUserUid = "PREFS_KEY_USER_UID";
const String prefsKeyUserPhoneNumber = "PREFS_KEY_USER_PHONE_NUMBER";
const String prefsKeyIsUserRegistered = "PREFS_KEY_IS_USER_REGISTERED";
const String prefsKeyLanguage = "PREFS_KEY_LANGUAGE";

class AppPreferences {
  final SharedPreferences _sharedPreferences;
  AppPreferences(this._sharedPreferences);

  Future<void> setUserUid(String uid) async {
    await _sharedPreferences.setString(prefsKeyUserUid, uid);
  }

  String getUserUid() {
    return _sharedPreferences.getString(prefsKeyUserUid) ?? "";
  }

  Future<void> setUserPhoneNumber(String phoneNumber) async {
    await _sharedPreferences.setString(prefsKeyUserPhoneNumber, phoneNumber);
  }

  String getUserPhoneNumber() {
    return _sharedPreferences.getString(prefsKeyUserPhoneNumber) ?? "";
  }

  Future<void> setUserRegistered() async {
    await _sharedPreferences.setBool(prefsKeyIsUserRegistered, true);
  }

  bool isUserRegistered() {
    return _sharedPreferences.getBool(prefsKeyIsUserRegistered) ?? false;
  }

  Future<bool> logout() async {
    return await _sharedPreferences.remove(prefsKeyUserUid) &&
        await _sharedPreferences.remove(prefsKeyUserPhoneNumber) &&
        await _sharedPreferences.remove(prefsKeyIsUserRegistered);
  }

  Future<String> getAppLanguage() async {
    String? language = _sharedPreferences.getString(prefsKeyLanguage);
    if (language != null && language.isNotEmpty) {
      return language;
    } else {
      return LanguageType.english.getValue();
    }
  }

  Future<void> changeAppLanguage() async {
    String currentLang = await getAppLanguage();
    if (currentLang == LanguageType.arabic.getValue()) {
      await _sharedPreferences.setString(
          prefsKeyLanguage, LanguageType.english.getValue());
    } else {
      await _sharedPreferences.setString(
          prefsKeyLanguage, LanguageType.arabic.getValue());
    }
  }

  Future<Locale> getLocale() async {
    String currentLang = await getAppLanguage();
    if (currentLang == LanguageType.arabic.getValue()) {
      return arabicLocal;
    } else {
      return englishLocal;
    }
  }
}
