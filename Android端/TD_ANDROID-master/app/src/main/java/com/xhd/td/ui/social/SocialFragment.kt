package com.xhd.td.ui.social

import android.os.Bundle
import android.view.View
import androidx.lifecycle.ViewModelProviders
import cn.xuexuan.mvvm.event.BusProvider
import com.xhd.td.BR
import com.xhd.td.R
import com.xhd.td.base.BaseFragment
import com.xhd.td.constants.EventKey
import com.xhd.td.databinding.FragmentSocialBinding
import com.xhd.td.model.EventMessage
import com.xhd.td.model.bean.TblUserUnionid
import com.xhd.td.utils.SocialUtil
import com.xhd.td.utils.social.SocialHelper
import com.xhd.td.utils.social.callback.SocialLoginCallback
import com.xhd.td.utils.social.callback.SocialShareCallback
import com.xhd.td.utils.social.entities.ShareEntity
import com.xhd.td.utils.social.entities.ThirdInfoEntity
import com.xhd.td.vm.ViewModelProviderFactory
import com.xhd.td.vm.cb.social.SocialCB
import com.xhd.td.vm.social.SocialVM
import kotlinx.android.synthetic.main.fragment_social.*
import kotlinx.android.synthetic.main.title_bar.*
import javax.inject.Inject


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */

class SocialFragment : BaseFragment<FragmentSocialBinding, SocialVM, SocialCB>(), SocialCB, SocialLoginCallback,
    SocialShareCallback {


    @Inject
    lateinit var factory: ViewModelProviderFactory
    override val bindingViewModel: Int get() = BR.viewModel
    override val bindingFragment: Int get() = BR.fragment
    override val layoutId: Int get() = R.layout.fragment_social
    override val viewModel: SocialVM get() = ViewModelProviders.of(this, factory).get(SocialVM::class.java)

    private var mSocialHelper: SocialHelper? = null

    override fun lazyInitView(view: View) {
        super.lazyInitView(view)
        viewModel.mCallback = this
        toolBar.setNavigationOnClickListener { close() }
        title.text = "绑定微信"
        tv_content_tip.text = "$mStartWithdrawNum 元起提 实时到账"
        btn_wechat_login.setOnClickListener { mSocialHelper!!.loginWX(context!!, this,viewModel) }
    }

    override fun initData(savedInstanceState: Bundle?) {
        super.initData(savedInstanceState)
        mSocialHelper = SocialUtil.instance.socialHelper()

    }



    private fun createWXShareEntity(): ShareEntity? {
        var shareEntity: ShareEntity? = null
        return shareEntity
    }


    override fun loginSuccess(info: ThirdInfoEntity) {
        //获取微信的账号信息成功，暂时没有用到，因为服务器直接返回了昵称和头像url，使用getAccessTokenSuccess来处理
    }



    override fun socialError(msg: String) {
        showToast(msg)
    }

    override fun shareSuccess(type: Int) {
        showToast("分享成功")

    }

    private fun toString(info: ThirdInfoEntity): String {
        return "登录信息 = {" +
                "unionId='" + info.unionId + '\''.toString() +
                ", openId='" + info.openId + '\''.toString() +
                ", nickname='" + info.nickname + '\''.toString() +
                ", sex='" + info.sex + '\''.toString() +
                ", avatar='" + info.avatar + '\''.toString() +
                ", platform='" + info.platform + '\''.toString() +
                '}'.toString()
    }




    override fun handleError(throwable: Throwable) {

    }


    override fun getAccessTokenSuccess(result: TblUserUnionid) {
        showToast("微信零钱绑定成功")
        jumpUI()
    }

    override fun getAccessTokenFail(msg: String) {
        //获取微信的accesstoken 的时候失败
        showToast(msg)
        jumpUI()
    }


    fun jumpUI(){
        pop()
        BusProvider.getBus()?.post(EventMessage<Boolean>(EventKey.REFRESH_CARD_LIST, false))
    }


    override fun getUserInfoFail(msg: String) {
        //获取微信的用户信息 的失败
        showToast(msg)
    }

    private var mStartWithdrawNum:Double = 1.0

    companion object {
        fun newInstance(startWithdrawNum:Double) = SocialFragment().apply {
            mStartWithdrawNum = startWithdrawNum
        }
    }


}