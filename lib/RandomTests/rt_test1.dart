import 'package:ecosystem/database/database_manager.dart';
import 'package:ecosystem/database/tableSchema/ecosystem_master.dart';

void testDb() async {
  List<WorldInstance> rows = await MasterDatabase.instance.readAllRows();

  print(rows.length.toString() + " rows fetched.");
  print(rows.last.year.toString() + " is the last year.");
}
