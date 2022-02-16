package com.xhd.td.utils

import android.app.Activity
import android.app.AlertDialog
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.Color
import android.net.Uri
import android.os.Build
import android.view.LayoutInflater
import android.view.View
import android.widget.ImageView
import android.widget.ProgressBar
import android.widget.TextView
import androidx.constraintlayout.widget.Group
import androidx.core.content.FileProvider
import androidx.core.graphics.drawable.RoundedBitmapDrawableFactory
import com.bumptech.glide.Glide
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.bumptech.glide.request.target.BitmapImageViewTarget
import com.elvishew.xlog.XLog
import com.google.gson.Gson
import com.tencent.bugly.crashreport.CrashReport
import com.xhd.td.BuildConfig
import com.xhd.td.R
import com.xhd.td.model.bean.ServiceBean
import com.xhd.td.model.bean.VersionBeam
import java.io.*
import java.math.BigDecimal
import java.net.HttpURLConnection
import java.net.URL
import java.text.DecimalFormat
import java.text.SimpleDateFormat
import java.util.*
import kotlin.math.roundToInt


////解析jwt数据
//fun parseJWT(jsonWebToken: String, base64Security: String) {
//    return try {
//        Jwts.parser().setSigningKey(base64Security.toByteArray()).parseClaimsJws(jsonWebToken).body.let {
//            Log.e("kk", it[CLAIM_MCH_ID] as String?).apply {
//                CLAIM_MCH_ID_VALUE = it[CLAIM_MCH_ID] as String?
//            }
//            Log.e("kk", (it[CLAIM_MCH_TYPE] as Int?).apply {
//                CLAIM_MCH_TYPE_VALUE = this ?: -1
//            }.toString())
//            Log.e("kk", it[CLAIM_USER_ID] as String?)
////            Log.e("kk", it[CLAIM_PERMISSION] as String?)
//            Log.e("kk", it[CLAIM_LOCATOR] as String?)
//            Log.e("kk", (it[CLAIM_ROLE_TYPE] as Int?).apply {
//                CLAIM_ROLE_TYPE_VALUE = this ?: return@apply
//            }.toString())
//        }
//    } catch (ex: ExpiredJwtException) {
//        Log.e("kk", ex.toString())
//        return
//    }
//}
//
//加载圆形图片
fun loadCirclePic(context: Context, url: String?, imageView: ImageView, resourceId: Int) {
    Glide.with(context)
        .asBitmap()
        .load(url)
        .placeholder(resourceId)
        .diskCacheStrategy(DiskCacheStrategy.ALL) //设置缓存
        .into(object : BitmapImageViewTarget(imageView) {
            override fun setResource(resource: Bitmap?) {
                val circularBitmapDrawable = RoundedBitmapDrawableFactory.create(context.resources, resource)
                circularBitmapDrawable.isCircular = true
                imageView.setImageDrawable(circularBitmapDrawable)
            }
        })

}


//时间格式化
fun formatData(timestamp: Long): String {
    val sm = SimpleDateFormat("yyyy-MM-dd", Locale.CHINA)
    //下面设置时区一定要有，如果不设置，在金立M7 Power 手机上，会显示慢一天
    sm.timeZone = TimeZone.getTimeZone("Asia/Shanghai")
    return sm.format(timestamp)
}


//时间格式化
fun formatDateOnlyDay(timestamp: Long): String {
    val sm = SimpleDateFormat("yyyy年MM月dd日", Locale.CHINA)
    //下面设置时区一定要有，如果不设置，在金立M7 Power 手机上，会显示慢一天
    sm.timeZone = TimeZone.getTimeZone("Asia/Shanghai")
    return sm.format(timestamp)
}

//时间格式化
fun formatData(timestamp: String?): String {
    if (timestamp != null) {
        val sm = SimpleDateFormat("yyyy-MM-dd  HH:mm:ss", Locale.CHINA)
        //下面设置时区一定要有，如果不设置，在金立M7 Power 手机上，会显示慢一天
        sm.timeZone = TimeZone.getTimeZone("Asia/Shanghai")
        return sm.format(timestamp.toLong())
    } else {
        return ""
    }
}


