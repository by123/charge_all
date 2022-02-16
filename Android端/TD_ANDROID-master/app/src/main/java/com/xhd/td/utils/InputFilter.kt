package com.xhd.td.utils

import android.content.Context
import android.text.InputFilter
import android.text.Spanned
import android.text.TextUtils
import cn.xuexuan.mvvm.utils.ToastUtil
import java.util.regex.Pattern


/**
 * by 薛瑄
 * 过滤金额
 */
class InputFilter(var mContext:Context, var mMaxValue: Double = Integer.MAX_VALUE.toDouble(), var mPointerLength :Int= 2) : InputFilter {

    //只允许出现数字和小数点
    var mPattern = Pattern.compile("([0-9]|\\.)*")


    /**
     * @param source    新输入的字符串
     * @param start     新输入的字符串起始下标，一般为0
     * @param end       新输入的字符串终点下标，一般为source长度-1
     * @param dest      输入之前文本框内容
     * @param dstart    原内容起始坐标，一般为0
     * @param dend      原内容终点坐标，一般为dest长度-1
     * @return          输入内容
     */
    override fun filter(
        source: CharSequence,//新输入的字符串
        start: Int,    //新输入的字符串起始下标，一般为0
        end: Int,      //新输入的字符串终点下标，一般为source长度-1
        dest: Spanned, //输入之前文本框内容
        dstart: Int,   //原内容起始坐标，一般为0
        dend: Int      //原内容终点坐标，一般为dest长度-1
    ): CharSequence {
        val sourceString = source.toString()
        val destString = dest.toString()

        //验证删除等按键
        if (TextUtils.isEmpty(sourceString)) {
            return ""
        }

        val matcher = mPattern.matcher(source)
        //已经输入小数点，或者小数点长度为0 的情况下，只能输入数字
        if (destString.contains(POINTER)  || mPointerLength == 0) {
            //原有的内容包含小数点，之后只能输入数字
            if (!matcher.matches()) {
                return ""
            } else {
                if (POINTER == sourceString) {  //只能输入一个小数点
                    return ""
                }
            }

            //验证小数点精度，保证小数点后只能输入两位
            val index = destString.indexOf(POINTER)

            if (dend - index > mPointerLength) {
                return ""
            }
        } else {
            /**
             * 没有输入小数点的情况下，只能输入小数点和数字
             * 1. 首位不能输入小数点
             * 2. 如果首位输入0，则接下来只能输入小数点了
             */
            if (!matcher.matches()) {
                return ""
            } else {
                if (POINTER == sourceString && (TextUtils.isEmpty(destString)|| mPointerLength == 0)) {
                    //首位不能输入小数点
                    //如果小数点的长度为0，不能输入小数点
                    return ""
                }
                else if (POINTER != sourceString && ZERO == destString && dstart == 1) { //如果首位输入0，接下来只能输入小数点
                    return ""
                }
            }
        }

        //验证输入金额的大小
        val sumText = (destString + sourceString).toDouble()
        return if (sumText > mMaxValue) {
            ToastUtil.showShort(mContext,"最大不能超过$mMaxValue")
            dest.subSequence(dstart, dend)
        } else dest.subSequence(dstart, dend).toString() + sourceString

    }

    companion object {

        private val POINTER = "."

        private val ZERO = "0"
    }
}