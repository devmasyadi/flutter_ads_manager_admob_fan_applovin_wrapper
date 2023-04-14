package com.example.flutter_ads_manager_admob_fan_applovin_wrapper

import android.app.Activity
import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.widget.RelativeLayout
import com.adsmanager.adswrapper.AdsManagerWrapper
import com.adsmanager.core.CallbackAds
import com.adsmanager.core.SizeNative
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.MessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class NativePlatformView(
    private val activity: Activity,
    private val context: Context,
    private val adsManagerWrapper: AdsManagerWrapper,
    private val sizeNative: SizeNative,
    private val callbackChannel: BasicMessageChannel<String>
) : PlatformView {

    private val view: View = LayoutInflater.from(context).inflate(R.layout.layout_native_ads, null)

    init {
        val nativeView = view.findViewById<RelativeLayout>(R.id.nativeView)
        adsManagerWrapper.showNativeAds(activity, nativeView, sizeNative,  object : CallbackAds() {
            override fun onAdLoaded() {
                super.onAdLoaded()
                callbackChannel.send("NativeAdLoaded|")
            }

            override fun onAdFailedToLoad(error: String?) {
                super.onAdFailedToLoad(error)
                callbackChannel.send("NativeAdFailedToLoad|$error")
            }
        })
    }

    override fun getView(): View? {
        return view
    }

    override fun dispose() {

    }
}

class NativePlatformViewFactory(
    private val codec: MessageCodec<Any>,
    private val activity: Activity,
    private val context: Context,
    private val adsManagerWrapper: AdsManagerWrapper,
    private val callbackChannel: BasicMessageChannel<String>
) : PlatformViewFactory(codec) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val params = args as? Map<String, Any>
        val sizeNative = when (params?.get("sizeNative") as? String ?: "") {
            "Medium" -> SizeNative.MEDIUM
            "Small_Rectangle" -> SizeNative.SMALL_RECTANGLE
            else -> SizeNative.SMALL
        }
        return NativePlatformView(activity, context, adsManagerWrapper, sizeNative,  callbackChannel)
    }
}