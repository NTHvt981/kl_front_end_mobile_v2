import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FaceDatabase {
  // singleton boilerplate
  static final FaceDatabase _cameraServiceService = FaceDatabase._internal();

  factory FaceDatabase() {
    return _cameraServiceService;
  }
  // singleton boilerplate
  FaceDatabase._internal() {
  }

  /// file that stores the data on filesystem
  late File jsonFile;

  /// Data learned on memory
  Map<String, dynamic> _db = Map<String, dynamic>();
  Map<String, dynamic> get db => this._db;

  /// loads a simple json file.
  Future load() async {
    var tempDir = await getApplicationDocumentsDirectory();
    String _embPath = tempDir.path + '/emb.json';

    jsonFile = new File(_embPath);

    if (jsonFile.existsSync()) {
      _db = json.decode(jsonFile.readAsStringSync());
    }
  }

  /// [Name]: name of the new user
  /// [Data]: Face representation for Machine Learning model
  Future save(String email, String password, List modelData) async {
    String emailAndPass = email + ':' + password;
    _db[emailAndPass] = modelData;
    jsonFile.writeAsStringSync(json.encode(_db));
  }

  /// deletes the created users
  clearAll() {
    this._db = Map<String, dynamic>();
    jsonFile.writeAsStringSync(json.encode({}));
  }
}