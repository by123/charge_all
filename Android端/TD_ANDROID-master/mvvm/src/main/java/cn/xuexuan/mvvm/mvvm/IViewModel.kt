package cn.xuexuan.mvvm.mvvm

import io.reactivex.disposables.Disposable

/**
 * Created by xuexuan on 2016/12/29.
 */

interface IViewModel<V> {
    fun attachV(view: V)

    fun detachV()

    fun addNetRequestDisposable(l: Disposable)
}
