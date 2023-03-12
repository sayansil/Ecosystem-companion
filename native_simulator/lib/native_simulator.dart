import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:native_simulator/native_linker.dart';

class NativeSimulator {
  void initSimulation(String ecosystemRoot) {
    createGod(1, ecosystemRoot.toNativeUtf8());
    cleanSlate();
  }

  void createInitialOrganisms(int kingdom, String kind, int age, int count) {
    setInitialOrganisms(kingdom, kind.toNativeUtf8(), age, count);
  }

  void prepareWorld() {
    createWorld();
  }

  List<int> simulateOneYear() {
    final buffer = happyNewYear();
    final bufferArray = buffer.data.asTypedList(buffer.length);
    return bufferArray;
  }

  void cleanup() {
    freeGod();
  }
}

