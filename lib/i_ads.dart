import 'package:flutter/material.dart';
import 'package:flutter_core_ads_manager/callback_ads.dart';
import 'package:flutter_core_ads_manager/iadsmanager/i_initialize.dart';
import 'package:flutter_core_ads_manager/iadsmanager/i_rewards.dart';
import 'package:flutter_core_ads_manager/size_ads.dart';

abstract class IAds {
  Future<String?> setConfigAds(Map<String, dynamic> config);
  void initialize(BuildContext context, IInitialize iInitialize);
  Future<void> setTestDevices(BuildContext context, List<String> testDevices);
  Future<void> loadGdpr(BuildContext context, bool childDirected);
  Widget showBanner(
    BuildContext context,
    SizeBanner sizeBanner,
    double? height,
    CallbackAds? callbackAds,
  );
  void loadInterstitial(BuildContext context);
  void showInterstitial(
    BuildContext context,
    CallbackAds? callbackAds,
  );
  Widget showNativeAds(
    BuildContext context,
    SizeNative sizeNative,
    double? height,
    CallbackAds? callbackAds,
  );
  void loadRewards(BuildContext context);
  void showRewards(
    BuildContext context,
    CallbackAds? callbackAds,
    IRewards? iRewards,
  );
}
