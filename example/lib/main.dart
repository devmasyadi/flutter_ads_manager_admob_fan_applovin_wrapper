import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_ads_manager_admob_fan_applovin_wrapper/flutter_ads_manager_module.dart';
import 'package:flutter_core_ads_manager/callback_ads.dart';
import 'package:flutter_core_ads_manager/iadsmanager/i_initialize.dart';
import 'package:flutter_core_ads_manager/iadsmanager/i_rewards.dart';
import 'package:flutter_core_ads_manager/size_ads.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  bool _isShowBanner = false;
  bool _isShowNative = false;
  final flutterAdsManagerWrapper = FlutterAdsManagerWrapperModule();

  @override
  void initState() {
    super.initState();
    initPlatformState();
    flutterAdsManagerWrapper.setConfigAds({
      'isShowAds': true,
      'isShowOpenAd': true,
      'isShowBanner': true,
      'isShowInterstitial': true,
      'isShowNativeAd': true,
      'isShowRewards': true,
      'intervalTimeInterstitial': 0,
      'primaryOpenAdId': 'your_primary_open_ad_id',
      'secondaryOpenAdId': 'your_secondary_open_ad_id',
      'tertiaryOpenAdId': 'your_tertiary_open_ad_id',
      'quaternaryOpenAdId': 'your_quaternary_open_ad_id',
      'primaryAds': 'Admob',
      'secondaryAds': 'Fan',
      'tertiaryAds': 'Applovin-Max',
      'quaternaryAds': 'Applovin-Discovery',
      'primaryAppId': 'your_primary_app_id',
      'secondaryAppId': 'your_secondary_app_id',
      'tertiaryAppId': 'your_tertiary_app_id',
      'quaternaryAppId': 'your_quaternary_app_id',
      'primaryBannerId': 'ca-app-pub-3940256099942544/6300978111XXX',
      'secondaryBannerId': '1363711600744576_1363713000744436XX',
      'tertiaryBannerId': 'your_tertiary_banner_id',
      'quaternaryBannerId': 'your_quaternary_banner_id',
      'primaryInterstitialId': 'ca-app-pub-3940256099942544/1033173712',
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
    }).then((value) {
      debugPrint("configAds: $value");
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await flutterAdsManagerWrapper.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('Running on: $_platformVersion\n'),
              ElevatedButton(
                onPressed: () {
                  flutterAdsManagerWrapper.initialize(
                    context,
                    IInitialize(
                      onInitializationComplete: () async {
                        debugPrint('Initialization complete!');
                        flutterAdsManagerWrapper.loadGdpr(context, false);
                        flutterAdsManagerWrapper.setTestDevices(
                            context, ["57b2fe61-8365-4cc9-962b-7481ff2ec9b0"]);
                        flutterAdsManagerWrapper.loadInterstitial(context);
                        flutterAdsManagerWrapper.loadRewards(context);
                      },
                    ),
                  );
                },
                child: const Text("Initialize"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isShowBanner = !_isShowBanner;
                  });
                },
                child: const Text("Show Banner"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isShowNative = !_isShowNative;
                  });
                },
                child: const Text("Show Native"),
              ),
              ElevatedButton(
                onPressed: () {
                  flutterAdsManagerWrapper.showInterstitial(
                    context,
                    CallbackAds(
                      onAdLoaded: (message) {
                        debugPrint('HALLO: onAdLoaded');
                      },
                      onAdFailedToLoad: (error) {
                        debugPrint('HALLO: onAdFailedToLoad $error');
                      },
                    ),
                  );
                },
                child: const Text("Show Intersitial"),
              ),
              ElevatedButton(
                onPressed: () {
                  flutterAdsManagerWrapper.showRewards(
                      context,
                      CallbackAds(
                        onAdLoaded: (message) {
                          debugPrint('HALLO rewards: onAdLoaded');
                        },
                        onAdFailedToLoad: (error) {
                          debugPrint('HALLO rewards: onAdFailedToLoad $error');
                        },
                      ), IRewards(
                    onUserEarnedReward: (rewardsItem) {
                      debugPrint(
                          'HALLO rewards: onUserEarnedReward $rewardsItem');
                    },
                  ));
                },
                child: const Text("Show Rewards"),
              ),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_isShowBanner)
                    flutterAdsManagerWrapper.showBanner(
                      context,
                      SizeBanner.SMALL,
                      60,
                      CallbackAds(
                        onAdLoaded: (message) {
                          debugPrint('Banner bro: onAdLoaded $message');
                        },
                        onAdFailedToLoad: (error) {
                          debugPrint('onAdFailedToLoad $error');
                        },
                      ),
                    ),
                  if (_isShowNative)
                    flutterAdsManagerWrapper.showNativeAds(
                      context,
                      SizeNative.MEDIUM,
                      100,
                      CallbackAds(
                        onAdLoaded: (message) {
                          debugPrint('Native bro: onAdLoaded $message');
                        },
                        onAdFailedToLoad: (error) {
                          debugPrint('Native onAdFailedToLoad $error');
                        },
                      ),
                    ),
                  const Text("Test"),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
