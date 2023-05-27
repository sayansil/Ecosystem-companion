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
    return [
      "ageFitnessOnDeathRatio",
      "conceivingProbability",
      "matingProbability",
      "matingAgeStart",
      "matingAgeEnd",
      "maxAge",
      "mutationProbability",
      "offspringsFactor",
    ];
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

  void cleanup() {
    if (!sessionRunning) {
      return;
    }

    freeGod(sessionPtr);
    freeSession(sessionPtr);
    sessionRunning = false;
  }
}

