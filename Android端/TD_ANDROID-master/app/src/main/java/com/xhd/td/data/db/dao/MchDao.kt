package com.xhd.td.data.db.dao

import androidx.room.*
import com.xhd.td.model.bean.MchBean

/**
 * create by xuexuan
 * time 2019/4/24 11:57
 */

@Dao
interface MchDao {

    @Delete
    fun delete(mchBean: MchBean)

    @Query("SELECT * FROM merchant WHERE mchId=:id  ")
    fun findByMchId(id:String):MchBean

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    fun insert(mchBean: MchBean)

}
