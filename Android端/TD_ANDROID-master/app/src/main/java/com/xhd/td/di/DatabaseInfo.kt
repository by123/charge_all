package com.xhd.td.di

import java.lang.annotation.Retention
import java.lang.annotation.RetentionPolicy
import javax.inject.Qualifier

/**
 * Created by amitshekhar on 07/07/17.
 */
@Qualifier
@Retention(RetentionPolicy.RUNTIME)
annotation class DatabaseInfo
