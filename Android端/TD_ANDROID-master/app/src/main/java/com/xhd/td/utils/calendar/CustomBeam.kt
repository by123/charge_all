package com.xhd.td.utils.calendar

/**
 * Created by cracker on 2017/8/4.
 */

class CustomBeam {
    var monthCount: Int = 0
    var spaceCount: Int = 0
    var nextCount: Int = 0
    var yearMonth: String? = null
    var curYearMonth: String? = null

    override fun toString(): String {
        return "CustomBeam{" +
                "monthCount=" + monthCount +
                ", spaceCount=" + spaceCount +
                ", nextCount=" + nextCount +
                ", yearMonth='" + yearMonth + '\''.toString() +
                ", curYearMonth='" + curYearMonth + '\''.toString() +
                '}'.toString()
    }
}
