import 'package:main/src/data/main_database.dart';
import 'package:main/src/cli/menu.dart';

void main(List<String> arguments) {
  final db = StoreDatabase.inApp();
  try {
    runMenu(db);
  } finally {
    db.close();
  }
}