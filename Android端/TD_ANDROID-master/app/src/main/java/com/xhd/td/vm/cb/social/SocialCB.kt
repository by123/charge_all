package com.xhd.td.vm.cb.social

import com.xhd.td.model.bean.TblUserUnionid


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */
interface SocialCB {

    fun handleError(throwable: Throwable)

    fun getAccessTokenFail(msg: String)
    fun getAccessTokenSuccess(result: TblUserUnionid)
    fun getUserInfoFail(msg: String)

}