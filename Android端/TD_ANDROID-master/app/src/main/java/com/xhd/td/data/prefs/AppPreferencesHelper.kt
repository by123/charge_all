package com.xhd.td.data.prefs

import android.content.Context
import android.content.SharedPreferences
import com.xhd.td.di.PreferenceInfo

import javax.inject.Inject

/**
 * Created by amitshekhar on 07/07/17.
 */

class AppPreferencesHelper @Inject
constructor(context: Context, @PreferenceInfo prefFileName: String) : PreferencesHelper {

    private val mPrefs: SharedPreferences

    init {
        mPrefs = context.getSharedPreferences(prefFileName, Context.MODE_PRIVATE)
    }


    override var accessToken: String?
        set(value) {
            mPrefs.edit().putString(PREF_KEY_ACCESS_TOKEN, value).apply()
        }
        get() {
            return mPrefs.getString(PREF_KEY_ACCESS_TOKEN, null)
        }

    override var currentAccount: String?
        set(value) {
            mPrefs.edit().putString(PREF_KEY_CURRENT_ACCOUNT, value).apply()
        }
        get() {
            return mPrefs.getString(PREF_KEY_CURRENT_ACCOUNT, null)
        }
    override var currentPassword: String?
        set(value) {
            mPrefs.edit().putString(PREF_KEY_CURRENT_PASSWORD, value).apply()
        }
        get() {
            return mPrefs.getString(PREF_KEY_CURRENT_PASSWORD, null)
        }


    override var mchId: String?
        get()  {
            return mPrefs.getString(PREF_KEY_MCH_ID, null)
        }
        set(value) {
            mPrefs.edit().putString(PREF_KEY_MCH_ID, value).apply()
        }


    override var userId: String?
        get()  {
            return mPrefs.getString(PREF_KEY_USER_ID, null)
        }
        set(value) {
            mPrefs.edit().putString(PREF_KEY_USER_ID, value).apply()
        }


    override var currentUserProfilePicUrl: String?
        set(value) {
            mPrefs.edit().putString(PREF_KEY_CURRENT_USER_PROFILE_PIC_URL, value).apply()
        }
        get() {
            return mPrefs.getString(PREF_KEY_CURRENT_USER_PROFILE_PIC_URL, null)
        }

    override var newMessageTag: Boolean?
        get() {
            return mPrefs.getBoolean(NEW_MESSAGE, false)
        }
        set(value) {
            mPrefs.edit().putBoolean(NEW_MESSAGE, value?:false).apply()
        }


    companion object {

        private val PREF_KEY_ACCESS_TOKEN = "PREF_KEY_ACCESS_TOKEN"

        private val PREF_KEY_CURRENT_ACCOUNT = "login_name"

        private val PREF_KEY_CURRENT_PASSWORD = "login_pw"


        private val PREF_KEY_MCH_ID = "merchant_id"

        private val PREF_KEY_USER_ID = "user_id"

        private val PREF_KEY_CURRENT_USER_PROFILE_PIC_URL = "PREF_KEY_CURRENT_USER_PROFILE_PIC_URL"


        const val LOGIN_FILE_NAME = "login_file_name"


        private const val NEW_MESSAGE = "new_message"

    }
}
