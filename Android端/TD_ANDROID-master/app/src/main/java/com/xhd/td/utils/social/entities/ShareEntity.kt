package com.xhd.td.utils.social.entities

import android.os.Bundle
import android.text.TextUtils
import java.util.*

/**
 * Created by arvinljw on 17/11/28 17:26
 * Function：
 * Desc：对于qq可自己构造参数
 */
open class ShareEntity(val type: Int) {
    var params: Bundle

    init {
        this.params = Bundle()
    }

    companion object {

        /**
         * type 值
         * qq==0
         * qzone==1
         * 微信==2
         * 朋友圈==3
         * 微博==4
         * 说说==5
         */
        val TYPE_QQ = 0
        val TYPE_Q_ZONE = 1
        val TYPE_WX = 2
        val TYPE_PYQ = 3
        val TYPE_WB = 4
        val TYPE_PUBLISH = 5

        protected fun addParams(params: Bundle?, key: String, value: String) {
            if (params == null || TextUtils.isEmpty(key) || TextUtils.isEmpty(value)) {
                return
            }
            params.putString(key, value)
        }

        protected fun addParams(params: Bundle?, key: String, value: Int) {
            if (params == null || TextUtils.isEmpty(key)) {
                return
            }
            params.putInt(key, value)
        }

        protected fun addParams(params: Bundle?, key: String, value: ArrayList<String>?) {
            if (params == null || TextUtils.isEmpty(key) || value == null || value.size == 0) {
                return
            }
            params.putStringArrayList(key, value)
        }
    }
}
