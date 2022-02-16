package com.xhd.td.base


import android.content.Context
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.annotation.LayoutRes
import androidx.appcompat.widget.Toolbar
import androidx.databinding.DataBindingUtil
import androidx.databinding.ViewDataBinding
import cn.xuexuan.mvvm.utils.ToastUtil
import com.xhd.td.R
import com.xhd.td.utils.qmui.QMUIStatusBarHelper
import dagger.android.support.AndroidSupportInjection
import me.yokeyword.fragmentation_swipeback.SwipeBackFragment


/**
 * Created by amitshekhar on 09/07/17.
 */

abstract class BaseFragment<T : ViewDataBinding, V : BaseViewModel<N>, N> : SwipeBackFragment() {

    var mBaseActivity: BaseActivity<*, *, *>? = null

    private var mRootView: View? = null
    lateinit var mViewDataBinding: T

    /**
     * Override for set binding variable
     *
     * @return variable id
     */
    abstract val bindingViewModel: Int

    open val bindingFragment: Int? = null
    /**
     * @return layout resource id
     */
    @get:LayoutRes
    abstract val layoutId: Int

    /**
     * Override for set view model
     *
     * @return view model instance
     */
    abstract val viewModel: V?
    open var mHasToolbar = true

    val isNetworkConnected: Boolean
        get() = mBaseActivity != null && mBaseActivity!!.isNetworkConnected

    override fun onAttach(context: Context) {
        super.onAttach(context)
        Log.i(this.toString(), "onAttach")
        if (context is BaseActivity<*, *, *>) {
            val activity = context as BaseActivity<*, *, *>?
            this.mBaseActivity = activity
            activity!!.onFragmentAttached()
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        Log.i(this.toString(), "onCreate")

        performDependencyInjection()
        super.onCreate(savedInstanceState)
//        mViewModel = viewModel
        setHasOptionsMenu(false)
    }

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        Log.i(this.toString(), "onCreateView")

        mViewDataBinding = DataBindingUtil.inflate(inflater, layoutId, container, false)
        mRootView = mViewDataBinding.root
        return attachToSwipeBack(mRootView)
    }


    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        Log.i(this.toString(), "onViewCreated")
        if (viewModel != null) {
            mViewDataBinding.setVariable(bindingViewModel, viewModel)
        }
        if (bindingFragment != null) {
            mViewDataBinding.setVariable(bindingFragment!!, this)
        }
        mViewDataBinding.lifecycleOwner = this
//        mViewDataBinding!!.executePendingBindings()
        if (mHasToolbar) {
            val toolBar = view?.findViewById<Toolbar>(R.id.toolBar)
            if (toolBar != null) {
//                val lp = toolBar.layoutParams as ViewGroup.MarginLayoutParams
//                lp.setMargins(0, QMUIStatusBarHelper.getStatusbarHeight(_mActivity), 0, 0)
//                toolBar.layoutParams = lp

                val lp = toolBar.layoutParams
                lp.height = lp.height + QMUIStatusBarHelper.getStatusbarHeight(_mActivity)
                toolBar.setPadding(0, QMUIStatusBarHelper.getStatusbarHeight(_mActivity), 0, 0)
                toolBar.layoutParams = lp
            }
        }
        initView(view)
    }



    override fun onStart() {
        super.onStart()
        Log.i(this.toString(), "onStart")

    }

    override fun onResume() {
        super.onResume()
        Log.i(this.toString(), "onResume")

    }

    override fun onSupportVisible() {
        super.onSupportVisible()
        QMUIStatusBarHelper.setStatusBarLightMode(_mActivity)
    }


    override fun onLazyInitView(savedInstanceState: Bundle?) {
        super.onLazyInitView(savedInstanceState)
        Log.i(this.toString(), "onLazyInitView")

        //注意，在fragment中，使用kotlin自动获取xml中的id，需要在onCreateView之后，否则会出现空异常
        lazyInitView(mRootView!!)
        initData(savedInstanceState)
    }



    override fun onPause() {
        super.onPause()
        Log.i(this.toString(), "onPause")

    }

    override fun onSupportInvisible() {
        super.onSupportInvisible()
    }

    override fun onDestroyView() {

        //取消这些订阅放在销毁ui之前，防止UI空指针
        viewModel?.compositeDisposable?.dispose()

        super.onDestroyView()
        Log.i(this.toString(), "onDestroyView")

    }

    override fun onDestroy() {
        super.onDestroy()
        Log.i(this.toString(), "onDestroy")
    }

    override fun onDetach() {
        Log.i(this.toString(), "onDetach")

        mBaseActivity = null
        super.onDetach()
    }


    override fun onHiddenChanged(hidden: Boolean) {
        super.onHiddenChanged(hidden)
        Log.i(this.toString(), "onHiddenChanged = " + hidden)

    }

    override fun setUserVisibleHint(isVisibleToUser: Boolean) {
        super.setUserVisibleHint(isVisibleToUser)
        Log.i(this.toString(), "setUserVisibleHint = " + isVisibleToUser)

    }


    open fun lazyInitView(view: View) {

    }

    open fun initView(view: View) {

    }


    open fun initData(savedInstanceState: Bundle?) {

    }

    fun hideKeyboard() {
        if (mBaseActivity != null) {
            mBaseActivity!!.hideKeyboard()
        }
    }

    fun openActivityOnTokenExpire() {
        if (mBaseActivity != null) {
            mBaseActivity!!.openActivityOnTokenExpire()
        }
    }

    private fun performDependencyInjection() {
        AndroidSupportInjection.inject(this)
    }

    interface Callback {

        fun onFragmentAttached()

        fun onFragmentDetached(tag: String)
    }


    open fun showToast(msg: String?, long: Boolean = false) {
        if (long) {
            ToastUtil.showLong(_mActivity, msg ?: "")
        } else {
            ToastUtil.showShort(_mActivity, msg ?: "")
        }

    }

    open fun close() {
        hideKeyboard()
        pop()
    }

}
