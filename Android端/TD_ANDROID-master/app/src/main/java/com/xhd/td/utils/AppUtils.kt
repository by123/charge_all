package com.xhd.td.utils

import android.app.ActivityManager
import android.content.Context
import android.content.pm.PackageManager
import android.net.ConnectivityManager
import com.tencent.bugly.crashreport.BuglyLog
import java.security.MessageDigest
import java.security.NoSuchAlgorithmException
import java.text.SimpleDateFormat
import java.util.*
import java.util.regex.Pattern
import kotlin.collections.ArrayList


/**
 * Created by Administrator on 2017/2/6.
 */

object AppUtils {

    private val TAG = AppUtils::class.java.simpleName

    /**
     * 获取app版本号
     */
    fun getVersionName(mContext: Context): String {
        var versionName = ""
        try {
            versionName = mContext.packageManager.getPackageInfo(mContext.packageName, 0).versionName
        } catch (e: PackageManager.NameNotFoundException) {
            e.printStackTrace()
        }

        return versionName
    }

    /**
     * 获取app版本号
     */
    fun getVersionCode(mContext: Context): Int {
        var versionName = 0
        try {
            versionName = mContext.packageManager.getPackageInfo(mContext.packageName, 0).versionCode
        } catch (e: PackageManager.NameNotFoundException) {
            e.printStackTrace()
        }

        return versionName
    }


    /**
     * 判断email格式是否正确
     * @param email 邮箱地址
     * @return
     */
    fun isEmail(email: String): Boolean {
        val str =
            "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$"
        val p = Pattern.compile(str)
        val m = p.matcher(email)
        return m.matches()
    }

    /**
     * 判断手机号码格式是否正确
     * @param phoneNum 手机号码
     * @return
     */
    fun isPhoneNum(phoneNum: String): Boolean {
        val str = "^1(3[0-9]|4[57]|5[0-35-9]|7[0135678]|8[0-9])\\\\d{8}$"
        val p = Pattern.compile(str)
        val m = p.matcher(phoneNum)
        return m.matches()
    }

    /**
     * 判断书否是纯数字
     * @param number
     * @return
     */
    fun isNumber(number: String): Boolean {
        val pattern = Pattern.compile("^[-\\+]?[\\d]*$")
        return pattern.matcher(number).matches()
    }

    /**
     * 判断网络是否正常连接
     * @param context
     * @return
     */
    fun isConnected(context: Context): Boolean {
        val conn = context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        val info = conn.activeNetworkInfo
        return info != null && info.isConnected
    }

    /**
     * 获得可用的内存
     * @param mContext
     * @return
     */
    fun getInternal(mContext: Context): Long {
        val internal: Long
        val am = mContext.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager

        val mi = ActivityManager.MemoryInfo()
        am.getMemoryInfo(mi)

        // 取得剩余的内存空间

        internal = mi.availMem / 1024
        return internal
    }

    fun getSHA1(context: Context): String? {
        try {
            val info = context.packageManager.getPackageInfo(
                context.packageName, PackageManager.GET_SIGNATURES
            )
            val cert = info.signatures[0].toByteArray()
            val md = MessageDigest.getInstance("SHA1")
            val publicKey = md.digest(cert)
            val hexString = StringBuffer()
            for (i in publicKey.indices) {
                val appendString = Integer.toHexString(0xFF and publicKey[i].toInt())
                    .toUpperCase(Locale.US)
                if (appendString.length == 1) {
                    hexString.append("0")
                }
                hexString.append(appendString)
                hexString.append(":")
            }
            val result = hexString.toString()
            return result.substring(0, result.length - 1)
        } catch (e: PackageManager.NameNotFoundException) {
            e.printStackTrace()
        } catch (e: NoSuchAlgorithmException) {
            e.printStackTrace()
        }

        return null
    }




