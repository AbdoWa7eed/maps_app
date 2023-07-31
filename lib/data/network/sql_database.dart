import 'package:maps_app/domain/models/models.dart';
import 'package:sqflite/sqflite.dart';

const dataBasePath = 'places.db';

class DatabaseHelper {
  late final Database _database;

  DatabaseHelper() {
    _createDatabase();
  }

  _createDatabase() async {
    _database = await openDatabase(
      dataBasePath,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE SavedPlaces (placeName TEXT, description TEXT , placeId TEXT PRIMARY KEY, latitude REAL , longitude REAL)');
      },
      onOpen: (db) {},
    );
  }

  Future<void> insertToDatabase(
      PlaceModel placeModel, String phoneNumber) async {
    await _database.rawInsert(
        'INSERT INTO SavedPlaces(placeName, description ,placeId , latitude , longitude) VALUES(?,?,?,?,?)',
        [
          placeModel.name,
          placeModel.description,
          placeModel.placeId + phoneNumber,
          placeModel.latitude,
          placeModel.longitude
        ]);
  }

  Future<List<PlaceModel>> getDataFromDataBase(String phoneNumber) async {
    var data = await _database.rawQuery('SELECT * FROM SavedPlaces');
    List<PlaceModel> requiredData = [];
    for (var element in data) {
      if (element['placeId'].toString().contains(phoneNumber)) {
        requiredData.add(PlaceModel(
          element['placeName'].toString(),
          element['placeId'].toString().replaceAll(phoneNumber, ""),
          element['latitude'] as double,
          element['longitude'] as double,
          description: element['description'].toString(),
        ));
      }
    }
    return requiredData.reversed.toList();
  }

  Future<void> deletePlace({required String placeId}) async {
    await _database
        .rawDelete("DELETE FROM SavedPlaces WHERE placeId = ?", [placeId]);
  }

  Future<void> deleteAllPlaces({required String phoneNumber}) async {
    await _database.rawDelete(
        "DELETE FROM SavedPlaces WHERE placeId LIKE '%$phoneNumber%'");
  }
}
