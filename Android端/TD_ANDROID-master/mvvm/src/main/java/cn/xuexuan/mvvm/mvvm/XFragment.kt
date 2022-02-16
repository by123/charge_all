package cn.xuexuan.mvvm.mvvm

import android.app.Activity
import android.content.Context
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import cn.xuexuan.mvvm.AppConstants
import cn.xuexuan.mvvm.event.BusProvider
import com.tbruyelle.rxpermissions2.RxPermissions
import me.yokeyword.fragmentation.SupportFragment


/**
 * Created by xuexuan on 2016/12/29.
 */

abstract class XFragment<VM : IViewModel<IView<*>>> : SupportFragment(), IView<VM> {

    private var vDelegate: VDelegate? = null
    private var vm: VM? = null
    protected var context: Activity? = null
    private lateinit var rootView: View

    private lateinit var rxPermissions: RxPermissions

    // 再点一次退出程序时间设置
    private val WAIT_TIME = 2000L
    private var TOUCH_TIME: Long = 0

    override val optionsMenuId: Int
        get() = 0

    abstract fun initView(view:View)

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        val view = inflater.inflate(layoutId, container, false)
        initView(view)
        return view
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        if (useEventBus()) {
            BusProvider.getBus()?.register(this)
        }
        bindEvent()
        initData(savedInstanceState!!)
    }


    protected fun getvDelegate(): VDelegate {
        if (vDelegate == null) {
            vDelegate = VDelegateBase.create(context!!)
        }
        return vDelegate!!
    }

    protected fun getP(): VM? {
        if (vm == null) {
            vm = newP()
            if (vm != null) {
                vm!!.attachV(this)
            }
        }
        return vm
    }

    override fun onAttach(context: Context) {
        super.onAttach(context)
        if (context is Activity) {
            this.context = context
        }
    }

    override fun onDetach() {
        super.onDetach()
        context = null
    }

    override fun useEventBus(): Boolean {
        return false
    }


    override fun onDestroyView() {
        super.onDestroyView()
        if (useEventBus()) {
            BusProvider.getBus()?.unregister(this)
        }
        if (getP() != null) {
            getP()!!.detachV()
        }
        getvDelegate().destory()

        vm = null
        vDelegate = null
    }

    protected fun getRxPermissions(): RxPermissions {
        rxPermissions = RxPermissions(this)
        rxPermissions.setLogging(AppConstants.DEV)
        return rxPermissions
    }

    override fun bindEvent() {

    }

    /**
     * 处理回退事件
     *
     * @return
     */
    override fun onBackPressedSupport(): Boolean {
        if (System.currentTimeMillis() - TOUCH_TIME < WAIT_TIME) {
            _mActivity.finish()
        } else {
            TOUCH_TIME = System.currentTimeMillis()
//            Toast.makeText(_mActivity, R.string.press_again_exit, Toast.LENGTH_SHORT).show()
        }
        return true
    }


}
