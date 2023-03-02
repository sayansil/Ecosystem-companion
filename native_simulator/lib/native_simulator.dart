import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';


// Getting a library that holds needed symbols
DynamicLibrary _lib = Platform.isAndroid
    ? DynamicLibrary.open('libecosystem_wrapper.so')
    : DynamicLibrary.process();

// Create the dart functions

typedef CreateGod = Void Function(Uint8, Pointer<Utf8>);
final void Function(int godsEye, Pointer<Utf8> ecosystemRoot) createGod = _lib
    .lookup<NativeFunction<CreateGod>>('create_god')
    .asFunction();

void nativeCreateGod(bool godsEye, String ecosystemRoot) {
  createGod(godsEye ? 1 : 0, ecosystemRoot.toNativeUtf8());
}