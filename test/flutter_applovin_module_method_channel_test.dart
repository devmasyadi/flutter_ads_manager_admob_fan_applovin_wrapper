import 'package:flutter/services.dart';
import 'package:flutter_ads_manager_admob_fan_applovin_wrapper/flutter_ads_manager_module_method_channel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  MethodChannelFlutterAdsManagerWrapperModule platform =
      MethodChannelFlutterAdsManagerWrapperModule();
  const MethodChannel channel =
      MethodChannel('flutter_ads_manager_wrapper_module');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
