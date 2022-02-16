package com.xhd.td.utils.calendar

/**
 * Created by cracker on 2017/8/5.
 */

interface CalendarSelectListener {

    fun onSelected(type: Int, time: Array<String?>)
}


interface CalendarCompleteistener {

    fun onComplete(startTime:String?,endTime:String?)
}