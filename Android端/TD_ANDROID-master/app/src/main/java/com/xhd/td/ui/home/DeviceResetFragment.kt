package com.xhd.td.ui.home

import android.text.Html
import android.text.method.LinkMovementMethod
import android.view.View
import androidx.databinding.ObservableBoolean
import androidx.databinding.ObservableField
import androidx.lifecycle.ViewModelProviders
import cn.jzvd.JZDataSource
import cn.jzvd.JzvdStd
import com.bumptech.glide.Glide
import com.xhd.td.BR
import com.xhd.td.R
import com.xhd.td.base.BaseFragment
import com.xhd.td.vm.ViewModelProviderFactory
import com.xhd.td.vm.cb.home.AbstractScanQrCB
import com.xhd.td.vm.home.ScanVM
import kotlinx.android.synthetic.main.fragment_device_reset.*
import kotlinx.android.synthetic.main.title_bar.*
import javax.inject.Inject


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */

class DeviceResetFragment : BaseFragment<com.xhd.td.databinding.FragmentDeviceResetBinding, ScanVM, AbstractScanQrCB>(), AbstractScanQrCB {


    @Inject
    lateinit var factory: ViewModelProviderFactory
    override val bindingViewModel: Int get() = BR.viewModel
    override val bindingFragment: Int get() = BR.fragment
    override val layoutId: Int get() = R.layout.fragment_device_reset
    override val viewModel: ScanVM get() = ViewModelProviders.of(this, factory).get(ScanVM::class.java)


    var resetCode:ObservableField<String> = ObservableField()
    var sn:ObservableField<String> = ObservableField()

    var resetSuccess:ObservableBoolean = ObservableBoolean(false)

    override fun lazyInitView(view: View) {
        super.lazyInitView(view)
        toolBar.setNavigationOnClickListener { close() }
        title.text = "设备密码重置"
        viewModel.mCallback = this
        tv_customer_service.movementMethod = LinkMovementMethod.getInstance()
        tv_customer_service.text = Html.fromHtml("如需更多帮助，<font color='#76ADF0'><a href='tel:${getString(R.string.service_phone)}'>请联系客服</a></font>")
        tv_success_content.movementMethod = LinkMovementMethod.getInstance()
        tv_success_content.text = Html.fromHtml("若设备输入充电密码仍然无法充电,请再次尝试设备复位操作，<font color='#76ADF0'><a href='tel:${getString(R.string.service_phone)}'>或联系平台客服</a></font>")
//        val code = scanResult.substring(0, scanResult.length / 2) + "  " + scanResult.substring(scanResult.length / 2, scanResult.length)
//        binding.resetCode = resetCode
        tv_reset_code.spacing = 4f

//        binding.firstImv.apply {
//            setOnPreparedListener {
//                background = null
////                it.start()
//            }
//            this.setOnCompletionListener {
//
//            }
//        var filePath = Uri.parse("android.resource://" + activity!!.packageName + "/raw/" + R.raw.op_instro)
//            setVideoURI(filePath)
//            setMediaController(MediaController(activity))
//            val mmr = MediaMetadataRetriever()
////            mmr.setDataSource(activity, filePath)
//            //获取第一帧图片 mImage.setImageBitmap(bitmap); //释放资源
////            ThumbnailUtils.createVideoThumbnail(filePath.path, MINI_KIND)
////            background = BitmapDrawable(ThumbnailUtils.createVideoThumbnail(filePath.encodedPath, MINI_KIND))
////            mmr.release()
//        }
//        binding.firstImv.setUp("android.resource://" + activity!!.packageName + "/raw/" + R.raw.op_instro, "饺子快长大", JzvdStd.SCREEN_WINDOW_NORMAL)

    //屏蔽代码
     //   jzvd_video.setUp(JZDataSource("http://xhdianapp.oss-cn-beijing.aliyuncs.com/action.mp4"), JzvdStd.SCREEN_WINDOW_NORMAL)
    //        Glide.with(this).load(R.drawable.action).into(jzvd_video.thumbImageView)
//屏蔽代码
    }


    override fun handleError(throwable: Throwable?) {

    }

    override fun confirmResetFail(msg: String) {
        //确认修改密码失败
        showToast(msg)
    }

    override fun confirmResetSuccess(msg: String) {
        //确认修改密码成功

        resetSuccess.set(true)
    }


    companion object {
        fun newInstance(resetCode:String,sn:String) = DeviceResetFragment().apply {
            this.resetCode.set(resetCode)
            this.sn.set(sn)
        }
    }


}