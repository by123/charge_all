package cn.xuexuan.mvvm.net

import okhttp3.Interceptor
import okhttp3.Request
import okhttp3.Response

/**
 * Created by xuexuan on 2016/12/24.
 */

interface RequestHandler {
    fun onBeforeRequest(request: Request, chain: Interceptor.Chain): Request

    fun onAfterRequest(response: Response, result: String, chain: Interceptor.Chain): Response
}
