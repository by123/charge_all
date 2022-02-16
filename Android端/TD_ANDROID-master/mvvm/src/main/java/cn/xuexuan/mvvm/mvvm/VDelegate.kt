package cn.xuexuan.mvvm.mvvm

import android.view.View

/**
 * Created by xuexuan on 2016/12/29.
 */

interface VDelegate {
    fun resume()

    fun pause()

    fun destory()

    fun visible(flag: Boolean, view: View)
    fun gone(flag: Boolean, view: View)
    fun inVisible(view: View)

    fun toastShort(msg: String)
    fun toastLong(msg: String)
}
