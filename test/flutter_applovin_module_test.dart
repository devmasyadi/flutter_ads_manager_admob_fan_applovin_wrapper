// import 'package:flutter_ads_manager_admob_fan_applovin_wrapper/flutter_ads_manager_module.dart';
// import 'package:flutter_ads_manager_admob_fan_applovin_wrapper/flutter_ads_manager_module_method_channel.dart';
// import 'package:flutter_ads_manager_admob_fan_applovin_wrapper/flutter_ads_manager_module_platform_interface.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockFlutterAdsManagerWrapperModulePlatform
//     with MockPlatformInterfaceMixin
//     implements FlutterAdsManagerWrapperModulePlatform {
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

// void main() {
//   final FlutterAdsManagerWrapperModulePlatform initialPlatform =
//       FlutterAdsManagerWrapperModulePlatform.instance;

//   test('$MethodChannelFlutterAdsManagerWrapperModule is the default instance',
//       () {
//     expect(initialPlatform,
//         isInstanceOf<MethodChannelFlutterAdsManagerWrapperModule>());
//   });

//   test('getPlatformVersion', () async {
//     FlutterAdsManagerWrapperModule flutterAdsManagerWrapperModulePlugin =
//         FlutterAdsManagerWrapperModule();
//     MockFlutterAdsManagerWrapperModulePlatform fakePlatform =
//         MockFlutterAdsManagerWrapperModulePlatform();
//     FlutterAdsManagerWrapperModulePlatform.instance = fakePlatform;

//     expect(
//         await flutterAdsManagerWrapperModulePlugin.getPlatformVersion(), '42');
//   });
// }
