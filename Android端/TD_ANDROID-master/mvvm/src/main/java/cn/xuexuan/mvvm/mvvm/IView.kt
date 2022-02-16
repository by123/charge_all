package cn.xuexuan.mvvm.mvvm

import android.os.Bundle

/**
 * Created by xuexuan on 2016/12/29.
 */

interface IView<VM> {

    val optionsMenuId: Int

    val layoutId: Int

    fun bindEvent()

    fun initData(savedInstanceState: Bundle)

    fun onFail()

    fun useEventBus(): Boolean

    fun newP(): VM


}
