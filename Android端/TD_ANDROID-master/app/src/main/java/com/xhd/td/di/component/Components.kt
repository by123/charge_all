package com.xhd.td.di.component

import javax.inject.Singleton

@Singleton
object Components {
    var appComponent: AppComponent? = null


//    fun appComponent(): AppComponent {
//        if (appComponent == null){
//            appComponent = DaggerAppComponent.builder().coreComponent(MVVMApp.mCoreComponent).build()
//            App.roomDB = appComponent?.roomDB()!!
//        }
//        return appComponent as AppComponent
//    }
}