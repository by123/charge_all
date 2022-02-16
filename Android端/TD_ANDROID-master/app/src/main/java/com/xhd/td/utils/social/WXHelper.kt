package com.xhd.td.utils.social

import android.annotation.SuppressLint
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.os.Bundle
import android.os.Handler
import android.os.Message
import android.text.TextUtils
import androidx.localbroadcastmanager.content.LocalBroadcastManager
import com.google.gson.Gson
import com.tencent.mm.opensdk.modelmsg.*
import com.tencent.mm.opensdk.openapi.IWXAPI
import com.tencent.mm.opensdk.openapi.WXAPIFactory
import com.xhd.td.R
import com.xhd.td.utils.social.callback.SocialCallback
import com.xhd.td.utils.social.callback.SocialLoginCallback
import com.xhd.td.utils.social.callback.SocialNetCallback
import com.xhd.td.utils.social.callback.SocialShareCallback
import com.xhd.td.utils.social.entities.*
import java.io.File

/**
 * Created by arvinljw on 17/11/27 13:33
 * Function：
 * Desc：
 */
internal class WXHelper(
    private var context: Context?,
    private val appId: String,
    private var netCallback: SocialNetCallback?
) : ISocial, INeedLoginResult {

    private val api: IWXAPI

    private var loginCallback: SocialLoginCallback? = null
    private var wxAuthReceiver: BroadcastReceiver? = null
    private var wxInfo: WXInfoEntity? = null
    private var needLoginResult: Boolean = false

    private var shareCallback: SocialShareCallback? = null
    private var wxShareReceiver: BroadcastReceiver? = null


    @SuppressLint("HandlerLeak")
    private val handler = object : Handler() {
        override fun handleMessage(msg: Message) {
            if (context == null || loginCallback == null) {
                return
            }
            when (msg.what) {
                GET_INFO_SUCCESS -> if (wxInfo != null) {
                    loginCallback!!.loginSuccess(createThirdInfo())
                } else {
                    loginCallback!!.socialError(context!!.getString(R.string.social_cancel))
                }
                GET_INFO_ERROR -> loginCallback!!.socialError(context!!.getString(R.string.social_cancel))
            }
        }
    }

    init {

        api = WXAPIFactory.createWXAPI(context, appId, true)
        api.registerApp(appId)
    }

    /**
     * 1、发起授权，会在{ packageName.WXEntryActivity#onResp(BaseResp)}返回成功与否,
     * 成功则通过广播发送回调[.wxAuthReceiver]的onReceive方法
     */
    override fun login(callback: SocialLoginCallback) {
        this.loginCallback = callback
        if (baseVerify(callback)) {
            return
        }
        initLoginReceiver()
        val req = SendAuth.Req()
        req.scope = "snsapi_userinfo"
        req.state = SocialUtil.getAppStateName(context!!) + "_app"
        api.sendReq(req)
    }

    /**
     * 2、授权回调成功
     */
    private fun initLoginReceiver() {
        if (wxAuthReceiver == null) {
            wxAuthReceiver = object : BroadcastReceiver() {
                override fun onReceive(context: Context?, intent: Intent) {
                    val code = intent.getStringExtra(SocialHelper.KEY_WX_AUTH_CODE)
                    if (code == SocialHelper.KEY_WX_AUTH_CANCEL_CODE || code == null) {
                        if (loginCallback != null && context != null) {
                            loginCallback!!.socialError(context.getString(R.string.social_cancel))
                        }
                        return
                    }
                    getAccessToken(code)
                }
            }
            LocalBroadcastManager.getInstance(context!!)
                .registerReceiver(wxAuthReceiver!!, IntentFilter(SocialHelper.WX_AUTH_RECEIVER_ACTION))
        }
    }

    /**
     * 3、通过code获取accessToken
     *
     * @param code 用户换取access_token的code，仅在ErrCode为0时有效
     */
    private fun getAccessToken(code: String) {
        Thread(Runnable {
            try {

                //从服务器获取accessToken
                netCallback?.getAccessToken(code)
//                val wxLoginResult = Gson().fromJson(netCallback?.getAccessToken(code), WXLoginResultEntity::class.java)
//                getUserInfo(wxLoginResult)
            } catch (e: Exception) {
                e.printStackTrace()
                handler.sendEmptyMessage(GET_INFO_ERROR)
            }
        }).start()
    }

    /**
     * 4、获取个人信息
     */

    private fun getUserInfo(wxLoginResult: WXLoginResultEntity?) {
        if (context == null || wxLoginResult == null) {
            handler.sendEmptyMessage(GET_INFO_ERROR)
            return
        }
        val url =
            "https://api.weixin.qq.com/sns/userinfo?access_token=" + wxLoginResult.access_token +
                    "&openid=" + wxLoginResult.openid + ""

        wxInfo = Gson().fromJson(netCallback?.getUerInfo(url), WXInfoEntity::class.java)
        if (isNeedLoginResult) {
            wxInfo!!.loginResultEntity = wxLoginResult
        }
        handler.sendEmptyMessage(GET_INFO_SUCCESS)
    }

    override fun createThirdInfo(): ThirdInfoEntity {
        return ThirdInfoEntity.createWxThirdInfo(
            wxInfo!!.unionid, wxInfo!!.openid, wxInfo!!.nickname,
            SocialUtil.getWXSex(wxInfo!!.sex.toString()), wxInfo!!.headimgurl, wxInfo
        )
    }

    override fun share(callback: SocialShareCallback, shareInfo: ShareEntity) {
        this.shareCallback = callback
        if (baseVerify(callback)) {
            return
        }
        //是否分享到朋友圈，微信4.2以下不支持朋友圈
        val isTimeLine = shareInfo.type == ShareEntity.TYPE_PYQ
        if (isTimeLine && api.wxAppSupportAPI < 0x21020001) {
            if (shareCallback != null) {
                shareCallback!!.socialError(context!!.getString(R.string.social_wx_version_low_error))
            }
            return
        }

        initShareReceiver(shareInfo)

        val req = SendMessageToWX.Req()
        req.message = createMessage(req, shareInfo.params)
        if (req.message == null) {
            return
        }
        req.scene = if (isTimeLine) SendMessageToWX.Req.WXSceneTimeline else SendMessageToWX.Req.WXSceneSession
        api.sendReq(req)
    }

    /**
     * 分享回调
     */
    private fun initShareReceiver(shareInfo: ShareEntity) {
        if (wxShareReceiver == null) {
            wxShareReceiver = object : BroadcastReceiver() {
                override fun onReceive(context: Context, intent: Intent) {
                    val shareSuccess = intent.getBooleanExtra(SocialHelper.KEY_WX_SHARE_CALL_BACK, false)
                    if (shareCallback != null) {
                        if (shareSuccess) {
                            shareCallback!!.shareSuccess(shareInfo.type)
                        } else {
                            shareCallback!!.socialError(context.getString(R.string.social_cancel))
                        }
                    }
                }
            }
            LocalBroadcastManager.getInstance(context!!)
                .registerReceiver(wxShareReceiver!!, IntentFilter(SocialHelper.WX_SHARE_RECEIVER_ACTION))
            //            context.registerReceiver(wxShareReceiver, new IntentFilter(SocialHelper.WX_SHARE_RECEIVER_ACTION));
        }
    }

    private fun createMessage(req: SendMessageToWX.Req, params: Bundle): WXMediaMessage? {
        val msg = WXMediaMessage()
        val type = params.getInt(WXShareEntity.KEY_WX_TYPE)
        var success = false
        when (type) {
            WXShareEntity.TYPE_TEXT -> success = addText(req, msg, params)
            WXShareEntity.TYPE_IMG -> success = addImage(req, msg, params)
            WXShareEntity.TYPE_MUSIC -> success = addMusic(req, msg, params)
            WXShareEntity.TYPE_VIDEO -> success = addVideo(req, msg, params)
            WXShareEntity.TYPE_WEB -> success = addWeb(req, msg, params)
        }
        return if (!success) {
            null
        } else msg
    }

    private fun addText(req: SendMessageToWX.Req, msg: WXMediaMessage, params: Bundle): Boolean {
        val textObj = WXTextObject()
        textObj.text = params.getString(WXShareEntity.KEY_WX_TEXT)

        msg.mediaObject = textObj
        msg.description = textObj.text

        req.transaction = SocialUtil.buildTransaction("text")
        return true
    }

    private fun addImage(req: SendMessageToWX.Req, msg: WXMediaMessage, params: Bundle): Boolean {
        val imgObj: WXImageObject
        val bitmap: Bitmap
        if (params.containsKey(WXShareEntity.KEY_WX_IMG_LOCAL)) {//分为本地文件和应用内资源图片
            val imgUrl = params.getString(WXShareEntity.KEY_WX_IMG_LOCAL)
            if (notFoundFile(imgUrl)) {
                return false
            }

            imgObj = WXImageObject()
            imgObj.imagePath = imgUrl
            bitmap = BitmapFactory.decodeFile(imgUrl)
        } else {
            bitmap = BitmapFactory.decodeResource(context!!.resources, params.getInt(WXShareEntity.KEY_WX_IMG_RES))
            imgObj = WXImageObject(bitmap)
        }
        msg.mediaObject = imgObj
        msg.thumbData = SocialUtil.bmpToByteArray(bitmap, true)

        req.transaction = SocialUtil.buildTransaction("img")
        return true
    }

    private fun addMusic(req: SendMessageToWX.Req, msg: WXMediaMessage, params: Bundle): Boolean {
        val musicObject = WXMusicObject()
        musicObject.musicUrl = params.getString(WXShareEntity.KEY_WX_MUSIC_URL)

        msg.mediaObject = musicObject
        if (addTitleSummaryAndThumb(msg, params)) return false

        req.transaction = SocialUtil.buildTransaction("music")
        return true
    }

    private fun addVideo(req: SendMessageToWX.Req, msg: WXMediaMessage, params: Bundle): Boolean {
        val musicObject = WXVideoObject()
        musicObject.videoUrl = params.getString(WXShareEntity.KEY_WX_VIDEO_URL)

        msg.mediaObject = musicObject
        if (addTitleSummaryAndThumb(msg, params)) return false

        req.transaction = SocialUtil.buildTransaction("video")
        return true
    }

    private fun addWeb(req: SendMessageToWX.Req, msg: WXMediaMessage, params: Bundle): Boolean {
        val musicObject = WXWebpageObject()
        musicObject.webpageUrl = params.getString(WXShareEntity.KEY_WX_WEB_URL)

        msg.mediaObject = musicObject
        if (addTitleSummaryAndThumb(msg, params)) return false

        req.transaction = SocialUtil.buildTransaction("webpage")
        return true
    }

    private fun addTitleSummaryAndThumb(msg: WXMediaMessage, params: Bundle): Boolean {
        if (params.containsKey(WXShareEntity.KEY_WX_TITLE)) {
            msg.title = params.getString(WXShareEntity.KEY_WX_TITLE)
        }

        if (params.containsKey(WXShareEntity.KEY_WX_SUMMARY)) {
            msg.description = params.getString(WXShareEntity.KEY_WX_SUMMARY)
        }

        if (params.containsKey(WXShareEntity.KEY_WX_IMG_LOCAL) || params.containsKey(WXShareEntity.KEY_WX_IMG_RES)) {
            val bitmap: Bitmap
            if (params.containsKey(WXShareEntity.KEY_WX_IMG_LOCAL)) {//分为本地文件和应用内资源图片
                val imgUrl = params.getString(WXShareEntity.KEY_WX_IMG_LOCAL)
                if (notFoundFile(imgUrl)) {
                    return true
                }
                bitmap = BitmapFactory.decodeFile(imgUrl)
            } else {
                bitmap = BitmapFactory.decodeResource(context!!.resources, params.getInt(WXShareEntity.KEY_WX_IMG_RES))
            }
            msg.thumbData = SocialUtil.bmpToByteArray(bitmap, true)
        }
        return false
    }

    /*基本信息验证*/
    private fun baseVerify(callback: SocialCallback?): Boolean {
        if (TextUtils.isEmpty(appId)) {
            callback?.socialError(context!!.getString(R.string.social_error_appid_empty))
            return true
        }
        if (!api.isWXAppInstalled) {
            callback?.socialError(context!!.getString(R.string.social_wx_uninstall))
            return true
        }
        return false
    }

    private fun notFoundFile(filePath: String?): Boolean {
        if (!TextUtils.isEmpty(filePath)) {
            val file = File(filePath)
            if (!file.exists()) {
                if (shareCallback != null) {
                    shareCallback!!.socialError(context!!.getString(R.string.social_img_not_found))
                }
                return true
            }
        } else {
            if (shareCallback != null) {
                shareCallback!!.socialError(context!!.getString(R.string.social_img_not_found))
            }
            return true
        }
        return false
    }

    override fun onDestroy() {
        if (context != null) {
            if (wxAuthReceiver != null) {
                LocalBroadcastManager.getInstance(context!!).unregisterReceiver(wxAuthReceiver!!)
            }
            if (wxShareReceiver != null) {
                LocalBroadcastManager.getInstance(context!!).unregisterReceiver(wxShareReceiver!!)
            }
            context = null
        }
    }

    override fun setNeedLoginResult(needLoginResult: Boolean) {
        this.needLoginResult = needLoginResult
    }

    override fun isNeedLoginResult(): Boolean {
        return needLoginResult
    }

    companion object {
        private val GET_INFO_ERROR = 10000
        private val GET_INFO_SUCCESS = 10001
    }
}
