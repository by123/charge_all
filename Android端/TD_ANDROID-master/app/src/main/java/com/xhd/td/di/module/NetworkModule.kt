package com.xhd.td.di.module

import android.content.Context
import cn.xuexuan.mvvm.net.LogInterceptor
import cn.xuexuan.mvvm.net.XNet
import com.xhd.td.BuildConfig
import com.xhd.td.net.DataInterceptor
import com.xhd.td.net.HttpService
import dagger.Module
import dagger.Provides
import okhttp3.Cache
import okhttp3.OkHttpClient
import retrofit2.Retrofit
import java.util.concurrent.TimeUnit
import javax.inject.Singleton


@Module
class NetworkModule {


    @Provides
    @Singleton
    fun httpService(retrofit: Retrofit): HttpService = retrofit.create(HttpService::class.java)

    @Provides
    @Singleton
    fun providesRetrofit(): Retrofit {

        val url = if (BuildConfig.DEBUG){
            BuildConfig.TEST_BASE_URL
        }else{
            BuildConfig.BASE_URL
        }

        return XNet.getInstance().getRetrofit(url, true)
    }

    @Provides
    @Singleton
    fun providesOkHttpClient(cache: Cache): OkHttpClient {
        val client = OkHttpClient.Builder()
                .cache(cache)
                .connectTimeout(10, TimeUnit.SECONDS)
                .writeTimeout(30, TimeUnit.SECONDS)
                .readTimeout(10, TimeUnit.SECONDS)

        client.addInterceptor(DataInterceptor())
        if (BuildConfig.DEBUG) {
//            client.addNetworkInterceptor(StethoInterceptor())
            client.addInterceptor(LogInterceptor())
        }

        return client.build()
    }

    @Provides
    @Singleton
    fun providesOkhttpCache(context: Context): Cache {
        val cacheSize = 10 * 1024 * 1024 // 10 MB
        return Cache(context.cacheDir, cacheSize.toLong())
    }

}