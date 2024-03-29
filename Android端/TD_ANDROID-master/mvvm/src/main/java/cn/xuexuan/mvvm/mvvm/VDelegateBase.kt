package cn.xuexuan.mvvm.mvvm

import android.content.Context
import android.view.View
import android.widget.Toast

/**
 * Created by xuexuan on 2016/12/29.
 */

class VDelegateBase private constructor(private val context: Context) : VDelegate {


    override fun resume() {

    }

    override fun pause() {

    }

    override fun destory() {

    }

    override fun visible(flag: Boolean, view: View) {
        if (flag) view.visibility = View.VISIBLE
    }

    override fun gone(flag: Boolean, view: View) {
        if (flag) view.visibility = View.GONE
    }

    override fun inVisible(view: View) {
        view.visibility = View.INVISIBLE
    }

    override fun toastShort(msg: String) {
        Toast.makeText(context, msg, Toast.LENGTH_SHORT).show()
    }

    override fun toastLong(msg: String) {
        Toast.makeText(context, msg, Toast.LENGTH_LONG).show()
    }

    companion object {

        fun create(context: Context): VDelegate {
            return VDelegateBase(context)
        }
    }
}
