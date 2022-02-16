package cn.xuexuan.mvvm.mvvm

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.view.Menu
import cn.xuexuan.mvvm.AppConstants
import cn.xuexuan.mvvm.event.BusProvider
import cn.xuexuan.mvvm.event.RxBusImpl
import cn.xuexuan.mvvm.utils.AppStatusUtils
import com.tbruyelle.rxpermissions2.RxPermissions
import io.reactivex.disposables.Disposable
import me.yokeyword.fragmentation.SupportActivity
import java.util.*


/**
 * Created by xuexuan on 2016/12/29.
 */

abstract class XActivity<VM : IViewModel<IView<VM>>> : SupportActivity(), IView<VM> {

    private val vDelegate: VDelegate by lazy {VDelegateBase.create(context) }
    private var p: VM? = null
    protected lateinit var context: Activity

    private lateinit var rxPermissions: RxPermissions
    protected var mDisposable: Disposable? = null
    protected lateinit var mRxBus: RxBusImpl
    protected var mDisposableList: MutableList<Disposable>? = null

    override val optionsMenuId: Int
        get() = 0

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        when (AppStatusUtils.getInstance().appStatus) {
            AppStatusUtils.STATUS_FORCE_KILLED -> { }
            AppStatusUtils.STATUS_NORMAL -> { }
            else -> { }
        }
        // restartApp();
        // setUpViewAndData();

        context = this
        mDisposableList = ArrayList()
        if (layoutId > 0) {
            setContentView(layoutId)
            bindEvent()
        }
        if (useEventBus()) {
            BusProvider.getBus()?.register(this)
            mRxBus = BusProvider.getBus()!!
        }
        initData(savedInstanceState!!)
    }


    protected fun restartApp() {
        val intent = Intent()
        intent.action = "com.futureway.smartcrutch"
        intent.putExtra(AppStatusUtils.START_LAUNCH_ACTION, AppStatusUtils.STATUS_FORCE_KILLED)
        startActivity(intent)
    }



    protected fun getvDelegate(): VDelegate {
        return vDelegate
    }

    protected fun getP(): VM? {
        if (p == null) {
            p = newP()
            if (p != null) {
                p!!.attachV(this)
            }
        }
        return p
    }

    /**
     * 为了防止activity关闭后，网络请求没有关闭，导致返回后，v为空的问题
     * 这里统一收集所有网络请求的Disposable，activity关闭后，将会统一取消
     * @param disposable
     */
    fun addNetRequestDisposable(disposable: Disposable) {
        mDisposableList!!.add(disposable)
    }


    override fun onResume() {
        super.onResume()
        getvDelegate().resume()
    }


    override fun onPause() {
        super.onPause()
        getvDelegate().pause()
    }

    override fun useEventBus(): Boolean {
        return false
    }

    override fun onDestroy() {
        super.onDestroy()
        if (useEventBus()) {
            if (mDisposable != null) {
                mDisposable!!.dispose()
            }
            BusProvider.getBus()?.unregister(this)
        }
        if (getP() != null) {
            getP()!!.detachV()
        }

        if (mDisposableList != null && mDisposableList!!.size != 0) {
            for (s in mDisposableList!!) {
                s.dispose()
            }
        }

        getvDelegate().destory()
        p = null
//        vDelegate = null
    }

    override fun onCreateOptionsMenu(menu: Menu): Boolean {
        if (optionsMenuId > 0) {
            menuInflater.inflate(optionsMenuId, menu)
        }
        return super.onCreateOptionsMenu(menu)
    }

    protected fun getRxPermissions(): RxPermissions {
        rxPermissions = RxPermissions(this)
        rxPermissions.setLogging(AppConstants.DEV)
        return rxPermissions
    }

    override fun bindEvent() {

    }

    override fun onFail() {

    }
}
