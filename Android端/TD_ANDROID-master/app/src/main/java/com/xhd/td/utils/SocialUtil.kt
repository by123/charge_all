package com.xhd.td.utils


import com.xhd.td.BuildConfig
import com.xhd.td.utils.social.SocialHelper

/**
 * Created by arvinljw on 17/11/27 17:33
 * Function：
 * Desc：
 */
class SocialUtil private constructor() {

    private val socialHelper: SocialHelper = SocialHelper.Builder()
        .setWxAppId(BuildConfig.WECHAT_ID)
        .build()

    fun socialHelper(): SocialHelper {
        return socialHelper
    }

    companion object {
        val instance = SocialUtil()
    }
}
