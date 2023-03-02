import 'package:ecosystem/database/database_manager.dart';
import 'package:ecosystem/database/tableSchema/ecosystem_master.dart';
import 'package:native_simulator/native_simulator.dart';
import 'package:shared_preferences/shared_preferences.dart';

void testDb() async {
  List<WorldInstance> rows = await MasterDatabase.instance.readAllRows();

  print(rows.length.toString() + " rows fetched.");
  print(rows.last.year.toString() + " is the last year.");
}

Future<void> testFfi() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final ecosystemRoot = prefs.getString('ecosystemRoot') ?? "";

  nativeCreateGod(false, ecosystemRoot);
}