//时间格式化
fun formatDataTime(timestamp: Long?): String {
    if (timestamp != null) {
        val sm = SimpleDateFormat("yyyy-MM-dd  HH:mm:ss", Locale.CHINA)
        //下面设置时区一定要有，如果不设置，在金立M7 Power 手机上，会显示慢一天
        sm.timeZone = TimeZone.getTimeZone("Asia/Shanghai")
        return sm.format(timestamp.toLong())
    } else {
        return ""
    }
}


//获取订单状态
fun getOrderStatus(status: Int): String {
    return when (status) {
        0 -> "全部"
        1 -> "未支付"
        2 -> "已支付"
        3 -> "已完成"
        4 -> "已取消"
        5 -> "退款中"
        else -> "已退款"
    }
}

//返回金额描述
fun getOrderInfo(status: Int): String {
    return when (status) {
        1, 4 -> "待支付金额"
        2, 3 -> "订单金额"
        else -> "退款金额"
    }
}


//
////代理商
//fun showAgentList(dataList: List<MchBean>, cb: (beam: MchBean) -> Unit) {
//    val bankItemList = arrayListOf<String>()
//    for (beam in dataList) {
//        bankItemList.add(beam.mchName ?: "")
//    }
//    val builder = OptionsPickerBuilder(topActivity!!, OnOptionsSelectListener { options1, _, _, _ ->
//        cb(dataList[options1])
//    })
//    builder.setOutSideCancelable(false)
//            .setLineSpacingMultiplier(2f)
//            .isCenterLabel(false)
//            .setTextColorCenter(topActivity!!.resources.getColor(R.color.btn_yellow))
//            .setCancelColor(topActivity!!.resources.getColor(R.color.txtv_color))
//            .setSubmitColor(topActivity!!.resources.getColor(R.color.txtv_color))
//            .setContentTextSize(18)
//            .setSubCalSize(16).build<String>().apply {
//                setNPicker(bankItemList, null, null)
//            }.show()
//}
//


//检查更新的弹窗
fun updateDialog(activity: Activity, versionBean: VersionBeam) {
    val builder = AlertDialog.Builder(activity)
    builder.setCancelable(versionBean.recommend != 0)
    val dialog = builder.create()
    dialog.setCanceledOnTouchOutside(false)
//    val beam = response.body()?.data?.get(0)
    dialog.setView(LayoutInflater.from(activity).inflate(R.layout.version_dialog, null, false).apply {
        //隐藏
        if (versionBean.recommend == 0) {
            findViewById<TextView>(R.id.cancel).visibility = View.GONE
        }
        findViewById<TextView>(R.id.version).text = "V${versionBean.version}"
        findViewById<TextView>(R.id.versionDesc).text = versionBean.versionDesc
        findViewById<TextView>(R.id.cancel).setOnClickListener {
            dialog.dismiss()
            if (versionBean.recommend == 0) {
                System.exit(0)
            }
        }
        findViewById<TextView>(R.id.versionNumb).text = "大小：${versionBean.versionSize}M"
        findViewById<TextView>(R.id.downApk).setOnClickListener {
            it.visibility = View.GONE
            findViewById<TextView>(R.id.cancel).visibility = View.VISIBLE
            findViewById<TextView>(R.id.versionDesc).visibility = View.GONE
            findViewById<Group>(R.id.groupId).visibility = View.VISIBLE
            downApk(
                findViewById(R.id.login_pb),
                findViewById(R.id.progress_sch),
                dialog,
                versionBean.downloadUrl,
                activity
            )
        }
    }, 0, 0, 0, 0)
    dialog.show()
    dialog.window.decorView.setBackgroundColor(Color.parseColor("#00666666"))
}


