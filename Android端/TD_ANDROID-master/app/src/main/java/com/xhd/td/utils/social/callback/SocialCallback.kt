package com.xhd.td.utils.social.callback

/**
 * Created by arvinljw on 17/11/24 16:21
 * Function：
 * Desc：
 */
interface SocialCallback {
    fun socialError(msg: String)
}

interface SocialNetCallback{

    fun getUerInfo(url:String):String?
    fun getAccessToken(code:String):String?
}