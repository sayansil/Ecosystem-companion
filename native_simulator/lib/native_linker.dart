import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';


// Getting a library that holds needed symbols
DynamicLibrary getLibrary() {
  if (Platform.isAndroid) {
    return DynamicLibrary.open('libecosystem_wrapper.so');
  } else if (Platform.isMacOS) {
    return DynamicLibrary.open('libecosystem_wrapper.dylib');
  } else {
    return DynamicLibrary.process();
  }
}

DynamicLibrary _lib = getLibrary();

// Template the dart functions

class BufferData extends Struct {
  external Pointer<Uint8> data;

  @Uint32()
  external int length;
}

typedef CreateGod = Void Function(Uint8, Pointer<Utf8>);
typedef SetInitialOrganisms = Void Function(Uint32, Pointer<Utf8>, Uint32, Uint32);
typedef CleanSlate = Void Function();
typedef CreateWorld = Void Function();
typedef HappyNewYear = BufferData Function();
typedef FreeGod = Void Function();

// Link them to C functions

final void Function(int godsEye, Pointer<Utf8> ecosystemRoot) createGod = _lib
    .lookup<NativeFunction<CreateGod>>('create_god')
    .asFunction();
final void Function(int kingdom, Pointer<Utf8> kind, int age, int count) setInitialOrganisms = _lib
    .lookup<NativeFunction<SetInitialOrganisms>>('set_initial_organisms')
    .asFunction();
final void Function() cleanSlate = _lib
    .lookup<NativeFunction<CleanSlate>>('clean_slate')
    .asFunction();
final void Function() createWorld = _lib
    .lookup<NativeFunction<CreateWorld>>('create_world')
    .asFunction();
final BufferData Function() happyNewYear = _lib
    .lookup<NativeFunction<HappyNewYear>>('happy_new_year')
    .asFunction();
final void Function() freeGod = _lib
    .lookup<NativeFunction<FreeGod>>('free_god')
    .asFunction();