fun downApk(pb: ProgressBar, txt: TextView, dia: AlertDialog, url: String, activity: Activity) {
    Thread {
        try {
            val http = URL(url).openConnection() as HttpURLConnection
            if (http.responseCode == HttpURLConnection.HTTP_OK) {
                val inputStream = http.inputStream
                val maxLength = http.contentLength
                pb.post {
                    pb.max = maxLength
                    txt.text = "0%"
                }
                val path = activity.externalCacheDir.path + "/wuxl.apk"
                val file = File(path)
                if (file.exists()) {
                    file.delete()
                }
                val os = FileOutputStream(path)
                var length = 0
                var lengtsh = 0f
                var bytes = ByteArray(1024)
                while ((inputStream.read(bytes).apply {
                        length = this
                    }) != -1) {
                    os.write(bytes, 0, length)
                    //获取当前进度值
                    lengtsh += length
                    //把值传给handler
                    pb.post {
                        pb.progress = lengtsh.toInt()
                        val rat = (lengtsh / maxLength) * 100
                        txt.text = "${rat.toInt()}%"
                    }
                }
                //关闭流
                inputStream.close()
                os.close()
                os.flush()
                pb.post {
                    dia.dismiss()
                    val intent = Intent(Intent.ACTION_VIEW)
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                        val contentUri =
                            FileProvider.getUriForFile(activity, BuildConfig.APPLICATION_ID + ".fileprovider", file)

                        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK

                        intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)

                        intent.setDataAndType(contentUri, "application/vnd.android.package-archive")

                    } else {

                        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK

                        intent.setDataAndType(Uri.fromFile(file), "application/vnd.android.package-archive")

                    }
                    activity.startActivity(intent)
                }
            } else {
                XLog.d("下载apk失败${http.responseCode}")
            }
        } catch (e: Exception) {
            CrashReport.postCatchedException(e)  // bugly会将这个throwable上报
        }
    }.start()
}


fun getRawToString(context: Context, id: Int): String {

    val stream = context.resources.openRawResource(id)
    return read(stream, "utf-8")
}


fun read(stream: InputStream?, encode: String): String {

    if (stream != null) {
        try {
            val reader = BufferedReader(InputStreamReader(stream, encode))
            val sb = StringBuilder()
            var line: String? = null

            line = reader.readLine()
            while (line != null) {
                sb.append(line + "\n")
                line = reader.readLine()
            }

            stream.close()
            return sb.toString()
        } catch (e: UnsupportedEncodingException) {
            e.printStackTrace()
        } catch (e: IOException) {
            e.printStackTrace()
        }
    }
    return ""
}


//解析档位
fun parseGrade(src: String): Array<ServiceBean> {
    try {
        return Gson().fromJson(src, Array<ServiceBean>::class.java)
    } catch (e: Exception) {

    }
    return arrayOf()
}


//解析价格
fun parsePrice(beam: ServiceBean): String {
    return "${beam.time.toFloat().roundToInt() / 60}小时 ${beam.price.toFloat() / 100}元"
}


fun getLocation(location: String?): String {
    return if (location.isNullOrEmpty()) "无" else location
}

fun gradeNameForMchTypeAndLevel(mchType: Int?, level: Int? = null): String {
    return when (mchType) {
        0 -> when (level) {
            1 -> "省代"
            2 -> "市代"
            3 -> "县代"
            4 -> "连锁门店"
            else -> "代理"
        }
        1 -> when (level) {
            0 -> "普通商户"
            1 -> "连锁门店商户"
            2 -> "出租车"
            else -> "商户"
        }
        else -> "平台"
    }
}

//
//解析价格
fun parseData(a: String?, b: String?): String {
    if (a.isNullOrEmpty() || b.isNullOrBlank()) return "0.00"
    val temp = (a.toFloat() - b.toFloat()).toString()

    val format = DecimalFormat("0.00")
    return format.format(BigDecimal(temp))
}

fun addZero(src: String?): String {
    if (src == null) return "0.00"
    val format = DecimalFormat("0.00")
    return format.format(BigDecimal(src))
}


//个单位转为万单位
fun convertToWan(number: Double): String {

    if (number > 9999) {

        val df = DecimalFormat("0.00");//格式化小数 //对于大于1的用"#.000"，小于1的要用"0.000"
        val num = df.format(number / 10000);//返回的是String类型
        return num + "万"

    } else {
        return number.toString()
    }
}


//个单位转为万单位
fun convertToWan(number: String?): String? {
    val d = number?.toDouble() ?: 0.0
    return if (d > 9999) {
        convertToWan(d)
    } else {
        number
    }
}

