package com.xhd.td.utils

import java.text.ParseException
import java.text.SimpleDateFormat
import java.util.*


/**
 * create by xuexuan
 * time 2019/6/19 15:46
 */

object TimeUtils {


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

    //计算起始和终止时间，精确到秒
    // time: 2019年10月8日
    // start：true是起始时间 ,false是结束时间
    // 返回起始的秒是2019-09-08 00:00:00,结束的秒是2019-09-10 23:59:59
    fun convertToStartEnd(time: String, start: Boolean): String {

        var time1 = time.replace("年", "-").replace("月", "-").replace("日", "")
        time1 = if (start) {
            "$time1 00:00:00"
        } else {
            "$time1 23:59:59"
        }
        return time1
    }


    fun convertToShortLine(time: String): String {
        return time.replace("年", "-").replace("月", "-").replace("日", "")
    }

    fun convertToSemantics(time: String): String {
        return time.replace("-", "年").replace("-", "月") + "日"
    }


    /**
     * 获取过去第几天的日期
     *
     * @param past
     * @return
     */
    fun getPastDate(past: Int): String {
        val calendar = Calendar.getInstance()
        calendar.set(Calendar.DAY_OF_YEAR, calendar.get(Calendar.DAY_OF_YEAR) - past + 1)
        val today = calendar.time
        val format = SimpleDateFormat("yyyy年MM月dd日")
        return format.format(today)
    }

    /**
     * 获取未来 第 past 天的日期
     * @param past
     * @return
     */
    fun getFeatureDate(past: Int): String {
        val calendar = Calendar.getInstance()
        calendar.set(Calendar.DAY_OF_YEAR, calendar.get(Calendar.DAY_OF_YEAR) + past)
        val today = calendar.time
        val format = SimpleDateFormat("yyyy年MM月dd日")
        return format.format(today)
    }


    fun secondToHour(second:Int):Int{
        return second/60/60
    }

    fun minuteToHour(minute:Int):Int{
        return minute/60
    }



    fun dateToTimestamp(dateString:String, pattern:String = "yyyy年MM月dd日"):Long{
        val dateFormat =  SimpleDateFormat(pattern)
        var date =  Date()
        try{
            date = dateFormat.parse(dateString)
        } catch( e: ParseException) {
            e.printStackTrace()
        }
        return date.time
    }


}