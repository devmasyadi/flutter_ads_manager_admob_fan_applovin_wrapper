import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ads_manager_admob_fan_applovin_wrapper/flutter_ads_manager_module_platform_interface.dart';
import 'package:flutter_core_ads_manager/rewards/rewards_item.dart';
import 'package:flutter_core_ads_manager/size_ads.dart';
import 'package:flutter_core_ads_manager/iadsmanager/i_rewards.dart';
import 'package:flutter_core_ads_manager/iadsmanager/i_initialize.dart';
import 'package:flutter_core_ads_manager/callback_ads.dart';

import 'ads/banner_view.dart';
import 'ads/native_view.dart';

/// An implementation of [FlutterAdsManagerWrapperModulePlatform] that uses method channels.
class MethodChannelFlutterAdsManagerWrapperModule
    extends FlutterAdsManagerWrapperModulePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel =
      const MethodChannel('flutter_ads_manager_wrapper_module');
  static const BasicMessageChannel<String> _callbackChannel =
      BasicMessageChannel<String>(
          'flutter_ads_manager_wrapper_module_callback', StringCodec());

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> setConfigAds(Map<String, dynamic> config) async {
    final result = await methodChannel.invokeMethod('setConfigAds', config);
    return result;
  }

  @override
  void initialize(BuildContext context, IInitialize? iInitialize) async {
    _callbackChannel.setMessageHandler((message) {
      try {
        final parts = message!.split('|');
        final event = parts[0];
        switch (event) {
          case 'onInitializationComplete':
            iInitialize?.onInitializationComplete!();
            break;
        }
        return Future.value(event);
      } catch (err) {
        debugPrint(err.toString());
        return Future.value(err.toString());
      }
    });

    await methodChannel.invokeMethod('initialize');
  }

  @override
  Future<void> loadGdpr(BuildContext context, bool childDirected) async {
    await methodChannel
        .invokeMethod("loadGdpr", {"childDirected": childDirected});
  }

  @override
  void loadInterstitial(BuildContext context) {
    methodChannel.invokeMethod("loadInterstitial");
  }

  @override
  void loadRewards(BuildContext context) {
    methodChannel.invokeMethod("loadRewards");
  }

  @override
  Future<void> setTestDevices(
      BuildContext context, List<String> testDevices) async {
    await methodChannel
        .invokeMethod("setTestDevices", {"testDevices": testDevices});
    return Future.value();
  }

  @override
  Widget showBanner(BuildContext context, SizeBanner sizeBanner, double? height,
      CallbackAds? callbackAds) {
    return BannerView(
      callbackAds: callbackAds,
      height: height,
      sizeBanner: sizeBanner,
    );
  }

  @override
  void showInterstitial(BuildContext context, CallbackAds? callbackAds) {
    _callbackChannel.setMessageHandler((message) {
      try {
        final parts = message!.split('|');
        final event = parts[0];
        final data = parts[1];

        switch (event) {
          case 'InterstitialAdLoaded':
            callbackAds?.onAdLoaded?.call(data);
            break;
          case 'InterstitialAdFailedToLoad':
            callbackAds?.onAdFailedToLoad?.call(data);
            break;
        }
        return Future.value(event);
      } catch (err) {
        callbackAds?.onAdFailedToLoad?.call(err.toString());
        return Future.value(err.toString());
      }
    });

    methodChannel.invokeMethod('showInterstitial');
  }

  @override
  Widget showNativeAds(BuildContext context, SizeNative sizeNative,
      double? height, CallbackAds? callbackAds) {
    return NativeView(
      callbackAds: callbackAds,
      height: height,
      sizeNative: sizeNative,
    );
  }

  @override
  void showRewards(
      BuildContext context, CallbackAds? callbackAds, IRewards? iRewards) {
    _callbackChannel.setMessageHandler((message) {
      try {
        final parts = message!.split('|');
        final event = parts[0];
        final data = parts[1];

        switch (event) {
          case 'RewardsAdLoaded':
            callbackAds?.onAdLoaded?.call(data);
            break;
          case 'RewardsAdFailedToLoad':
            callbackAds?.onAdFailedToLoad?.call(data);
            break;
          case 'RewardsUserEarnedReward':
            iRewards?.onUserEarnedReward
                ?.call(RewardsItem(amount: 10, type: "coin"));
            break;
        }
        debugPrint("parts $parts");
        return Future.value(event);
      } catch (err) {
        callbackAds?.onAdFailedToLoad?.call(err.toString());
        return Future.value(err.toString());
      }
    });

    methodChannel.invokeMethod('showRewards');
  }
}
