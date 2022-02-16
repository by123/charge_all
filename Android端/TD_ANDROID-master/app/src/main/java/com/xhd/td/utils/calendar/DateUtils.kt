package com.xhd.td.utils.calendar

import java.text.SimpleDateFormat
import java.util.*

/**
 * Created by cracker on 2017/8/4.
 */

object DateUtils {
    private val mSimpleDateFormat = SimpleDateFormat("yyyy年MM月")

    val curYear: Int
        get() {
            val calendar = Calendar.getInstance()
            return calendar.get(Calendar.YEAR)
        }

    //        Log.e("kk", "________." + calendar.get(Calendar.MONTH));
    val month: Int
        get() {
            val calendar = Calendar.getInstance()
            return calendar.get(Calendar.MONTH)
        }

    fun getDate(position: Int): String {
        val calendar = Calendar.getInstance()
        calendar.add(Calendar.MONTH, position - CalendarFragment.curPos)
        return mSimpleDateFormat.format(calendar.time)
    }

    fun getList(position: Int): CustomBeam {
        //        Log.e("kk", position + "");
        val beam = CustomBeam()
        val calendar = Calendar.getInstance()
        val curDay = calendar.get(Calendar.DAY_OF_MONTH)
        //        Log.e("kk", "---->" + curDay);
        beam.curYearMonth = calendar.get(Calendar.YEAR).toString() + "," + calendar.get(Calendar.MONTH)
        val i = position - CalendarFragment.curPos
        calendar.add(Calendar.MONTH, i)
        calendar.set(Calendar.DAY_OF_MONTH, 1)
        val week = calendar.get(Calendar.DAY_OF_WEEK) - 1//星期天是1，星期六是7
        calendar.add(Calendar.MONTH, 1)
        calendar.add(Calendar.DATE, -1)
        val max = calendar.get(Calendar.DAY_OF_MONTH)
        beam.spaceCount = week
        beam.monthCount = max
        if (position == CalendarFragment.curPos) {
            beam.nextCount = curDay - 1//显示灰色的天数
        } else if (position > CalendarFragment.curPos) {
            beam.nextCount = 0
        } else {
            beam.nextCount = max
        }
        beam.yearMonth = calendar.get(Calendar.YEAR).toString() + "," + calendar.get(Calendar.MONTH)
        return beam
    }
}
