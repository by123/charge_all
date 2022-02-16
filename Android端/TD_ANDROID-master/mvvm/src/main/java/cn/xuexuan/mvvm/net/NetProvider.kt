package cn.xuexuan.mvvm.net

import okhttp3.CookieJar
import okhttp3.OkHttpClient

/**
 * Created by xuexuan on 2016/12/24.
 */

interface NetProvider {
    fun configInterceptors(): Array<okhttp3.Interceptor>

    fun configHttps(builder: OkHttpClient.Builder)

    fun configCookie(): CookieJar?

    fun configHandler(): RequestHandler?

    fun configConnectTimeoutSec(): Long

    fun configReadTimeoutSec(): Long

    fun configLogEnable(): Boolean

    fun handleError(error: NetError): Boolean
}
