package cn.xuexuan.mvvm

import cn.xuexuan.mvvm.router.Router

/**
 * Created by xuexuan on 2016/12/4.
 */

object AppConstants {


    val DB_NAME = "xhb.db"
    //prederences 之所以用这个是为了和旧版本的数据保持统一，避免升级后，没有默认密码
    val PREF_NAME = "login_file_name"

    // #log
    val LOG = BuildConfig.ENABLE_DEBUG
    val LOG_TAG = "XDroid"

    // #cache
    val CACHE_SP_NAME = "config"
    val CACHE_DISK_DIR = "cache"

//     #router
    val ROUTER_ANIM_ENTER = Router.RES_NONE
    val ROUTER_ANIM_EXIT = Router.RES_NONE

    // #imageloader
    //    public static final int IL_LOADING_RES = ILoader.Options.RES_NONE;
    //    public static final int IL_ERROR_RES = ILoader.Options.RES_NONE;

    // #dev model
    val DEV = true
    val TIMESTAMP_FORMAT = "yyyyMMdd_HHmmss"

}
