import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'native_simulator_method_channel.dart';

abstract class NativeSimulatorPlatform extends PlatformInterface {
  /// Constructs a NativeSimulatorPlatform.
  NativeSimulatorPlatform() : super(token: _token);

  static final Object _token = Object();

  static NativeSimulatorPlatform _instance = MethodChannelNativeSimulator();

  /// The default instance of [NativeSimulatorPlatform] to use.
  ///
  /// Defaults to [MethodChannelNativeSimulator].
  static NativeSimulatorPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NativeSimulatorPlatform] when
  /// they register themselves.
  static set instance(NativeSimulatorPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
