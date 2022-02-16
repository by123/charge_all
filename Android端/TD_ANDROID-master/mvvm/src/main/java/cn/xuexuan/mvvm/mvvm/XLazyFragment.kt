package cn.xuexuan.mvvm.mvvm

import android.os.Bundle
import cn.xuexuan.mvvm.AppConstants
import cn.xuexuan.mvvm.event.BusProvider
import com.tbruyelle.rxpermissions2.RxPermissions


/**
 * Created by xuexuan on 2017/1/26.
 */

abstract class XLazyFragment<VM : IViewModel<IView<VM>>> : LazyFragment(), IView<VM> {

    private  val vDelegate: VDelegate by lazy {VDelegateBase.create(context!!)}
    private var vm: VM? = null

    private lateinit var rxPermissions: RxPermissions


    override val optionsMenuId: Int
        get() = 0

     override fun onCreateViewLazy(savedInstanceState: Bundle?) {
        super.onCreateViewLazy(savedInstanceState)
        if (layoutId > 0) {
            setContentView(layoutId)
        }
        if (useEventBus()) {
            BusProvider.getBus()?.register(this)
        }
        bindEvent()
        initData(savedInstanceState!!)
    }


    override fun bindEvent() {

    }

    fun getvDelegate(): VDelegate {
        return vDelegate
    }

    protected fun getP(): VM? {
        if (vm == null) {
            vm = newP()
            if (vm != null) {
                vm?.attachV(this)
            }
        }
        return vm
    }

    override fun onDestoryLazy() {
        super.onDestoryLazy()
        if (useEventBus()) {
            BusProvider.getBus()?.unregister(this)
        }
        if (getP() != null) {
            getP()!!.detachV()
        }
        getvDelegate().destory()

        vm = null

    }


    protected fun getRxPermissions(): RxPermissions {
        rxPermissions = RxPermissions(this)
        rxPermissions.setLogging(AppConstants.DEV)
        return rxPermissions
    }


    override fun useEventBus(): Boolean {
        return false
    }


}
