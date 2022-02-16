package com.xhd.td.vm.cb

import com.xhd.td.model.bean.VersionBeam

/**
 * create by XueXuan
 * time 2019/3/25 0:39
 * description
 */
interface LoginCallback {

    fun handleError(throwable: Throwable)

    fun loginFail(msg: String){}

    fun loginSuccess(){}

    fun getVersionFail(msg: String){}

    fun getVersionSuccess(beans: List<VersionBeam>){}

    fun jumpToMain(){}


    fun getConfigSuccess(key:String,data: String?){}
    fun getConfigFail(msg:String?){}

}