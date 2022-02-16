package cn.xuexuan.mvvm.net

import com.elvishew.xlog.XLog
import com.google.gson.JsonParseException
import com.google.gson.JsonSyntaxException
import io.reactivex.observers.DisposableSingleObserver
import org.json.JSONException
import java.io.EOFException
import java.io.FileNotFoundException
import java.net.ConnectException
import java.net.SocketTimeoutException
import java.net.UnknownHostException


/**
 * Created by xuexuan on 2016/12/26.
 * 处理异常性错误，网络连接超时、未知主机地址、json转换异常等等
 */

abstract class ApiSubscriber<T> : DisposableSingleObserver<T>() {


    override fun onError(e: Throwable) {
        var error: NetError = NetError(e, NetError.OtherError)
        when (e) {
            is UnknownHostException -> {
                //未知的主机地址
                error = NetError(e, NetError.UnknownHostError)
            }

            is SocketTimeoutException -> {
                //连接超时错误
                error = NetError(e, NetError.SocketTimeoutError)
            }

            is ConnectException -> {
                //没有网络
                error = NetError(e, NetError.ConnectErroe)
            }
            is JSONException,
            is JsonParseException,
            is JsonSyntaxException -> {
                //数据解析异常
                error = NetError(e, NetError.ParseError)
            }
        }
        if (useCommonErrorHandler()) {
            if (XNet.commonProvider.handleError(error)) {//使用通用异常处理
                return
            }
        }
        onFail(error)
    }

    protected abstract fun onFail(error: NetError?)


    override fun onSuccess(t: T) {
        try {
            success(t)
        } catch (e: Exception) {
            var error: NetError = NetError(e, NetError.BusinessError)

            when (e) {
                is IndexOutOfBoundsException -> {
                    //数据超界
                    error = NetError(e, NetError.IndexOutOfBoundsException)
                }

                is NullPointerException -> {
                    //空指针
                    error = NetError(e, NetError.NullPointerException)
                }

                is ArithmeticException -> {
                    //算术运算错误
                    error = NetError(e, NetError.ArithmeticException)
                }

                is IllegalAccessException -> {
                    //没有访问权限
                    error = NetError(e, NetError.IllegalAccessException)
                }
                is StackOverflowError -> {
                    //栈溢出
                    error = NetError(e, NetError.StackOverflowError)
                }

                is EOFException -> {
                    //文件已结束异常
                    error = NetError(e, NetError.EOFException )
                }
                is FileNotFoundException -> {
                    //文件未找到异常
                    error = NetError(e, NetError.FileNotFoundException)
                }
                is NumberFormatException -> {
                    //数字转换错误
                    error = NetError(e, NetError.NumberFormatException)
                }
            }

            XLog.e(t)
            if (useCommonErrorHandler()) {
                if (XNet.commonProvider.handleError(error)) {//使用通用异常处理
                    return
                }
            }

        }
    }

    protected abstract fun success(t: T)


    protected fun useCommonErrorHandler(): Boolean {
        return true
    }

}
