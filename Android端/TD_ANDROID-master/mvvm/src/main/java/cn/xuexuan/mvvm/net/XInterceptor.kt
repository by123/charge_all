package cn.xuexuan.mvvm.net

import okhttp3.Interceptor
import okhttp3.Response
import java.io.IOException

/**
 * Created by xuexuan on 2016/12/24.
 */

class XInterceptor(internal var handler: RequestHandler?) : Interceptor {

    @Throws(IOException::class)
    override fun intercept(chain: Interceptor.Chain): Response {
        var request = chain.request()
        if (handler != null) {
            request = handler!!.onBeforeRequest(request, chain)
        }
        var response = chain.proceed(request)
        if (handler != null) {
            response = handler!!.onAfterRequest(response, response.body()!!.string(), chain)
        }
        return response
    }
}
