package com.xhd.td.base

import cn.xuexuan.mvvm.net.SchedulerProvider
import com.xhd.td.data.DataManager

/**
 * Created by amitshekhar on 07/07/17.
 */

abstract class BaseViewModelNoCb (dataManager: DataManager, scheduler: SchedulerProvider) : BaseViewModel<NullInterface>(dataManager,scheduler)
