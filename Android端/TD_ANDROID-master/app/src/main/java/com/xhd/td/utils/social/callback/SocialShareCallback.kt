package com.xhd.td.utils.social.callback

/**
 * Created by arvinljw on 17/11/24 16:07
 * Function：
 * Desc：
 */
interface SocialShareCallback : SocialCallback {
    /**
     * @param type 取值有0或1，2，3,4分别对应下边的qq，微信好友，朋友圈和微博
     *
     *
     * qq==0||qq==1，因为在分享到qq好友时也能选择分享到qq空间，而又没有回调参数去判断
     * 微信==2
     * 朋友圈==3
     * 微博==4
     */
    fun shareSuccess(type: Int)
}
