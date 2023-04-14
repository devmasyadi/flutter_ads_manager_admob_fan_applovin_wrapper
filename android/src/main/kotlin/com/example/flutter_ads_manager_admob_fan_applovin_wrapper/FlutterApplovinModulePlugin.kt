package com.example.flutter_ads_manager_admob_fan_applovin_wrapper

import android.app.Activity
import android.content.Context
import android.util.Log
import androidx.annotation.NonNull
import com.adsmanager.admob.AdmobAds
import com.adsmanager.ads.AdsManager
import com.adsmanager.ads.HandleAds
import com.adsmanager.adswrapper.AdsManagerWrapper
import com.adsmanager.applovin.ApplovinDiscoveryAds
import com.adsmanager.applovin.ApplovinMaxAds
import com.adsmanager.core.CallbackAds
import com.adsmanager.core.ConfigAds
import com.adsmanager.core.NetworkAds
import com.adsmanager.core.iadsmanager.IInitialize
import com.adsmanager.core.rewards.IRewards
import com.adsmanager.core.rewards.RewardsItem
import com.adsmanager.fan.FanAds

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.*
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlutterApplovinModulePlugin */
class FlutterApplovinModulePlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private val CALLBACK_CHANNEL = "flutter_ads_manager_wrapper_module_callback"
  private lateinit var channel : MethodChannel
  private lateinit var adsManagerWrapper: AdsManagerWrapper
  private lateinit var context: Context
  private lateinit var callbackChannel: BasicMessageChannel<String>
  private lateinit var activity: Activity
  private lateinit var binaryMessenger: BinaryMessenger
  private lateinit var flutterPluginBinding: FlutterPlugin.FlutterPluginBinding

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_ads_manager_wrapper_module")
    this.flutterPluginBinding = flutterPluginBinding
    binaryMessenger = flutterPluginBinding.binaryMessenger
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "getPlatformVersion" -> {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
      }
      "setConfigAds" -> {
        setConfigAds(call, result)
      }
      "initialize" -> {
        adsManagerWrapper.initialize(context, object : IInitialize {
          override fun onInitializationComplete() {
            activity.runOnUiThread {
              callbackChannel.send("onInitializationComplete|")
            }
          }
        })
        flutterPluginBinding.platformViewRegistry.registerViewFactory(
          "bannerAds",
          BannerPlatformViewFactory(
            StandardMessageCodec.INSTANCE,
            activity,
            context,
            adsManagerWrapper,
            callbackChannel
          )
        )
        flutterPluginBinding.platformViewRegistry.registerViewFactory(
          "nativeAds",
          NativePlatformViewFactory(
            StandardMessageCodec.INSTANCE,
            activity,
            context,
            adsManagerWrapper,
            callbackChannel
          )
        )
      }
      "setTestDevices" -> {
        val testDevices = call.argument<List<String>>("testDevices")
        testDevices?.let { adsManagerWrapper.setTestDevices(activity, it) }
      }
      "loadGdpr" -> {
        val childDirected = call.argument<Boolean>("childDirected")
        adsManagerWrapper.loadGdpr(activity, childDirected == true)
      }
      "loadInterstitial" -> {
        adsManagerWrapper.loadInterstitial(activity)
      }
      "loadRewards" -> {
        adsManagerWrapper.loadRewards(activity)
      }
      "showInterstitial" -> {
        adsManagerWrapper.showInterstitial(activity, object : CallbackAds() {
          override fun onAdFailedToLoad(error: String?) {
            super.onAdFailedToLoad(error)
            activity.runOnUiThread {
              callbackChannel.send("InterstitialAdFailedToLoad|$error")
            }
          }

          override fun onAdLoaded() {
            super.onAdLoaded()
            activity.runOnUiThread {
              callbackChannel.send("InterstitialAdLoaded|")
            }
          }
        })
      }
      "showRewards" -> {
        adsManagerWrapper.showRewards(activity, object : CallbackAds() {
          override fun onAdFailedToLoad(error: String?) {
            super.onAdFailedToLoad(error)
            activity.runOnUiThread {
              callbackChannel.send("RewardsAdFailedToLoad|$error")
            }
          }

          override fun onAdLoaded() {
            super.onAdLoaded()
            activity.runOnUiThread {
              callbackChannel.send("RewardsAdLoaded|")
            }
          }
        }, object : IRewards {
          override fun onUserEarnedReward(rewardsItem: RewardsItem?) {
            activity.runOnUiThread {
              callbackChannel.send("RewardsUserEarnedReward|${rewardsItem.toString()}")
            }
          }
        })
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  private fun setConfigAds(call: MethodCall, result: Result) {
    // Ambil argumen dari method call dan set ConfigAds properties
    ConfigAds.isShowAds = call.argument<Boolean>("isShowAds") ?: ConfigAds.isShowAds
    ConfigAds.isShowOpenAd = call.argument<Boolean>("isShowOpenAd") ?: ConfigAds.isShowOpenAd
    ConfigAds.isShowBanner = call.argument<Boolean>("isShowBanner") ?: ConfigAds.isShowBanner
    ConfigAds.isShowInterstitial = call.argument<Boolean>("isShowInterstitial") ?: ConfigAds.isShowInterstitial
    ConfigAds.isShowNativeAd = call.argument<Boolean>("isShowNativeAd") ?: ConfigAds.isShowNativeAd
    ConfigAds.isShowRewards = call.argument<Boolean>("isShowRewards") ?: ConfigAds.isShowRewards

    ConfigAds.intervalTimeInterstitial = call.argument<Int>("intervalTimeInterstitial") ?: ConfigAds.intervalTimeInterstitial

    ConfigAds.primaryOpenAdId = call.argument<String>("primaryOpenAdId") ?: ConfigAds.primaryOpenAdId
    ConfigAds.secondaryOpenAdId = call.argument<String>("secondaryOpenAdId") ?: ConfigAds.secondaryOpenAdId
    ConfigAds.tertiaryOpenAdId = call.argument<String>("tertiaryOpenAdId") ?: ConfigAds.tertiaryOpenAdId
    ConfigAds.quaternaryOpenAdId = call.argument<String>("quaternaryOpenAdId") ?: ConfigAds.quaternaryOpenAdId

    // Set NetworkAds properties dengan memeriksa string sebelum mengubahnya menjadi enum
    call.argument<String>("primaryAds")?.let { primaryAds ->
      ConfigAds.primaryAds = handleNetworkAds(primaryAds)
    }
    call.argument<String>("secondaryAds")?.let { secondaryAds ->
      ConfigAds.secondaryAds = handleNetworkAds(secondaryAds)
    }
    call.argument<String>("tertiaryAds")?.let { tertiaryAds ->
      ConfigAds.tertiaryAds = handleNetworkAds(tertiaryAds)
    }
    call.argument<String>("quaternaryAds")?.let { quaternaryAds ->
      ConfigAds.quaternaryAds = handleNetworkAds(quaternaryAds)
    }

    // Set properties lainnya
    ConfigAds.primaryAppId = call.argument<String>("primaryAppId") ?: ConfigAds.primaryAppId
    ConfigAds.secondaryAppId = call.argument<String>("secondaryAppId") ?: ConfigAds.secondaryAppId
    ConfigAds.tertiaryAppId = call.argument<String>("tertiaryAppId") ?: ConfigAds.tertiaryAppId
    ConfigAds.quaternaryAppId = call.argument<String>("quaternaryAppId") ?: ConfigAds.quaternaryAppId

    ConfigAds.primaryBannerId = call.argument<String>("primaryBannerId") ?: ConfigAds.primaryBannerId
    ConfigAds.secondaryBannerId = call.argument<String>("secondaryBannerId") ?: ConfigAds.secondaryBannerId
    ConfigAds.tertiaryBannerId = call.argument<String>("tertiaryBannerId") ?: ConfigAds.tertiaryBannerId
    ConfigAds.quaternaryBannerId = call.argument<String>("quaternaryBannerId") ?: ConfigAds.quaternaryBannerId

    ConfigAds.primaryInterstitialId = call.argument<String>("primaryInterstitialId") ?: ConfigAds.primaryInterstitialId
    ConfigAds.secondaryInterstitialId = call.argument<String>("secondaryInterstitialId") ?: ConfigAds.secondaryInterstitialId
    ConfigAds.tertiaryInterstitialId = call.argument<String>("tertiaryInterstitialId") ?: ConfigAds.tertiaryInterstitialId
    ConfigAds.quaternaryInterstitialId = call.argument<String>("quaternaryInterstitialId") ?: ConfigAds.quaternaryInterstitialId

    ConfigAds.primaryNativeId = call.argument<String>("primaryNativeId") ?: ConfigAds.primaryNativeId
    ConfigAds.secondaryNativeId = call.argument<String>("secondaryNativeId") ?: ConfigAds.secondaryNativeId
    ConfigAds.tertiaryNativeId = call.argument<String>("tertiaryNativeId") ?: ConfigAds.tertiaryNativeId
    ConfigAds.quaternaryNativeId = call.argument<String>("quaternaryNativeId") ?: ConfigAds.quaternaryNativeId

    ConfigAds.primaryRewardsId = call.argument<String>("primaryRewardsId") ?: ConfigAds.primaryRewardsId
    ConfigAds.secondaryRewardsId = call.argument<String>("secondaryRewardsId") ?: ConfigAds.secondaryRewardsId
    ConfigAds.tertiaryRewardsId = call.argument<String>("tertiaryRewardsId") ?: ConfigAds.tertiaryRewardsId
    ConfigAds.quaternaryRewardsId = call.argument<String>("quaternaryRewardsId") ?: ConfigAds.quaternaryRewardsId

    // Kirim respons ke Flutter
    result.success("ConfigAds success")
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    val handleAds = HandleAds(
      AdmobAds(),
      FanAds(),
      ApplovinMaxAds(),
      ApplovinDiscoveryAds()
    )
    adsManagerWrapper = AdsManagerWrapper(AdsManager(handleAds))
    activity = binding.activity
    channel.setMethodCallHandler(this)
    context = binding.activity
    callbackChannel =
      BasicMessageChannel(binaryMessenger, CALLBACK_CHANNEL, StringCodec.INSTANCE)
  }

  override fun onDetachedFromActivityForConfigChanges() {

  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {

  }

  override fun onDetachedFromActivity() {

  }

  private fun handleNetworkAds(networkAdsStr: String): NetworkAds {
    return when (networkAdsStr) {
        "Admob" -> {
          NetworkAds.ADMOB
        }
      "Fan" -> {
        NetworkAds.FAN
      }
      "Applovin-Max" -> {
        NetworkAds.APPLOVIN_MAX
      }
      "Applovin-Discovery" -> {
        NetworkAds.APPLOVIN_DISCOVERY
      }
        else -> NetworkAds.NONE
    }

  }
}
