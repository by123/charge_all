package com.xhd.td.utils.social

import android.content.Context
import android.content.Intent
import android.text.TextUtils
import androidx.localbroadcastmanager.content.LocalBroadcastManager
import com.xhd.td.utils.social.callback.SocialLoginCallback
import com.xhd.td.utils.social.callback.SocialNetCallback
import com.xhd.td.utils.social.callback.SocialShareCallback
import com.xhd.td.utils.social.entities.ShareEntity


/**
 * Created by arvinljw on 17/11/24 15:14
 * Function：
 * Desc：
 */
class SocialHelper private constructor(val builder: Builder) {
    private var wxHelper: WXHelper? = null


    fun loginWX(context: Context, callback: SocialLoginCallback,netCallback: SocialNetCallback) {
        clear()
        wxHelper = WXHelper(context, builder.getWxAppId()!!,netCallback)
        wxHelper!!.isNeedLoginResult = builder.isNeedLoinResult()
        wxHelper!!.login(callback)
    }


    fun shareWX(context: Context, shareInfo: ShareEntity, callback: SocialShareCallback,netCallback: SocialNetCallback) {
        clear()
        wxHelper = WXHelper(context, builder.getWxAppId()!!,netCallback)
        wxHelper!!.share(callback, shareInfo)
    }


    /**
     * 微信登录，在微信回调到WXEntryContext的onResp方法中调用
     *
     * @param code 空表示失败，正常就是有值的
     */
    fun sendAuthBackBroadcast(context: Context, code: String?) {
        var code = code
        val intent = Intent(WX_AUTH_RECEIVER_ACTION)
        if (TextUtils.isEmpty(code)) {
            code = KEY_WX_AUTH_CANCEL_CODE
        }
        intent.putExtra(KEY_WX_AUTH_CODE, code)
        LocalBroadcastManager.getInstance(context).sendBroadcast(intent)
    }

    /**
     * 微信分享，在微信回调到WXEntryContext的onResp方法中调用
     *
     * @param success 表示是否分享成功
     */
    fun sendShareBackBroadcast(context: Context, success: Boolean) {
        val intent = Intent(WX_SHARE_RECEIVER_ACTION)
        intent.putExtra(KEY_WX_SHARE_CALL_BACK, success)
        LocalBroadcastManager.getInstance(context).sendBroadcast(intent)
    }

    fun clear() {
        if (wxHelper != null) {
            wxHelper!!.onDestroy()
            wxHelper = null
        }
    }

    class Builder {


        private var wxAppId: String? = null
        private var wxAppSecret: String? = null

        private var needLoinResult: Boolean = false


        fun getWxAppId(): String? {
            return wxAppId
        }

        fun setWxAppId(wxAppId: String): Builder {
            this.wxAppId = wxAppId
            return this
        }

        fun getWxAppSecret(): String? {
            return wxAppSecret
        }

        fun setWxAppSecret(wxAppSecret: String): Builder {
            this.wxAppSecret = wxAppSecret
            return this
        }


        fun setNeedLoinResult(needLoinResult: Boolean): Builder {
            this.needLoinResult = needLoinResult
            return this
        }

        fun isNeedLoinResult(): Boolean {
            return needLoinResult
        }

        fun build(): SocialHelper {
            return SocialHelper(this)
        }
    }

    companion object {
        internal val WX_AUTH_RECEIVER_ACTION = "wx_auth_receiver_action"
        internal val KEY_WX_AUTH_CODE = "key_wx_auth_code"
        internal val KEY_WX_AUTH_CANCEL_CODE = "key_wx_auth_cancel_code"

        internal val WX_SHARE_RECEIVER_ACTION = "wx_auth_receiver_action"
        internal val KEY_WX_SHARE_CALL_BACK = "key_wx_share_call_back"
    }
}
