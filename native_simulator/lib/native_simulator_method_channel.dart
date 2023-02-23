import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'native_simulator_platform_interface.dart';

/// An implementation of [NativeSimulatorPlatform] that uses method channels.
class MethodChannelNativeSimulator extends NativeSimulatorPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('native_simulator');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
