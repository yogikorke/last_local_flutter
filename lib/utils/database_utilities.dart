import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class DatabaseUtilities {
  static Future<Database> getDatabaseClient() async {
    Database? databaseClient;
    String databasePath;
    DatabaseFactory databaseFactory;
    if (databaseClient != null) {
      return Future.value(databaseClient);
    } else {
      // get the application documents directory
      var directory = await getApplicationDocumentsDirectory();
      // make sure it exists
      await directory.create(recursive: true);
      // build the database path
      databasePath = p.join(directory.path, 'app.db');
      // File path to a file in the current directory
      databaseFactory = databaseFactoryIo;
      // We use the database factory to open the database
      databaseClient = await databaseFactory.openDatabase(databasePath);

      return Future.value(databaseClient);
    }
  }
}