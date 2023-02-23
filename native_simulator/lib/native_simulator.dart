
import 'dart:ffi';
import 'dart:io';


// Getting a library that holds needed symbols
DynamicLibrary _lib = Platform.isAndroid
    ? DynamicLibrary.open('libnative_simulator.so')
    : DynamicLibrary.process();

// Create the dart functions

typedef NativeAdd = Int32 Function(Int32, Int32);
final int Function(int a, int b) add = _lib
    .lookup<NativeFunction<NativeAdd>>('add')
    .asFunction();


//
// class NativeSimulator {
//
//   // final DynamicLibrary nativeSimulatorLib = Platform.isAndroid
//   //     ? DynamicLibrary.open('libnative_simulator.so')
//   //     : DynamicLibrary.process();
//   //
//   // final int Function(int x, int y) add = nativeSimulatorLib
//   //     .lookup<NativeFunction<Int32 Function(Int32, Int32)>>('add')
//   //     .asFunction();
//   //
//   // void test() {
//   //
//   // }
//
//
//
//
//   Future<String?> getPlatformVersion() {
//     return NativeSimulatorPlatform.instance.getPlatformVersion();
//   }
// }
