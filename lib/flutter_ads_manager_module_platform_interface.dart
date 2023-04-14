import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_ads_manager_module_method_channel.dart';
import 'i_ads.dart';

abstract class FlutterAdsManagerWrapperModulePlatform extends PlatformInterface
    implements IAds {
  /// Constructs a FlutterAdsManagerWrapperModulePlatform.
  FlutterAdsManagerWrapperModulePlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterAdsManagerWrapperModulePlatform _instance =
      MethodChannelFlutterAdsManagerWrapperModule();

  /// The default instance of [FlutterAdsManagerWrapperModulePlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterAdsManagerWrapperModule].
  static FlutterAdsManagerWrapperModulePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterAdsManagerWrapperModulePlatform] when
  /// they register themselves.
  static set instance(FlutterAdsManagerWrapperModulePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
