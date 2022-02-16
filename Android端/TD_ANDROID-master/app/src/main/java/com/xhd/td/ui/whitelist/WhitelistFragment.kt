package com.xhd.td.ui.whitelist

import android.graphics.BitmapFactory
import android.view.View
import androidx.lifecycle.ViewModelProviders
import cn.xuexuan.mvvm.event.BusProvider
import cn.xuexuan.mvvm.extensions.addTo
import com.tencent.mm.opensdk.modelmsg.SendMessageToWX
import com.tencent.mm.opensdk.modelmsg.WXMediaMessage
import com.tencent.mm.opensdk.modelmsg.WXMiniProgramObject
import com.tencent.mm.opensdk.openapi.IWXAPI
import com.tencent.mm.opensdk.openapi.WXAPIFactory
import com.xhd.td.BR
import com.xhd.td.BuildConfig
import com.xhd.td.R
import com.xhd.td.base.BaseFragment
import com.xhd.td.constants.EventKey
import com.xhd.td.model.EventMessage
import com.xhd.td.model.bean.CreateOrderWhiteListBean
import com.xhd.td.model.bean.TblOrderWhiteList
import com.xhd.td.model.bean.WhitelistBean
import com.xhd.td.model.bean.WhitelistTimeBean
import com.xhd.td.utils.TimeUtils
import com.xhd.td.vm.ViewModelProviderFactory
import com.xhd.td.vm.cb.whitelist.WhitelistCB
import com.xhd.td.vm.whitelist.WhitelistVM
import kotlinx.android.synthetic.main.fragment_whitelist.*
import kotlinx.android.synthetic.main.title_bar.*
import javax.inject.Inject


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */

class WhitelistFragment : BaseFragment<com.xhd.td.databinding.FragmentWhitelistBinding, WhitelistVM, WhitelistCB>(), WhitelistCB {


    @Inject
    lateinit var factory: ViewModelProviderFactory
    override val bindingViewModel: Int get() = BR.viewModel
    override val bindingFragment: Int get() = BR.fragment
    override val layoutId: Int get() = R.layout.fragment_whitelist
    override val viewModel: WhitelistVM get() = ViewModelProviders.of(this, factory).get(WhitelistVM::class.java)
    private  var mWhitelistMchIds: List<String>? = null
    private  var mWhitelistId: String? = null


    // APP_ID 正式版
//    private val APP_ID = "wxba676206ee56928d"
    //测试版
//    private val APP_ID = "wx74c1232f5fc4c536"

    // IWXAPI 是第三方app和微信通信的openApi接口
    private lateinit var api: IWXAPI


    override fun lazyInitView(view: View) {
        super.lazyInitView(view)
        viewModel.mCallback = this
        toolBar.setNavigationOnClickListener { close() }
        title.text = "充电白名单"
        regToWx()
        registerEventBus()
    }


    //选择白名单使用范围
    fun selectWhitelistScope() {
        hideSoftInput()
        start(SelectWhitelistFragment.newInstance(whitelistId =  mWhitelistId))
    }

    //跳转到白名单记录列表
    fun whitelistRecord() {
        hideSoftInput()
        start(WhitelistRecordFragment.newInstance())
    }

    //跳转到充电时长选择
    fun whitelistUsageTime() {
        hideSoftInput()
        start(SelectWhitelistTimeFragment.newInstance())
    }

     /**
      * 处理rxBus数据
      */
     private fun registerEventBus() {

         BusProvider.getBus()?.toFlowable(EventMessage::class.java)!!
             .subscribe { eventMessage ->
               when (eventMessage.tag) {
                   EventKey.WHITELIST_SELECT -> {
                       val data = eventMessage.eventContent as List<WhitelistBean>

                       mWhitelistMchIds =data.map { it.mchId }
                       tv_whitelist_rang.text = data.map { it.mChName }.toString().replace("[", "").replace("]", "")
                   }

                   EventKey.WHITELIST_COPY ->{
                       val whiteList = eventMessage.eventContent as TblOrderWhiteList

                       mWhitelistId = whiteList.orderWhiteListId
                       tv_whitelist_rang.text = whiteList.userName + "的使用范围"

                   }


                   EventKey.WHITELIST_TIME_LEVEL ->{
                       mWhitelistTimeBean = eventMessage.eventContent as WhitelistTimeBean
                       tv_whitelist_usage_time.text = TimeUtils.minuteToHour(mWhitelistTimeBean?.time?:0).toString() + "小时"
                   }
               }
           }.addTo(viewModel.compositeDisposable)
    }



    private var mWhitelistTimeBean:WhitelistTimeBean? = null

    //微信邀请
    fun wechatInvite() {
        if (edit_name.text.isNullOrEmpty()) {
            showToast("请输入客户姓名")
            return
        }
        if (tv_whitelist_rang.text.isNullOrEmpty()) {
            showToast("请选择使用范围")
            return
        }
        if (tv_whitelist_usage_time.text.isNullOrEmpty()) {
            showToast("请选择使用时长")
            return
        }
        viewModel.createOrderWhiteList(CreateOrderWhiteListBean(mWhitelistMchIds,mWhitelistId, mWhitelistTimeBean?.time?:0,mWhitelistTimeBean?.scale?:0,edit_name.text.toString()))
    }



    private fun regToWx() {
        // 通过WXAPIFactory工厂，获取IWXAPI的实例
        api = WXAPIFactory.createWXAPI(activity, BuildConfig.WECHAT_ID, true)

        // 将应用的appId注册到微信
        api.registerApp(BuildConfig.WECHAT_ID)
    }



    //以小程序的方式分享到微信
    fun shareMiniProgram(whitelistResult: String) {
        val miniProgramObj = WXMiniProgramObject()
        var path = "pages/whitelist/whitelist?data=${whitelistResult}"
        miniProgramObj.webpageUrl = path// 兼容低版本的网页链接
        miniProgramObj.miniprogramType = WXMiniProgramObject.MINIPTOGRAM_TYPE_RELEASE// 正式版:0，测试版:1，体验版:2
        miniProgramObj.userName = "gh_2efaf25b7678"     // 小程序原始id
        miniProgramObj.path = path            //小程序页面路径
        val msg = WXMediaMessage(miniProgramObj)
        msg.title = "炭电邀请您免费充电"                    // 小程序消息title
        msg.description = "${edit_name.text}邀请您免费充电"               // 小程序消息desc
//        msg.thumbData = getThumb()                      // 小程序消息封面图片，小于128k
        val res = resources
        var bitmap = BitmapFactory.decodeResource(resources, R.drawable.img_whitelist_share)
        msg.setThumbImage(bitmap)

        val req = SendMessageToWX.Req()
        req.transaction = buildTransaction("miniProgram")
        req.message = msg
        req.scene = SendMessageToWX.Req.WXSceneSession  // 目前只支持会话
        api.sendReq(req)
    }

    private fun buildTransaction(type: String?): String {
        return if (type == null) System.currentTimeMillis().toString() else type + System.currentTimeMillis()
    }


    override fun handleError(throwable: Throwable) {

    }


    override fun createWhitelistSuccess(msg: String) {
//        showToast("创建白名单成功")

        //以小程序的方式分享到微信
        shareMiniProgram(msg)
    }

    override fun createWhitelistFail(msg: String) {
        showToast(msg)
    }


    companion object {
        fun newInstance() = WhitelistFragment()
        const val SELECT_WHITELIST = 1
    }


}