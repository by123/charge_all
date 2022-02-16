package com.xhd.td.utils

import android.app.Activity
import android.view.Gravity
import cn.qqtheme.framework.picker.DatePicker
import com.xhd.td.R
import java.util.*

/**
 * create by XueXuan
 * time 2019/4/1 23:12
 * description
 */
fun showDateDialog(activity:Activity, selectedDate: (year: Int, month: Int) -> Unit) {
    val cal = Calendar.getInstance()
    val picker = DatePicker(activity, DatePicker.YEAR_MONTH)
    val tColor = activity.resources.getColor(R.color.tv_black)
    picker.setTextColor(tColor)
    picker.setSubmitTextColor(tColor)
    picker.setCancelTextColor(tColor)
    picker.setTopLineColor(tColor)
    picker.setLabelTextColor(tColor)
    picker.setDividerColor(tColor)
    picker.setContentPadding(8, 8)
    picker.setGravity(Gravity.CENTER)
    picker.setWidth((picker.screenWidthPixels * 0.6).toInt())
    picker.setRangeStart(2018, 10, 14)
    picker.setRangeEnd(2030, 11, 11)
    picker.setSelectedItem(cal.get(Calendar.YEAR), cal.get(Calendar.MONTH) + 1)
    picker.setOnDatePickListener(DatePicker.OnYearMonthPickListener { year, month ->
        selectedDate(year.toInt(), month.toInt())
    })
    picker.show()
}

fun showDateDialogWithDay(activity:Activity, selectedDate: (year: Int, month: Int, day: Int) -> Unit) {
    val cal = Calendar.getInstance()
    val picker = DatePicker(activity, DatePicker.YEAR_MONTH_DAY)
    val tColor = activity.resources.getColor(R.color.tv_black)
    picker.setTextColor(tColor)
    picker.setSubmitTextColor(tColor)
    picker.setCancelTextColor(tColor)
    picker.setTopLineColor(tColor)
    picker.setLabelTextColor(tColor)
    picker.setDividerColor(tColor)
    picker.setContentPadding(8, 8)
    picker.setGravity(Gravity.CENTER)
    picker.setWidth((picker.screenWidthPixels * 0.6).toInt())
    picker.setRangeStart(2018, 10, 14)
    picker.setRangeEnd(cal.get(Calendar.YEAR), cal.get(Calendar.MONTH) + 1, cal.get(Calendar.DAY_OF_MONTH))
    picker.setSelectedItem(cal.get(Calendar.YEAR), cal.get(Calendar.MONTH) + 1, cal.get(Calendar.DAY_OF_MONTH))
    picker.setOnDatePickListener(DatePicker.OnYearMonthDayPickListener { year, month, day ->
        selectedDate(year.toInt(), month.toInt(), day.toInt())
    })
    picker.show()
}

//月份格式化
fun parseMonth(month: Int): String {
    return if (month < 10) "0$month" else "$month"
}


fun calculateMonthLastDay(year:Int, month:Int):String{

    return when(month){
        1,3,5,7,8->{
            "$year-0$month-31"
        }

        10,12->{
            "$year-$month-31"
        }

        2,4,6,9->{
            "$year-0$month-30"
        }
        11->{
            "$year-$month-30"
        }

        else -> "$year-$month-30"

    }
}


fun calculateNextMonthFirstDay(year:Int, month:Int):String{

    var newYear = year
    var nextMonth = month +1
    if (month == 12){
        //如果是12月，则获取下一年一月的数据
        newYear = year + 1
        nextMonth = 1
    }else{
         newYear = year
         nextMonth = month +1
    }
    return "$newYear-${parseMonth(nextMonth)}-01"
}