    /**
     * 判断当前语言
     *
     * @param context
     * @return 1中文 2英语 3德语 4西班牙语 5法语 6日语 7俄语
     */
    fun getLanguage(context: Context): String {
        val locale = context.resources.configuration.locale
        val language = locale.language
        //        if (locale.equals(new Locale("zh"))) {
        //            //中文
        //            return "zh_CN";
        //        } else if (locale.equals(new Locale("en"))) {
        //            //英语
        //            return "en_US";
        //        } else if (locale.equals(new Locale("de"))) {
        //            //德语
        //            return "de_DE";
        //        } else if (locale.equals(new Locale("es"))) {
        //
        //            //西班牙语
        //            return "es_ES";
        //        } else if (locale.equals(new Locale("fr"))) {
        //
        //            //法语
        //            return "fr_FR";
        //        } else if (locale.equals(new Locale("ja"))) {
        //            //日语
        //            return "ja_JP";
        //        } else if (locale.equals(new Locale("ru"))) {
        //
        //            //俄语
        //            return "ru_RU";
        //        } else if (locale.equals(new Locale("pt"))) {
        //            //葡萄牙语
        //            return "pt_PT";
        //        } else if (locale.equals(new Locale("ko"))) {
        //
        //            //韩语
        //            return "ko_KR";
        //        } else {
        //            //默认英语
        //            return "en_US";
        //        }

        return if (language.contains("zh")) {
            //中文
            "zh_CN"
        } else if (language.contains("en")) {
            //英语
            "en_US"
        } else if (language.contains("de")) {
            //德语
            "de_DE"
        } else if (language.contains("es")) {
            //西班牙语
            "es_ES"
        } else if (language.contains("fr")) {

            //法语
            "fr_FR"
        } else if (language.contains("ja")) {
            //日语
            "ja_JP"
        } else if (language.contains("ru")) {
            //俄语
            "ru_RU"
        } else if (language.contains("pt")) {
            //葡萄牙语
            "pt_PT"
        } else if (language.contains("ko")) {
            //韩语
            "ko_KR"
        } else {
            //默认英语
            "en_US"
        }
    }


    fun GMTToFloat(): String {
        val lDate = Date()
        var GMT = ""
        val myFmt1 = SimpleDateFormat("z")
        val dateString = myFmt1.format(lDate)
        try {
            GMT = dateString.substring(0, 4)
            val time = dateString.substring(4, 9)
            val times = time.split(":".toRegex()).dropLastWhile { it.isEmpty() }.toTypedArray()
            val hour = java.lang.Float.parseFloat(times[0])
            var minute = java.lang.Float.parseFloat(times[1])
            minute = minute / 60
            if (minute == 0f) {
                GMT = GMT + hour.toInt()
            } else {
                GMT = GMT + (hour + minute)
            }
        } catch (e: Exception) {
            BuglyLog.i("addDevice", dateString)
            e.printStackTrace()
        }

        return GMT
    }

    /**
     * 根据手机当前语言判断是否是中国
     * return true -> 中文
     * return false -> 不是中文
     */
    fun isLanguageCN(context: Context): Boolean {
        val curLocale = context.resources.configuration.locale
        //通过Locale的equals方法，判断出当前语言环境
        val language = curLocale.language
        val country = curLocale.country

        return language.contains("zh") && country.contains("CN")
    }


    /**
     * 获取已安装应用程序的所有包名
     * @param context
     * @return
     */
    fun getPackageName(context: Context): List<String> {
        //获取packagemanager
        val packageManager = context.packageManager
        //获取所有已安装程序的包信息
        val packageInfos = packageManager.getInstalledPackages(0)
        //用于存储所有已安装程序的包名
        val packageNames = ArrayList<String>()
        //从pinfo中将包名字逐一取出，压入pName list中
        if (packageInfos != null) {
            for (i in packageInfos.indices) {
                val packName = packageInfos[i].packageName
                packageNames.add(packName)
            }
        }
        return packageNames
    }


    fun isBackground(context: Context): Boolean {
        val activityManager = context
            .getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val appProcesses = activityManager
            .runningAppProcesses
        if (null != appProcesses) {
            for (appProcess in appProcesses) {
                if (appProcess.processName == context.packageName) {
                    /*
                BACKGROUND=400 EMPTY=500 FOREGROUND=100
                GONE=1000 PERCEPTIBLE=130 SERVICE=300 ISIBLE=200
                 */

                    return appProcess.importance != ActivityManager.RunningAppProcessInfo.IMPORTANCE_FOREGROUND
                }
            }
        }
        return false
    }

}
