package cn.xuexuan.mvvm.net


import cn.xuexuan.mvvm.utils.Kits
import com.jakewharton.retrofit2.adapter.rxjava2.RxJava2CallAdapterFactory
import io.reactivex.Flowable
import io.reactivex.FlowableTransformer
import io.reactivex.Single
import io.reactivex.SingleTransformer
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.schedulers.Schedulers
import okhttp3.OkHttpClient
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import java.util.*
import java.util.concurrent.TimeUnit

/**
 * Created by xuexuan on 2016/12/24.
 */

class XNet private constructor() {

    private val providerMap = HashMap<String, NetProvider>()
    private val retrofitMap = HashMap<String, Retrofit>()
    private val clientMap = HashMap<String, OkHttpClient>()


    fun getRetrofit(baseUrl: String, useRx: Boolean): Retrofit {
        return getRetrofit(baseUrl, null, useRx)
    }


    fun getRetrofit(baseUrl: String, provider: NetProvider?, useRx: Boolean): Retrofit {
        var provider = provider
        if (Kits.Empty.check(baseUrl)) {
            throw IllegalStateException("baseUrl can not be null")
        }
        if (retrofitMap[baseUrl] != null) return retrofitMap[baseUrl]!!

        if (provider == null) {
            provider = providerMap[baseUrl]
            if (provider == null) {
                provider = commonProvider
            }
        }
        checkProvider(provider)

        val builder = Retrofit.Builder()
            .baseUrl(baseUrl)
            .client(getClient(baseUrl, provider))
            .addConverterFactory(GsonConverterFactory.create())
        if (useRx) {
            builder.addCallAdapterFactory(RxJava2CallAdapterFactory.create())
        }

        val retrofit = builder.build()
        retrofitMap[baseUrl] = retrofit
        providerMap[baseUrl] = provider

        return retrofit
    }

    private fun getClient(baseUrl: String, provider: NetProvider): OkHttpClient {
        if (Kits.Empty.check(baseUrl)) {
            throw IllegalStateException("baseUrl can not be null")
        }
        if (clientMap[baseUrl] != null) return clientMap[baseUrl]!!

        checkProvider(provider)

        val builder = OkHttpClient.Builder()

        builder.connectTimeout(
            if (provider.configConnectTimeoutSec() != 0L)
                provider.configConnectTimeoutSec()
            else
                connectTimeoutSec, TimeUnit.SECONDS
        )
        builder.readTimeout(
            if (provider.configReadTimeoutSec() != 0L)
                provider.configReadTimeoutSec()
            else
                readTimeoutSec, TimeUnit.SECONDS
        )

        val cookieJar = provider.configCookie()
        if (cookieJar != null) {
            builder.cookieJar(cookieJar)
        }
        provider.configHttps(builder)

        val handler = provider.configHandler()
        if (handler != null) {
            builder.addInterceptor(XInterceptor(handler))
        }

        val interceptors = provider.configInterceptors()
        if (!Kits.Empty.check(interceptors)) {
            for (interceptor in interceptors) {
                builder.addInterceptor(interceptor)
            }
        }

        if (provider.configLogEnable()) {
            val logInterceptor = LogInterceptor()
            builder.addInterceptor(logInterceptor)
        }

        val client = builder.build()
        clientMap[baseUrl] = client
        providerMap[baseUrl] = provider

        return client
    }


    private fun checkProvider(provider: NetProvider?) {
        if (provider == null) {
            throw IllegalStateException("must register provider first")
        }
    }

    fun getRetrofitMap(): Map<String, Retrofit> {
        return retrofitMap
    }

    fun getClientMap(): Map<String, OkHttpClient> {
        return clientMap
    }

    companion object {
        lateinit var commonProvider: NetProvider


        val connectTimeoutSec = 10L
        val readTimeoutSec = 10L

        private var instance: XNet? = null

        fun getInstance(): XNet {
            if (instance == null) {
                synchronized(XNet::class.java) {
                    if (instance == null) {
                        instance = XNet()
                    }
                }
            }
            return instance!!
        }


        operator fun <S> get(baseUrl: String, service: Class<S>): S {
            return getInstance().getRetrofit(baseUrl, true).create(service)
        }

        fun registerProvider(provider: NetProvider) {
            commonProvider = provider
        }

        fun registerProvider(baseUrl: String, provider: NetProvider) {
            getInstance().providerMap[baseUrl] = provider
        }

        fun clearCache() {
            getInstance().retrofitMap.clear()
            getInstance().clientMap.clear()
        }

        /**
         * 线程切换
         *
         * @return
         */
        fun <T : NetModel> getScheduler(): FlowableTransformer<T, T> {
            return FlowableTransformer { upstream ->
                upstream.subscribeOn(Schedulers.io())
                    .observeOn(AndroidSchedulers.mainThread())
            }
        }


        /**
         * 处理业务方面的错误
         *
         * @return
         */
        fun <U : NetModel, D> getApiTransformer(): FlowableTransformer<U, U> {

            return FlowableTransformer { upstream ->
                upstream.flatMap {
                    if (it == null || it.isNull) {
                        Flowable.error(NetError(it.errorMsg, NetError.NoDataError))
                    } else if (it.isAuthError) {
                        Flowable.error(NetError(it.errorMsg, NetError.AuthError))
                    } else if (it.isBizError) {
                        Flowable.error(NetError(it.errorMsg, NetError.BusinessError))
                    } else {
                        Flowable.just(it)
                    }
                }


            }
        }


        /**
         * 处理业务方面的错误
         *
         * @return
         */
        fun <U : NetModel> getSingleTransformer(): SingleTransformer<U,U> {

            return SingleTransformer {upstream ->
                upstream.flatMap {
                    if (it == null || it.isNull) {
                        Single.error(NetError(it.errorMsg, NetError.NoDataError))
                    } else if (it.isAuthError) {
                        Single.error(NetError(it.errorMsg, NetError.AuthError))
                    } else if (it.isBizError) {
                        Single.error(NetError(it.errorMsg, NetError.BusinessError))
                    } else {
                        Single.just(it)
                    }
                }
            }
        }

    }


}
