 package com.xhd.td.di.module

import android.app.Application
import android.content.Context
import androidx.room.Room
import androidx.room.migration.Migration
import androidx.sqlite.db.SupportSQLiteDatabase
import cn.xuexuan.mvvm.AppConstants
import cn.xuexuan.mvvm.net.AppSchedulerProvider
import cn.xuexuan.mvvm.net.SchedulerProvider
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.xhd.td.data.AppDataManager
import com.xhd.td.data.DataManager
import com.xhd.td.data.db.AppDatabase
import com.xhd.td.data.db.AppDbHelper
import com.xhd.td.data.db.DbHelper
import com.xhd.td.data.prefs.AppPreferencesHelper
import com.xhd.td.data.prefs.PreferencesHelper
import com.xhd.td.data.remote.ApiHeader
import com.xhd.td.data.remote.ApiHelper
import com.xhd.td.data.remote.AppApiHelper
import com.xhd.td.di.ApiInfo
import com.xhd.td.di.DatabaseInfo
import com.xhd.td.di.PreferenceInfo
import dagger.Module
import dagger.Provides
import javax.inject.Singleton

/**
 * Created by amitshekhar on 07/07/17.
 */
@Module
class AppModule {



    @Provides
    @Singleton
    fun provideApiHelper(appApiHelper: AppApiHelper): ApiHelper {
        return appApiHelper
    }

    @Provides
    @ApiInfo
    fun provideApiKey(): String {
        return ""
    }

