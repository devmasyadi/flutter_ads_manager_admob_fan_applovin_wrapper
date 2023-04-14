package com.example.flutter_ads_manager_admob_fan_applovin_wrapper

import android.app.Activity
import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.widget.RelativeLayout
import com.adsmanager.adswrapper.AdsManagerWrapper
import com.adsmanager.core.CallbackAds
import com.adsmanager.core.SizeBanner
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.MessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class BannerPlatformView(
    activity: Activity,
    context: Context,
    private val adsManagerWrapper: AdsManagerWrapper,
    private val sizeBanner: SizeBanner,
    private val callbackChannel: BasicMessageChannel<String>
) : PlatformView {

    private val view: View = LayoutInflater.from(context).inflate(R.layout.layout_banner_ads, null)

    init {
        val bannerView = view.findViewById<RelativeLayout>(R.id.bannerView)
        adsManagerWrapper.showBanner(activity, bannerView, sizeBanner, object : CallbackAds() {
            override fun onAdLoaded() {
                super.onAdLoaded()
                callbackChannel.send("BannerAdLoaded|")
            }

            override fun onAdFailedToLoad(error: String?) {
                super.onAdFailedToLoad(error)
                callbackChannel.send("BannerAdFailedToLoad|$error")
            }
        })
    }

    override fun getView(): View {
        return view
    }

    override fun dispose() {

    }
}

class BannerPlatformViewFactory(
    private val codec: MessageCodec<Any>,
    private val activity: Activity,
    private val context: Context,
    private val adsManagerWrapper: AdsManagerWrapper,
    private val callbackChannel: BasicMessageChannel<String>
) : PlatformViewFactory(codec) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val params = args as? Map<String, Any>
        val sizeBannerString = params?.get("sizeBanner") as? String ?: ""
        val sizeBanner = if (sizeBannerString == "Medium") SizeBanner.MEDIUM else SizeBanner.SMALL
        return BannerPlatformView(activity, context, adsManagerWrapper, sizeBanner, callbackChannel)
    }
}