package cn.xuexuan.mvvm.router

import android.app.Activity

/**
 * Created by xuexuan on 2016/11/29.
 */

class SimpleRouterCallback : RouterCallback {

    override fun onBefore(from: Activity, to: Class<*>) {

    }

    override fun onNext(from: Activity, to: Class<*>) {

    }

    override fun onError(from: Activity, to: Class<*>, throwable: Throwable) {

    }
}
