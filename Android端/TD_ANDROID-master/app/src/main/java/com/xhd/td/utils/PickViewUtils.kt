package com.xhd.td.utils

import android.app.Activity
import cn.xuexuan.mvvm.utils.ToastUtil
import com.bigkoo.pickerview.builder.OptionsPickerBuilder
import com.bigkoo.pickerview.listener.OnOptionsSelectListener
import com.xhd.td.ApplicationLike
import com.xhd.td.R

/**
 * create by xuexuan
 * time 2019/3/28 15:54
 */
//在滚动选择器中，显示指定的字符串列表
fun showListToPickerView(activity: Activity,dataList:List<String?>, callback:(item:String?,position:Int)->Unit){

    if (dataList.isEmpty()){
        ToastUtil.showLong(ApplicationLike.instance,"数据为空，请重新打开界面")
        return
    }

    val builder = OptionsPickerBuilder(activity, OnOptionsSelectListener { options1, _, _, _ ->
        callback(dataList[options1],options1)
    })
    builder.setOutSideCancelable(false)
        .setLineSpacingMultiplier(2f)
        .isCenterLabel(false)
        .setTextColorCenter(activity.resources.getColor(R.color.btn))
        .setCancelColor(activity.resources.getColor(R.color.tv_color))
        .setSubmitColor(activity.resources.getColor(R.color.tv_color))
        .setContentTextSize(18)
        .setSubCalSize(16).build<String>().apply {
            setPicker(dataList)
        }.show()
}