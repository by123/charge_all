package cn.xuexuan.mvvm.utils

import android.content.Context
import android.widget.Toast

/**
 * Created by Administrator on 2017/1/5.
 * Toast显示 工具类
 */

object ToastUtil {

    var isShow = true

    /**
     * 短时间显示Toast
     *
     * @param context
     * @param message
     */
    fun showShort(context: Context, message: CharSequence) {
        if (isShow)
            Toast.makeText(context, message, Toast.LENGTH_SHORT).show()
    }

    /**
     * 短时间显示Toast
     *
     * @param context
     * @param message
     */
    fun showShort(context: Context, message: Int) {
        if (isShow)
            Toast.makeText(context, message, Toast.LENGTH_SHORT).show()
    }

    /**
     * 长时间显示Toast
     *
     * @param context
     * @param message
     */
    fun showLong(context: Context, message: CharSequence) {
        if (isShow)
            Toast.makeText(context, message, Toast.LENGTH_LONG).show()
    }

    /**
     * 长时间显示Toast
     *
     * @param context
     * @param message
     */
    fun showLong(context: Context, message: Int) {
        if (isShow)
            Toast.makeText(context, message, Toast.LENGTH_LONG).show()
    }

    /**
     * 自定义显示Toast时间
     *
     * @param context
     * @param message
     * @param duration
     */
    fun show(context: Context, message: Int, duration: Int) {
        if (isShow)
            Toast.makeText(context, message, duration).show()
    }
}
