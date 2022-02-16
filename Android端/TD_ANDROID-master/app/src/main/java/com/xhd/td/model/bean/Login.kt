package com.xhd.td.model.bean

/**
 * create by xuexuan
 * time 2019/3/18 20:09
 */

data class LoginBean(val userName: String,val password: String)

data class LoginResultBean(val user: UserBean, val tblMch: MchBean, val token: String)




data class VerifyCodeBean(val smsCode: String, val userName: String)

data class ChangePwdBean(val confirmPassword: String, val password: String, val token: String, val userName: String)