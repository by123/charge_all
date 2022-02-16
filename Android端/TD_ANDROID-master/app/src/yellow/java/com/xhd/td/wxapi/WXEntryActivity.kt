package com.xhd.td.wxapi

import com.xhd.td.utils.SocialUtil
import com.xhd.td.utils.social.SocialHelper
import com.xhd.td.utils.social.WXHelperActivity


/**
 * create by xuexuan
 * time 2019/4/28 16:19
 */
class WXEntryActivity : WXHelperActivity() {

    override fun getSocialHelper(): SocialHelper {
        return  SocialUtil.instance.socialHelper()
    }
}