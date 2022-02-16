package com.xhd.td.base

import androidx.databinding.ObservableBoolean
import androidx.lifecycle.ViewModel
import cn.xuexuan.mvvm.net.SchedulerProvider
import com.elvishew.xlog.XLog
import com.xhd.td.data.DataManager
import io.reactivex.disposables.CompositeDisposable
import java.lang.ref.WeakReference

/**
 * Created by amitshekhar on 07/07/17.
 */

abstract class BaseViewModel<N>(
    val dataManager: DataManager,
    val scheduler: SchedulerProvider
) : ViewModel() {

    val isLoading = ObservableBoolean()

    val compositeDisposable: CompositeDisposable

    private var callback: WeakReference<N?>? = null

    var mCallback: N?
        get() = callback?.get()
        set(navigator) {
            this.callback = WeakReference(navigator)
        }

    init {
        this.compositeDisposable = CompositeDisposable()
    }

    override fun onCleared() {

        //注意，取消订阅放在这里有点太晚（在生命周期上来看）
        //原因：1、fragment获取xml控件是使用kotlin的插件，从自动生成的java代码来看会在fragment的onDestroyView把获取到的xml置空
        // 2、onCleared 函数的执行是在onDestroyView->onDestroy  之后， 也就说销毁ui在取消订阅之前
        // 举一个例子：如果一个rxjava网络请求，未返回之前，退出界面会执行onDestroyView，如果此时网络返回了，更新ui就会空指针错误
        //从这样的分析来看，空指针不会一定出现的，因为就算网速很差，也有可能很快执行了onCleared，网络返回后也不会继续处理了。但是经测试快速返回，每次都会 崩溃
        compositeDisposable.dispose()
        XLog.v(this.toString() + "onCleared")
        super.onCleared()
    }

    fun setIsLoading(isLoading: Boolean) {
        this.isLoading.set(isLoading)
    }
}
