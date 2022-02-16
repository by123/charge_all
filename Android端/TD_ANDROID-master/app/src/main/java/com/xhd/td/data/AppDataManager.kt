package com.xhd.td.data

import android.content.Context
import com.google.gson.Gson
import com.xhd.td.data.db.DbHelper
import com.xhd.td.data.prefs.PreferencesHelper
import com.xhd.td.data.remote.ApiHeader
import com.xhd.td.data.remote.ApiHelper
import com.xhd.td.model.bean.MchBean
import com.xhd.td.model.bean.UserBean
import com.xhd.td.net.HttpService
import io.reactivex.Flowable
import javax.inject.Inject
import javax.inject.Singleton

/**
 * Created by amitshekhar on 07/07/17.
 */
@Singleton
class AppDataManager @Inject
constructor(
    private val mContext: Context,
    private val mDbHelper: DbHelper,
    private val mPreferencesHelper: PreferencesHelper,
    private val mApiHelper: ApiHelper,
    private val mGson: Gson

) : DataManager {

    override val httpService: HttpService
        get() = mApiHelper.httpService


    override var accessToken: String?
        get() = mPreferencesHelper.accessToken
        set(accessToken) {
            mPreferencesHelper.accessToken = accessToken
            mApiHelper.apiHeader.protectedApiHeader.accessToken = accessToken
        }

    override var newMessageTag: Boolean?
        get() = mPreferencesHelper.newMessageTag
        set(value) {
            mPreferencesHelper.newMessageTag = value
        }

    override val apiHeader: ApiHeader
        get() = mApiHelper.apiHeader


    override var currentAccount: String?
        get() = mPreferencesHelper.currentAccount
        set(account) {
            mPreferencesHelper.currentAccount = account
        }


    override var currentPassword: String?
        get() = mPreferencesHelper.currentPassword
        set(value) {
            mPreferencesHelper.currentPassword = value
        }



    override var mchId: String?
        get() = mPreferencesHelper.mchId
        set(value) {
            mPreferencesHelper.mchId = value
        }


    override var userId: String?
        get() = mPreferencesHelper.userId
        set(value) {
            mPreferencesHelper.userId = value

        }


    override var currentUserProfilePicUrl: String?
        get() = mPreferencesHelper.currentUserProfilePicUrl
        set(profilePicUrl) {
            mPreferencesHelper.currentUserProfilePicUrl = profilePicUrl
        }

    override fun insertUser(user: UserBean): Boolean {
        return mDbHelper.insertUser(user)
    }


    override fun insertMerchant(mchBean: MchBean): Boolean {
        return mDbHelper.insertMerchant(mchBean)
    }


    override fun findUserBeanByUserId(userId: String): Flowable<UserBean> {
        return mDbHelper.findUserBeanByUserId(userId)
    }

    override fun findMchBeanByMchId(mchId: String): Flowable<MchBean> {
        return mDbHelper.findMchBeanByMchId(mchId)
    }


    override fun setUserAsLoggedOut() {
        updateUserInfo(null, null, null, null)

    }

    override fun updateApiHeader(userId: Long?, accessToken: String) {
        mApiHelper.apiHeader.protectedApiHeader.accessToken = accessToken
    }

    override fun updateUserInfo(accessToken: String?, mchId: String?, userId: String?, profilePicPath: String?) {

        this.accessToken = accessToken
        this.mchId = mchId
        this.userId = userId
        currentUserProfilePicUrl = profilePicPath

//        updateApiHeader(userId, accessToken)
    }

}
