package com.xhd.td.net

import cn.xuexuan.mvvm.event.BusProvider
import com.xhd.td.constants.EventKey
import com.xhd.td.model.EventMessage
import com.xhd.td.model.UserModel
import okhttp3.Interceptor
import okhttp3.Request
import okhttp3.Response
import okhttp3.ResponseBody
import org.json.JSONObject
import java.io.IOException


/**
 * Created by czx on 2017/4/27.
 */

class DataInterceptor : Interceptor {


    @Throws(IOException::class)
    override fun intercept(chain: Interceptor.Chain): Response {

        val request = addHeard(chain.request())
        val requestUrl = request.url().toString()
        val response = chain.proceed(request)
        val context = response.body()!!.string()
        val responseBody = ""
        /*
            判断url中是否存在“？”字符  存在则不管
            即屏蔽掉get请求
        */
        try {
            val status = JSONObject(context).getInt("status")
            //检测到未登录的情况，跳转到登录页
            if (status == 90) {
                BusProvider.getBus()?.post(EventMessage<String>(EventKey.OTHER_USER_LOGIN, ""))
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }


        val mediaType = response.body()!!.contentType()
        return response.newBuilder().body(ResponseBody.create(mediaType, context)).build()
    }

    /**
     * 添加公共参数
     *
     * @param oldRequest
     * @return
     */
    private fun addHeard(oldRequest: Request): Request {

        return if (UserModel.TOKEN == null) {
            oldRequest.newBuilder().build()
        } else {
            val builder = oldRequest
                    .newBuilder()
                    .addHeader("Authorization", UserModel.TOKEN)
            builder.build()
        }
    }
}
