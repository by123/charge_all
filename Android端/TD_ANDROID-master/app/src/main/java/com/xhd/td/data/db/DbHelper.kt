

package com.xhd.td.data.db


import com.xhd.td.model.bean.MchBean
import com.xhd.td.model.bean.UserBean
import io.reactivex.Flowable

/**
 * Created by amitshekhar on 07/07/17.
 */

interface DbHelper {

    fun insertUser(user: UserBean): Boolean
    fun insertMerchant(mchBean: MchBean): Boolean

    fun findUserBeanByUserId(userId:String): Flowable<UserBean>
    fun findMchBeanByMchId(mchId:String):Flowable<MchBean>

}
