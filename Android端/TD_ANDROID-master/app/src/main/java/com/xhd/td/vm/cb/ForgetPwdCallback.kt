package com.xhd.td.vm.cb

/**
 * create by xuexuan
 * time 2019/3/25 19:54
 */

interface ForgetPwdCallback{

    fun getCodeSuccess(phone:String)
    fun getCodeFail(msg:String)

    fun verifyCodeSuccess(result:String)
    fun verifyCodeFail(msg:String)

    fun modifyPwdSuccess()
    fun modifyPwdFail(msg:String)

}