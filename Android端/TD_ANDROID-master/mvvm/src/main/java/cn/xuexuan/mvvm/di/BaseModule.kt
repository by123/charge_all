package cn.xuexuan.mvvm.di

import android.content.Context
import dagger.Module
import dagger.Provides
import javax.inject.Singleton

@Module
class BaseModule(val context: Context) {
    @Provides
    @Singleton
    fun providesContext(): Context {
        return context
    }


}