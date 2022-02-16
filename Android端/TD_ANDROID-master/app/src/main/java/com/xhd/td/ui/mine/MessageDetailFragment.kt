package com.xhd.td.ui.mine

import android.os.Bundle
import android.util.TypedValue
import android.util.TypedValue.COMPLEX_UNIT_DIP
import android.view.View
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.RelativeLayout
import android.widget.TextView
import androidx.lifecycle.ViewModelProviders
import cn.xuexuan.mvvm.event.BusProvider
import com.bumptech.glide.Glide
import com.elvishew.xlog.XLog
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.xhd.td.BR
import com.xhd.td.R
import com.xhd.td.base.BaseFragment
import com.xhd.td.constants.Constants
import com.xhd.td.constants.EventKey
import com.xhd.td.model.EventMessage
import com.xhd.td.model.bean.MessageBean
import com.xhd.td.model.bean.MessageContentBean
import com.xhd.td.utils.TimeUtils
import com.xhd.td.vm.ViewModelProviderFactory
import com.xhd.td.vm.cb.mine.MessageCB
import com.xhd.td.vm.mine.MessageVM
import kotlinx.android.synthetic.main.fragment_message_detail.*
import kotlinx.android.synthetic.main.title_bar.*
import javax.inject.Inject


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */

class MessageDetailFragment :
    BaseFragment<com.xhd.td.databinding.FragmentMessageDetailBinding, MessageVM, MessageCB>(),
    MessageCB {


    @Inject
    lateinit var factory: ViewModelProviderFactory
    override val bindingViewModel: Int get() = BR.viewModel
    override val bindingFragment: Int get() = BR.fragment
    override val layoutId: Int get() = R.layout.fragment_message_detail
    override val viewModel: MessageVM
        get() = ViewModelProviders.of(
            this,
            factory
        ).get(MessageVM::class.java)


    private var mMsgId: Int? = null

    override fun lazyInitView(view: View) {
        super.lazyInitView(view)
        viewModel.mCallback = this
        toolBar.setNavigationOnClickListener { close() }
        title.text = ""

    }

    override fun initData(savedInstanceState: Bundle?) {
        super.initData(savedInstanceState)
        if (mMsgId != null) {
            viewModel.getNoticeMessageDetail(mMsgId!!)
        }
    }


    override fun handleError(throwable: Throwable) {

    }

    override fun getNoticeMessageDetailSuccess(bean: MessageBean) {

        tv_title.text = bean.title
        tv_time.text = TimeUtils.formatDataTime(bean.publishTime)

        //红点显示，成功打开消息界面，就取消首页的消息红点
        BusProvider.getBus()?.post(EventMessage<Boolean>(EventKey.MESSAGE_RED_ICON, false))

        try {
            val messageContentBean = Gson().fromJson<List<MessageContentBean>?>(bean.content, object : TypeToken<List<MessageContentBean>>() {}.type)
            messageContentBean?.forEach { addView(it.type, it.content) }
        } catch (e: Exception) {
            XLog.i("解析消息内容出错")
        }

//        layout_content.requestLayout()
    }

    fun addView(type: String, content: String) {

        when (type) {
            IMAGE_TYPE -> {
                val view = ImageView(context)
                view.adjustViewBounds = true
                val lp = LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.MATCH_PARENT, RelativeLayout.LayoutParams.WRAP_CONTENT)
                lp.topMargin = TypedValue.applyDimension(COMPLEX_UNIT_DIP, 10f, resources.displayMetrics).toInt()
                view.layoutParams = lp//设置布局参数
                layout_content.addView(view)
                Glide.with(context!!).load(content).into(view)
            }

            TEXT_TYPE -> {

                val view = TextView(context)
                val lp = LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.MATCH_PARENT, RelativeLayout.LayoutParams.WRAP_CONTENT)
                val margin =  TypedValue.applyDimension(COMPLEX_UNIT_DIP, 10f, resources.displayMetrics).toInt()
                lp.topMargin = margin

                view.layoutParams = lp//设置布局参数
                view.text = content
                view.setTextColor(resources.getColor(R.color.tv_color))
                view.textSize = 14f
                //设置行间距
                view.setLineSpacing(TypedValue.applyDimension(COMPLEX_UNIT_DIP, 10f, resources.displayMetrics),1f)
                layout_content.addView(view)
//                    TypedValue.applyDimension(COMPLEX_UNIT_DIP, size, r.getDisplayMetrics())
            }
        }


    }

    override fun getNoticeMessageDetailFail(msg: String?) {
        showToast(msg)
    }


    companion object {
        fun newInstance(msgId: Int?) = MessageDetailFragment().apply {
            mMsgId = msgId
            //只要打开一次，就把这个字段置空，防止返回到home界面后，再次打开消息详情界面
            Constants.CLICK_NEW_MESSAGE_ID = null
        }

        const val IMAGE_TYPE = "img"
        const val TEXT_TYPE = "text"

    }


}