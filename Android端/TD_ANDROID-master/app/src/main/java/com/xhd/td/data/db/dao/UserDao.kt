package com.xhd.td.data.db.dao

import androidx.room.*
import com.xhd.td.model.bean.UserBean

/**
 * Created by xuexuan on 07/07/17.
 */

@Dao
 interface UserDao {

    @Delete
    fun delete(user: UserBean)

    @Query("SELECT * FROM users WHERE userId=:id  ")
    fun findByUserId(id:String): UserBean

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    fun insert(user: UserBean)


}
