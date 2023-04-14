import 'package:flutter/material.dart';
import 'package:flutter_core_ads_manager/callback_ads.dart';
import 'package:flutter_core_ads_manager/iadsmanager/i_initialize.dart';
import 'package:flutter_core_ads_manager/iadsmanager/i_rewards.dart';
import 'package:flutter_core_ads_manager/size_ads.dart';

import 'flutter_ads_manager_module_platform_interface.dart';

class FlutterAdsManagerWrapperModule {
  Future<String?> getPlatformVersion() {
    return FlutterAdsManagerWrapperModulePlatform.instance.getPlatformVersion();
  }

  void initialize(BuildContext context, IInitialize iInitialize) {
    return FlutterAdsManagerWrapperModulePlatform.instance
        .initialize(context, iInitialize);
  }

  ///Example
  /*
  setConfigAds({
    'isShowAds': true,
    'isShowOpenAd': true,
    'isShowBanner': false,
    'isShowInterstitial': true,
    'isShowNativeAd': false,
    'isShowRewards': false,
    'intervalTimeInterstitial': 10,
    'primaryOpenAdId': 'your_primary_open_ad_id',
    'secondaryOpenAdId': 'your_secondary_open_ad_id',
    'tertiaryOpenAdId': 'your_tertiary_open_ad_id',
    'quaternaryOpenAdId': 'your_quaternary_open_ad_id',
    'primaryAds': 'NONE',
    'secondaryAds': 'NONE',
    'tertiaryAds': 'NONE',
    'quaternaryAds': 'NONE',
    'primaryAppId': 'your_primary_app_id',
    'secondaryAppId': 'your_secondary_app_id',
    'tertiaryAppId': 'your_tertiary_app_id',
    'quaternaryAppId': 'your_quaternary_app_id',
    'primaryBannerId': 'your_primary_banner_id',
    'secondaryBannerId': 'your_secondary_banner_id',
    'tertiaryBannerId': 'your_tertiary_banner_id',
    'quaternaryBannerId': 'your_quaternary_banner_id',
    'primaryInterstitialId': 'your_primary_interstitial_id',
    'secondaryInterstitialId': 'your_secondary_interstitial_id',
    'tertiaryInterstitialId': 'your_tertiary_interstitial_id',
    'quaternaryInterstitialId': 'your_quaternary_interstitial_id',
    'primaryNativeId': 'your_primary_native_id',
    'secondaryNativeId': 'your_secondary_native_id',
    'tertiaryNativeId': 'your_tertiary_native_id',
    'quaternaryNativeId': 'your_quaternary_native_id',
    'primaryRewardsId': 'your_primary_rewards_id',
    'secondaryRewardsId': 'your_secondary_rewards_id',
    'tertiaryRewardsId': 'your_tertiary_rewards_id',
    'quaternaryRewardsId': 'your_quaternary_rewards_id',
  });
  */
  Future<String?> setConfigAds(Map<String, dynamic> config) {
    return FlutterAdsManagerWrapperModulePlatform.instance.setConfigAds(config);
  }

  void loadGdpr(BuildContext context, bool childDirected) {}

  void loadInterstitial(BuildContext context) {
    FlutterAdsManagerWrapperModulePlatform.instance.loadInterstitial(context);
  }

  void loadRewards(BuildContext context) {
    FlutterAdsManagerWrapperModulePlatform.instance.loadRewards(context);
  }

  Future<void> setTestDevices(BuildContext context, List<String> testDevices) {
    return FlutterAdsManagerWrapperModulePlatform.instance
        .setTestDevices(context, testDevices);
  }

  Widget showBanner(BuildContext context, SizeBanner sizeBanner, double? height,
      CallbackAds? callbackAds) {
    return FlutterAdsManagerWrapperModulePlatform.instance
        .showBanner(context, sizeBanner, height, callbackAds);
  }

  void showInterstitial(BuildContext context, CallbackAds? callbackAds) {
    FlutterAdsManagerWrapperModulePlatform.instance
        .showInterstitial(context, callbackAds);
  }

  Widget showNativeAds(BuildContext context, SizeNative sizeNative,
      double? height, CallbackAds? callbackAds) {
    return FlutterAdsManagerWrapperModulePlatform.instance
        .showNativeAds(context, sizeNative, height, callbackAds);
  }

  void showRewards(
      BuildContext context, CallbackAds? callbackAds, IRewards? iRewards) {
    FlutterAdsManagerWrapperModulePlatform.instance
        .showRewards(context, callbackAds, iRewards);
  }
}
