import 'package:ecosystem/database/database_manager.dart';
import 'package:ecosystem/database/tableSchema/ecosystem_master.dart';
import 'package:native_simulator/native_simulator.dart';

void testDb() async {
  List<WorldInstance> rows = await MasterDatabase.instance.readAllRows();

  print(rows.length.toString() + " rows fetched.");
  print(rows.last.year.toString() + " is the last year.");
}

void testFfi(int a, int b) {
  var sum = add(a, b);
  print("Sum: " + sum.toString());
}