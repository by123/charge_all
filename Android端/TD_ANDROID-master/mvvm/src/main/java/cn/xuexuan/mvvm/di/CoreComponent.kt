package cn.xuexuan.mvvm.di

import android.content.Context
import android.content.SharedPreferences
import dagger.Component
import javax.inject.Singleton

@Singleton
@Component(modules = [BaseModule::class, StorageModule::class])
interface CoreComponent {

    fun context(): Context

//    fun picasso(): Picasso

    fun sharedPreferences(): SharedPreferences


}