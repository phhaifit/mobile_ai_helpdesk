import '/core/data/local/encryption/xxtea.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';

class SembastClient {
  final Database _database;

  SembastClient(this._database);

  Database get database => _database;

  static Future<SembastClient> provideDatabase({
    String encryptionKey = '',
    required String databaseName,
    required String databasePath,
  }) async {
    final dbPath = join(databasePath, databaseName);

    final Database database;
    if (encryptionKey.isNotEmpty) {
      var codec = getXXTeaCodec(password: encryptionKey);

      if (kIsWeb) {
        var factory = databaseFactoryWeb;
        database = await factory.openDatabase(databaseName, codec: codec);
      } else {
        database = await databaseFactoryIo.openDatabase(dbPath, codec: codec);
      }
    } else {
      if (kIsWeb) {
        var factory = databaseFactoryWeb;
        database = await factory.openDatabase(databaseName);
      } else {
        database = await databaseFactoryIo.openDatabase(dbPath);
      }
    }

    return SembastClient(database);
  }
}
