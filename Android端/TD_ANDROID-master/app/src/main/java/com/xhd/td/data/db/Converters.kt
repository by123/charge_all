package com.xhd.td.data.db

import androidx.room.TypeConverter
import cn.xuexuan.mvvm.utils.JsonUtil
import com.xhd.td.model.bean.BillingBean


/**
 * create by xuexuan
 * time 2019/4/25 10:25
 */

class Converters {
    @TypeConverter
    fun fromTimestamp(value: String?): List<BillingBean>? {
        return if (value == null) null else JsonUtil.jsonToList(value)
    }

    @TypeConverter
    fun dateToTimestamp(list: List<BillingBean>?): String? {
        return (if (list == null) null else JsonUtil.objectToJson(list))
    }
}
