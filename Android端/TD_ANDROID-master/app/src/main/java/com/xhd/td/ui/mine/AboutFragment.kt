package com.xhd.td.ui.mine

import android.content.Intent
import android.net.Uri
import android.view.View
import androidx.lifecycle.ViewModelProviders
import com.google.gson.Gson
import com.xhd.td.BR
import com.xhd.td.R
import com.xhd.td.base.BaseFragment
import com.xhd.td.databinding.FragmentAboutBinding
import com.xhd.td.model.UserModel
import com.xhd.td.model.bean.GrayscaleUpdateUsers
import com.xhd.td.model.bean.VersionBeam
import com.xhd.td.ui.MainFragment
import com.xhd.td.utils.updateDialog
import com.xhd.td.vm.ViewModelProviderFactory
import com.xhd.td.vm.cb.LoginCallback
import com.xhd.td.vm.login.LoginVM
import kotlinx.android.synthetic.main.title_bar.*
import javax.inject.Inject


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */

class AboutFragment : BaseFragment<FragmentAboutBinding, LoginVM, LoginCallback>(), LoginCallback {


    @Inject
    lateinit var factory: ViewModelProviderFactory
    override val bindingViewModel: Int get() = BR.viewModel
    override val bindingFragment: Int get() = BR.fragment
    override val layoutId: Int get() = com.xhd.td.R.layout.fragment_about
    override val viewModel: LoginVM get() = ViewModelProviders.of(this, factory).get(LoginVM::class.java)


    override fun initView(view: View) {
        super.initView(view)
        viewModel.mCallback = this
        toolBar.setNavigationOnClickListener { close() }
        title.text = "关于我们"
    }


    /**
     * 检查更新
     */
    fun checkUpdate(){
        if (UserModel.grayscaleUpdate == null) {
            //获取灰度更新的用户
            viewModel.getConfig(MainFragment.GRAYSCALE_UPDATE_USER)
        }else {
            //检查版本更新
            viewModel.checkVersion(UserModel.grayscaleUpdate?:false)
        }
    }

    /**
     * 跳转到用户协议界面
     */
    fun userProtocol(){
        start(UserProtocolFragment.newInstance())
    }


    fun servicePhone(){
        val intent = Intent(Intent.ACTION_DIAL, Uri.parse("tel:${getString(R.string.service_phone)}"))
        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
        startActivity(intent)

    }

    override fun handleError(throwable: Throwable) {

    }


    override fun getVersionFail(msg: String) {
        showToast(msg)
    }

    override fun getVersionSuccess(beans: List<VersionBeam>) {
        if (beans.isNotEmpty()){
            updateDialog(_mActivity,beans.get(0))
        }else{
            showToast("已经是最新版本")
        }

    }

    override fun getConfigSuccess(key: String, data: String?) {
        //获取灰度更新用户列表成功

        //判断当前用户是否在灰度更新的列表里面
        val users = Gson().fromJson<GrayscaleUpdateUsers>(data, GrayscaleUpdateUsers::class.java)
        UserModel.grayscaleUpdate = users?.users?.contains(UserModel.userBean?.userId)

        viewModel.checkVersion(UserModel.grayscaleUpdate ?: false)
    }


    override fun getConfigFail(msg: String?) {
        //获取灰度更新用户列表失败
        viewModel.checkVersion(UserModel.grayscaleUpdate ?: false)
    }



    companion object {
        fun newInstance() = AboutFragment()
    }


}