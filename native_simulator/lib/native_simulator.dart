import 'dart:convert';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:native_simulator/native_linker.dart';

class NativeSimulator {

  late Pointer<Void> sessionPtr;
  bool sessionRunning = false;

  void initSimulation(String ecosystemRoot) {
    if (!sessionRunning) {
      sessionPtr = sessionInit();
      sessionRunning = true;
    }

    createGod(sessionPtr, 1, ecosystemRoot.toNativeUtf8());
    cleanSlate(sessionPtr);
  }

  List<String> getAllAttributes() {
    if (!sessionRunning) {
      return [];
    }

    final listPtr = getPlotAttributes(sessionPtr);
    final listStr = listPtr.toDartString();

    return listStr.split(",");
  }

  void createInitialOrganisms(int kingdom, String kind, int age, int count) {
    if (!sessionRunning) {
      return;
    }

    setInitialOrganisms(sessionPtr, kingdom, kind.toNativeUtf8(), age, count);
  }

  void prepareWorld() {
    if (!sessionRunning) {
      return;
    }

    createWorld(sessionPtr);
  }

  List<int> simulateOneYear() {
    if (!sessionRunning) {
      return [];
    }

    final buffer = happyNewYear(sessionPtr);
    final bufferArray = buffer.data.asTypedList(buffer.length);
    return bufferArray;
  }

  void saveWorldInstance() {
    if (!sessionRunning) {
      return;
    }

    addCurrentWorldRecord(sessionPtr);
  }

  List<double> getPlotData(String species, String attribute) {
    if (!sessionRunning) {
      return [];
    }

    final buffer = getPlotValues(sessionPtr, species.toNativeUtf8(), attribute.toNativeUtf8());
    final bufferArray = buffer.data.asTypedList(buffer.length);
    return bufferArray;
  }

  void cleanup() {
    if (!sessionRunning) {
      return;
    }

    freeGod(sessionPtr);
    freeSession(sessionPtr);
    sessionRunning = false;
  }
}

