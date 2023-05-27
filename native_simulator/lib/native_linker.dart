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

typedef SessionInit = Pointer<Void> Function();
typedef CreateGod = Void Function(Pointer<Void>, Uint8, Pointer<Utf8>);
typedef SetInitialOrganisms = Void Function(Pointer<Void>, Uint32, Pointer<Utf8>, Uint32, Uint32);
typedef CleanSlate = Void Function(Pointer<Void>);
typedef CreateWorld = Void Function(Pointer<Void>);
typedef HappyNewYear = BufferData Function(Pointer<Void>);
typedef FreeGod = Void Function(Pointer<Void>);
typedef SessionFree = Void Function(Pointer<Void>);

// Link them to C functions

final Pointer<Void> Function() sessionInit = _lib
    .lookup<NativeFunction<SessionInit>>('session_init')
    .asFunction();
final void Function(Pointer<Void> session, int godsEye, Pointer<Utf8> ecosystemRoot) createGod = _lib
    .lookup<NativeFunction<CreateGod>>('create_god')
    .asFunction();
final void Function(Pointer<Void> session, int kingdom, Pointer<Utf8> kind, int age, int count) setInitialOrganisms = _lib
    .lookup<NativeFunction<SetInitialOrganisms>>('set_initial_organisms')
    .asFunction();
final void Function(Pointer<Void> session) cleanSlate = _lib
    .lookup<NativeFunction<CleanSlate>>('clean_slate')
    .asFunction();
final void Function(Pointer<Void> session) createWorld = _lib
    .lookup<NativeFunction<CreateWorld>>('create_world')
    .asFunction();
final BufferData Function(Pointer<Void> session) happyNewYear = _lib
    .lookup<NativeFunction<HappyNewYear>>('happy_new_year')
    .asFunction();
final void Function(Pointer<Void> session) freeGod = _lib
    .lookup<NativeFunction<FreeGod>>('free_god')
    .asFunction();
final void Function(Pointer<Void> session) freeSession = _lib
    .lookup<NativeFunction<SessionFree>>('free_session')
    .asFunction();