    @Provides
    @Singleton
    fun provideAppDatabase(@DatabaseInfo dbName: String, context: Context): AppDatabase {
        return Room.databaseBuilder(context, AppDatabase::class.java, dbName)
            .fallbackToDestructiveMigration()
            .addMigrations(object : Migration(1,2) {
                override fun migrate(database: SupportSQLiteDatabase) {

//                    //创建表
//                    database.execSQL(
//                        "CREATE TABLE student_new (student_id TEXT, student_name TEXT, phone_num INTEGER, PRIMARY KEY(student_id))");
//                    //复制表
//                    database.execSQL(
//                        "INSERT INTO student_new (student_id, student_name, phone_num) SELECT student_id, student_name, phone_num FROM student");
//                    //删除表
//                    database.execSQL("DROP TABLE student");
//                    //修改表名称
//                    database.execSQL("ALTER TABLE student_new RENAME TO students");

                    // 添加了两个新字段
                    //  var blockedAmount: Int?,
                    //  var blockedAmountYuan: Double?,

                    database.execSQL("ALTER TABLE merchant  ADD  blockedAmount INTEGER DEFAULT 0")
                    database.execSQL("ALTER TABLE merchant  ADD  blockedAmountYuan Double DEFAULT 0")
                }
            },object : Migration(2,3) {
                override fun migrate(database: SupportSQLiteDatabase) {

//                    database.execSQL(
//                        "CREATE TABLE student_new (mchId VARCHAR, student_name TEXT, phone_num INTEGER, PRIMARY KEY(mchId))"
//                    );

//                    database.execSQL("ALTER TABLE merchant  ADD  mchLocationLatitude Double DEFAULT 0")
//                    database.execSQL("ALTER TABLE merchant  ADD  mchLocationLongitude Double DEFAULT 0")

                    //创建表
                    database.execSQL(
                        "CREATE TABLE merchant_new (" +
                                "mchId VARCHAR PRIMARY KEY NOT NULL, " +
                                "mchType TINYINT NOT NULL, " +
                                "mchName  VARCHAR, " +
                                "name  VARCHAR, " +
                                "mobile VARCHAR, " +
                                "level TINYINT NOT NULL, " +
                                "parentAgencyId VARCHAR, " +
                                "locator VARCHAR," +
                                "industry  VARCHAR," +
                                "canWithdrawNum TINYINT NOT NULL, " +
                                "freezeNum TINYINT NOT NULL, " +
                                "profitPercent DOUBLE NOT NULL, " +
                                "totalPercent DOUBLE NOT NULL, " +
                                "latitude DOUBLE, " +
                                "longitude DOUBLE, " +
                                "contractTime VARCHAR, " +
                                "province VARCHAR, " +
                                "city VARCHAR, " +
                                "area VARCHAR, " +
                                "detailAddr VARCHAR, " +
                                "contactUser VARCHAR, " +
                                "contactPhone VARCHAR, " +
                                "salesId VARCHAR, " +
                                "salesName VARCHAR, " +
                                "superUser VARCHAR, " +
                                "nextChildLocator VARCHAR, " +
                                "delState TINYINT NOT NULL, " +
                                "supportSevice TINYINT, " +
                                "createTime INTEGER, " +
                                "modifyTime INTEGER, " +
                                "settementPeriod VARCHAR NOT NULL, " +
                                "deviceTotal TINYINT NOT NULL, " +
                                "deviceActiveTotal TINYINT NOT NULL, " +
                                "blockedAmount TINYINT, " +
                                "blockedAmountYuan DOUBLE, " +
                                "mchPriceRule VARCHAR)")


                    //复制表
                    database.execSQL(
                        "INSERT INTO merchant_new (mchId, mchType, mchName,name,mobile,level,parentAgencyId," +
                                "locator,industry,canWithdrawNum,freezeNum,profitPercent,totalPercent,latitude,longitude," +
                                "contractTime,province,city,area,detailAddr,contactUser,contactPhone,salesId,salesName," +
                                "superUser,nextChildLocator,delState,supportSevice,createTime,modifyTime," +
                                "settementPeriod,deviceTotal,deviceActiveTotal,blockedAmount,blockedAmountYuan,mchPriceRule) " +
                                "SELECT mchId, mchType, mchName,name,mobile,level,parentAgencyId," +
                                "locator,industry,canWithdrawNum,freezeNum,profitPercent,totalPercent,latitude,longitude,"  +
                                "contractTime,province,city,area,detailAddr,contactUser,contactPhone,salesId,salesName,"  +
                                "superUser,nextChildLocator,delState,supportSevice,createTime,modifyTime," +
                                "settementPeriod,deviceTotal,deviceActiveTotal,blockedAmount,blockedAmountYuan,mchPriceRule FROM merchant")
                    //删除表
                    database.execSQL("DROP TABLE merchant")
                    //修改表名称
                    database.execSQL("ALTER TABLE merchant_new RENAME TO merchant")

                    //  字段类型修改,latitude  longitude  从string 改为double
                    //  var blockedAmount: Int?,
                    //  var blockedAmountYuan: Double?,

                }
            })
            .build()
    }

    @Provides
    @Singleton
    fun provideContext(application: Application): Context {
        return application
    }

    @Provides
    @Singleton
    fun provideDataManager(appDataManager: AppDataManager): DataManager {
        return appDataManager
    }

    @Provides
    @DatabaseInfo
    fun provideDatabaseName(): String {
        return AppConstants.DB_NAME
    }

    @Provides
    @Singleton
    fun provideDbHelper(appDbHelper: AppDbHelper): DbHelper {
        return appDbHelper
    }

    @Provides
    @Singleton
    fun provideGson(): Gson {
        return GsonBuilder().excludeFieldsWithoutExposeAnnotation().create()
    }

    @Provides
    @PreferenceInfo
    fun providePreferenceName(): String {
        return AppConstants.PREF_NAME
    }

    @Provides
    @Singleton
    fun providePreferencesHelper(appPreferencesHelper: AppPreferencesHelper): PreferencesHelper {
        return appPreferencesHelper
    }

    @Provides
    @Singleton
    fun provideProtectedApiHeader(@ApiInfo apiKey: String, preferencesHelper: PreferencesHelper)
            : ApiHeader.ProtectedApiHeader {
        return ApiHeader.ProtectedApiHeader(apiKey, preferencesHelper.accessToken)
    }

    @Provides
    fun provideSchedulerProvider(): SchedulerProvider {
        return AppSchedulerProvider()
    }

}
