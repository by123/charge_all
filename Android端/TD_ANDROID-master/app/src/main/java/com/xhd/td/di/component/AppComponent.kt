package com.xhd.td.di.component

import android.app.Application
import com.xhd.td.App
import com.xhd.td.di.builder.ActivityBuilder
import com.xhd.td.di.module.AppModule
import com.xhd.td.di.module.NetworkModule
import dagger.BindsInstance
import dagger.Component
import dagger.android.support.AndroidSupportInjectionModule
import javax.inject.Singleton


/**
 * create by xuexuan
 * time 2018/6/27 20:54
 */


@Singleton
//@Component(modules = [AndroidInjectionModule::class,BaseModule::class, AppModule::class, ActivityBuilder::class])
@Component(modules = [AndroidSupportInjectionModule ::class, AppModule::class, NetworkModule::class,ActivityBuilder::class])
interface AppComponent {

    fun inject(app: App)

    @Component.Builder
    interface Builder {

        @BindsInstance
        fun application(application: Application): Builder

        fun build(): AppComponent
    }
}



