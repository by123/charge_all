package com.xhd.td.base

import android.annotation.TargetApi
import android.app.ProgressDialog
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.view.inputmethod.InputMethodManager
import androidx.annotation.LayoutRes
import androidx.databinding.DataBindingUtil
import androidx.databinding.ViewDataBinding
import cn.xuexuan.mvvm.utils.CommonUtils
import cn.xuexuan.mvvm.utils.NetworkUtils
import cn.xuexuan.mvvm.utils.ToastUtil
import dagger.android.AndroidInjection
import me.yokeyword.fragmentation.SupportActivity


/**
 * Created by amitshekhar on 07/07/17.
 */

abstract class BaseActivity<T : ViewDataBinding, V : BaseViewModel<N>, N> : SupportActivity(), BaseFragment.Callback {


    // this can probably depend on isLoading variable of BaseViewModel,
    // since its going to be common for all the activities
    private var mProgressDialog: ProgressDialog? = null
    var mViewDataBinding: T? = null
        private set
//     var viewModel: V? = null

    /**
     * Override for set binding variable
     *
     * @return variable id
     */
    abstract val bindingVariable: Int

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
    abstract val viewModel: V

    val isNetworkConnected: Boolean
        get() = NetworkUtils.isNetworkConnected(applicationContext)

    override fun onFragmentAttached() {

    }

    override fun onFragmentDetached(tag: String) {

    }

    abstract fun initView()
    abstract fun initData(savedInstanceState: Bundle?)

    override fun onCreate(savedInstanceState: Bundle?) {
        performDependencyInjection()
        super.onCreate(savedInstanceState)
        performDataBinding()
        initView()
        initData(savedInstanceState)
    }

    @TargetApi(Build.VERSION_CODES.M)
    fun hasPermission(permission: String): Boolean {
        return Build.VERSION.SDK_INT < Build.VERSION_CODES.M || checkSelfPermission(permission) == PackageManager.PERMISSION_GRANTED
    }

    fun hideKeyboard() {
        val view = this.currentFocus
        if (view != null) {
            val imm = getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
            imm.hideSoftInputFromWindow(view.windowToken, 0)
        }
    }

    fun hideLoading() {
        if (mProgressDialog != null && mProgressDialog!!.isShowing) {
            mProgressDialog!!.cancel()
        }
    }

    fun openActivityOnTokenExpire() {
        //        startActivity(LoginActivity.newIntent(this));
        finish()
    }

    fun performDependencyInjection() {
        AndroidInjection.inject(this)
    }

    @TargetApi(Build.VERSION_CODES.M)
    fun requestPermissionsSafely(permissions: Array<String>, requestCode: Int) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            requestPermissions(permissions, requestCode)
        }
    }

    fun showLoading() {
        hideLoading()
        mProgressDialog = CommonUtils.showLoadingDialog(this)
    }

    private fun performDataBinding() {
        mViewDataBinding = DataBindingUtil.setContentView(this, layoutId)
//        this.viewModel = if (viewModel == null) mViewModel else viewModel
        mViewDataBinding!!.setVariable(bindingVariable, viewModel)
        mViewDataBinding!!.executePendingBindings()
    }


    open fun showToast(msg: String, long: Boolean = false) {
        if (long) {
            ToastUtil.showLong(this, msg)
        } else {
            ToastUtil.showShort(this, msg)
        }

    }

}

