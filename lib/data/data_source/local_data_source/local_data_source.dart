import 'package:maps_app/data/network/sql_database.dart';
import 'package:maps_app/domain/models/models.dart';

abstract class LocalDataSource {
  Future<void> addPlaceToDatabase(PlaceModel placeModel, String phoneNumber);

  Future<List<PlaceModel>> getSavedPlaces(String phoneNumber);

  Future<void> deletePlaceFromDatabase(String placeId);

  Future<void> deleteAllPlace(String phoneNumber);
}

class LocalDataSourceImpl implements LocalDataSource {
  final DatabaseHelper _databaseHelper;
  LocalDataSourceImpl(this._databaseHelper);
  @override
  Future<void> addPlaceToDatabase(
      PlaceModel placeModel, String phoneNumber) async {
    return await _databaseHelper.insertToDatabase(placeModel, phoneNumber);
  }

  @override
  Future<List<PlaceModel>> getSavedPlaces(String phoneNumber) async {
    return await _databaseHelper.getDataFromDataBase(phoneNumber);
  }

  @override
  Future<void> deletePlaceFromDatabase(String placeId) async {
    return await _databaseHelper.deletePlace(placeId: placeId);
  }

  @override
  Future<void> deleteAllPlace(String phoneNumber) async {
    return await _databaseHelper.deleteAllPlaces(phoneNumber: phoneNumber);
  }
}
