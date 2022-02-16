package cn.xuexuan.mvvm.net


import com.elvishew.xlog.XLog
import okhttp3.*
import okio.Buffer
import java.io.IOException

/**
 * Created by xuexuan on 2017/1/7.
 */

class LogInterceptor : Interceptor {

    @Throws(IOException::class)
    override fun intercept(chain: Interceptor.Chain): Response {
        val request = chain.request()
        logRequest(request)
        val response = chain.proceed(request)
        return logResponse(response)
    }


    private fun logRequest(request: Request) {
        try {
            XLog.d(request)
//            val url = request.url().toString()
//            val headers = request.headers()
//            request.method()
//            //url type headers body
////            XLog.d( )
//            if (headers != null && headers.size() > 0) {
//                XLog.d( "headers : $headers")
//            }
//            val requestBody = request.body()
//            if (requestBody != null) {
//                val mediaType = requestBody.contentType()
//                if (mediaType != null) {
//                    if (isText(mediaType)) {
//                        XLog.d( "params : " + bodyToString(request))
//                    } else {
//                        XLog.d("params : " + " maybe [file part] , too large too print , ignored!")
//                    }
//                }
//            }
//
//            XLog.d( arrayOf(("url : $url"),("method : " + request.method())))



        } catch (e: Exception) {
            e.printStackTrace()
        }

    }

    private fun logResponse(response: Response): Response {
        try {

            var mediaType = response.body()?.contentType()
            val data = response.body()?.string()?:"{}"
            XLog.d(response.newBuilder().body(ResponseBody.create(mediaType, data)).build())

            return response.newBuilder().body(ResponseBody.create(mediaType, data)).build()
//            response.newBuilder().body(response.body()).build()
//
//            try {
//
//                var body = response.body()
//                if (body != null) {
//                    val mediaType = body.contentType()
//                    if (mediaType != null) {
//                        if (isText(mediaType)) {
//                            val resp = body.string()
//
//                            body = ResponseBody.create(mediaType, resp)
//                            return response.newBuilder().body(body).build()
//                        } else {
//                            XLog.d(TAG, "data : " + " maybe [file part] , too large too print , ignored!")
//                        }
//                    }
//                }
//
//            } catch (e: Exception) {
//                e.printStackTrace()
//            }
//
//            return response




        } catch (e: Exception) {
            e.printStackTrace()
        }

        return response
    }


    private fun isText(mediaType: MediaType?): Boolean {
        return if (mediaType == null) false else "text" == mediaType.subtype()
                || "json" == mediaType.subtype()
                || "xml" == mediaType.subtype()
                || "html" == mediaType.subtype()
                || "webviewhtml" == mediaType.subtype()
                || "plain" == mediaType.subtype()
                || "x-www-form-urlencoded" == mediaType.subtype()

    }

    private fun bodyToString(request: Request): String {
        try {
            val copy = request.newBuilder().build()
            val buffer = Buffer()
            copy.body()!!.writeTo(buffer)
            return buffer.readUtf8()
        } catch (e: IOException) {
            return "something error when show requestBody."
        }

    }

    companion object {
        val TAG = "XDroid_Net"
    }
}
