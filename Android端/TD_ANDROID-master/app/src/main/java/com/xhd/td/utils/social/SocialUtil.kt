package com.xhd.td.utils.social

import android.content.Context
import android.graphics.Bitmap
import java.io.ByteArrayOutputStream
import java.net.URL
import javax.net.ssl.HttpsURLConnection

/**
 * Created by arvinljw on 17/11/27 15:37
 * Function：
 * Desc：
 */
internal object SocialUtil {


    @Throws(Exception::class)
    operator fun get(url: URL): String? {


        val conn = url.openConnection() as HttpsURLConnection
        if (conn.responseCode == 200) {
            val `is` = conn.inputStream
            val out = ByteArrayOutputStream()
            val buffer = ByteArray(1024)
            var len: Int
            while (-1 != (`is`.read(buffer).apply { len = this })) {
                out.write(buffer, 0, len)
                out.flush()
            }
            return out.toString("utf-8")
        }





        return null
    }

    fun getAppStateName(context: Context): String {
        val packageName = context.packageName
        var beginIndex = 0
        if (packageName.contains(".")) {
            beginIndex = packageName.lastIndexOf(".")
        }
        return packageName.substring(beginIndex)
    }


    fun getWXSex(gender: String): String {
        return if ("1" == gender) "M" else "F"
    }

    fun buildTransaction(type: String?): String {
        return if (type == null) System.currentTimeMillis().toString() else type + System.currentTimeMillis()
    }

    fun bmpToByteArray(bmp: Bitmap, needThumb: Boolean): ByteArray {
        val newBmp: Bitmap
        if (needThumb) {
            var width = bmp.width
            var height = bmp.height
            if (width > height) {
                height = height * 150 / width
                width = 150
            } else {
                width = width * 150 / height
                height = 150
            }
            newBmp = Bitmap.createScaledBitmap(bmp, width, height, true)
        } else {
            newBmp = bmp
        }
        val output = ByteArrayOutputStream()
        newBmp.compress(Bitmap.CompressFormat.JPEG, 100, output)

        val result = output.toByteArray()
        try {
            output.close()
        } catch (e: Exception) {
            e.printStackTrace()
        } finally {
            if (!bmp.isRecycled) {
                bmp.recycle()
            }
            if (!newBmp.isRecycled) {
                newBmp.recycle()
            }
        }

        return result
    }

    /**
     * 是否安装qq
     */
    fun isQQInstalled(context: Context): Boolean {
        val packageManager = context.packageManager
        val packageInfo = packageManager.getInstalledPackages(0)
        if (packageInfo != null) {
            for (i in packageInfo.indices) {
                val pn = packageInfo[i].packageName
                if (pn == "com.tencent.mobileqq") {
                    return true
                }
            }
        }
        return false
    }
}
