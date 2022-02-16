package com.xhd.td.data

import com.xhd.td.data.db.DbHelper
import com.xhd.td.data.prefs.PreferencesHelper
import com.xhd.td.data.remote.ApiHelper

/**
 * Created by amitshekhar on 07/07/17.
 */

interface DataManager : DbHelper, PreferencesHelper, ApiHelper {


    fun setUserAsLoggedOut()

    fun updateApiHeader(userId: Long?, accessToken: String)

    fun updateUserInfo(
        accessToken: String?,
        mchId: String?,
        userId: String?,
        profilePicPath: String? = ""
    )

}
