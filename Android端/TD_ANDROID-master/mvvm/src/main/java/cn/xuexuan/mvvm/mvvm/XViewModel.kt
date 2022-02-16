package cn.xuexuan.mvvm.mvvm

import androidx.lifecycle.ViewModel
import io.reactivex.disposables.Disposable

/**
 * Created by xuexuan on 2016/12/29.
 */

open class XViewModel<V : IView<*>> : IViewModel<V>, ViewModel() {
    private var v: V? = null
    protected var mDisposableList: MutableList<Disposable> = arrayListOf()

    override fun attachV(view: V) {
        v = view
    }

    override fun detachV() {
        v = null
    }

    protected fun getV(): V {
        var temp = v
        if (temp == null) {
            throw IllegalStateException("v can not be null")
        } else {
            return temp
        }
    }

    override fun addNetRequestDisposable(l: Disposable) {
        mDisposableList.add(l)
    }


    override fun onCleared() {
        super.onCleared()
        if (mDisposableList.size != 0) {
            for (s in mDisposableList) {
                s.dispose()
            }
        }
    }
}