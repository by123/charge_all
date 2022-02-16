package com.xhd.td.data.db

import androidx.room.Database
import androidx.room.RoomDatabase
import androidx.room.TypeConverters
import com.xhd.td.data.db.dao.MchDao
import com.xhd.td.data.db.dao.UserDao
import com.xhd.td.model.bean.MchBean
import com.xhd.td.model.bean.UserBean

/**
 * create by xuexuan
 * time 2018/6/27 20:17
 */

@Database(entities = [UserBean::class,MchBean::class], version = 3,exportSchema = false)
@TypeConverters(Converters::class)
abstract class AppDatabase : RoomDatabase() {
    abstract fun userDao(): UserDao
    abstract fun merchantDao(): MchDao
}