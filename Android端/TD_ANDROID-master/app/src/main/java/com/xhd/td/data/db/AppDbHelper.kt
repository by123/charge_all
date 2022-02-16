package com.xhd.td.data.db


import com.xhd.td.model.bean.MchBean
import com.xhd.td.model.bean.UserBean
import io.reactivex.Flowable
import javax.inject.Inject
import javax.inject.Singleton

/**
 * Created by amitshekhar on 07/07/17.
 */

@Singleton
class AppDbHelper @Inject
constructor(private val mRoomDB: AppDatabase) : DbHelper {

    override fun insertUser(user: UserBean): Boolean {
        mRoomDB.userDao().insert(user)

        return true
//        return Observable.fromCallable {
//        }
    }

    override fun insertMerchant(mchBean: MchBean): Boolean {
        mRoomDB.merchantDao().insert(mchBean)
        return true
//        return Observable.fromCallable {
//        }
    }

    override fun findUserBeanByUserId(userId: String): Flowable<UserBean> {

        return Flowable.fromCallable<UserBean> { mRoomDB.userDao().findByUserId(userId) }

    }

    override fun findMchBeanByMchId(mchId: String): Flowable<MchBean> {
        return Flowable.fromCallable<MchBean> { mRoomDB.merchantDao().findByMchId(mchId)}

    }
}
