package com.xhd.td.utils.calendar

import java.util.*

/**
 * Created by cracker on 2017/8/5.
 */

class SelectedDate(var year: Int, var month: Int, var day: Int, var x: Int, var y: Int, var calendar: Calendar) :
    Comparable<SelectedDate> {

    override fun compareTo(o: SelectedDate): Int {
        return if (calendar.before(o.calendar)) -1 else 1
    }
}
