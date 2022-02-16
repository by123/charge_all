package com.xhd.td.ui.whitelist

import android.os.Bundle
import android.view.View
import androidx.lifecycle.ViewModelProviders
import cn.xuexuan.mvvm.event.BusProvider
import cn.xuexuan.mvvm.extensions.addTo
import com.xhd.td.BR
import com.xhd.td.R
import com.xhd.td.adapter.whitelist.WhitelistRecordAdapter
import com.xhd.td.base.BaseFragment
import com.xhd.td.constants.EventKey
import com.xhd.td.databinding.FragmentEditWhitelistBinding
import com.xhd.td.model.EventMessage
import com.xhd.td.model.bean.EditWhitelistBean
import com.xhd.td.model.bean.TblOrderWhiteList
import com.xhd.td.model.bean.WhitelistBean
import com.xhd.td.model.bean.WhitelistTimeBean
import com.xhd.td.utils.TimeUtils
import com.xhd.td.vm.ViewModelProviderFactory
import com.xhd.td.vm.cb.whitelist.WhitelistCB
import com.xhd.td.vm.whitelist.WhitelistVM
import kotlinx.android.synthetic.main.fragment_edit_whitelist.*
import kotlinx.android.synthetic.main.title_bar.*
import javax.inject.Inject


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */

class EditWhitelistFragment : BaseFragment<FragmentEditWhitelistBinding, WhitelistVM, WhitelistCB>(), WhitelistCB {

    @Inject
    lateinit var factory: ViewModelProviderFactory

    override val bindingViewModel: Int get() = BR.viewModel
    override val viewModel: WhitelistVM get() = ViewModelProviders.of(this, factory).get(WhitelistVM::class.java)
    override val bindingFragment: Int? get() = BR.fragment
    override val layoutId: Int get() = R.layout.fragment_edit_whitelist

    public var mWhitelist: TblOrderWhiteList? = null

    private var mWhitelistMchIds: List<String>? = null
    private var mWhitelistTimeBean:WhitelistTimeBean? = null
    private var mWhitelistUserName:String? = null

    override fun lazyInitView(view: View) {
        super.lazyInitView(view)

        toolBar.setNavigationOnClickListener { close() }
        title.text = "编辑白名单"
        viewModel.mCallback = this
        registerEventBus()
    }

    override fun initData(savedInstanceState: Bundle?) {
        super.initData(savedInstanceState)
        edit_whitelist_name_value.setText(mWhitelist?.userName ?: "")
        tv_whitelist_time_value.text = TimeUtils.minuteToHour(mWhitelist?.duration ?: 0).toString() + "小时"

        tv_whitelist_time_value.setOnClickListener {
            hideSoftInput()
            start(SelectWhitelistTimeFragment.newInstance(true))
        }

        tv_whitelist_range_value.setOnClickListener {
            //跳转到树形结点选择，传入参数，1、是否编辑  2、白名单id
            hideSoftInput()
            start(SelectWhitelistFragment.newInstance(true, mWhitelist?.orderWhiteListId))
        }

        btn_confirm.setOnClickListener {

            if (edit_whitelist_name_value.text.isNotEmpty()) {
                mWhitelistUserName = edit_whitelist_name_value.text.toString()
            }

            viewModel.editOrderWhiteList(
                EditWhitelistBean(mWhitelist?.orderWhiteListId,
                    mWhitelistUserName, mWhitelistMchIds, mWhitelistTimeBean?.time, mWhitelistTimeBean?.scale)
            )
        }
    }



    /**
     * 处理rxBus数据
     */
    private fun registerEventBus() {

        BusProvider.getBus()?.toFlowable(EventMessage::class.java)!!
            .subscribe { eventMessage ->
                when (eventMessage.tag) {
                    EventKey.WHITELIST_EDIT_RANGE -> {
                        val data = eventMessage.eventContent as List<WhitelistBean>

                        mWhitelistMchIds =data.map { it.mchId }
                        tv_whitelist_range_value.text = data.map { it.mChName }.toString().replace("[", "").replace("]", "")
//                        tv_whitelist_range_value.setTextColor(resources.getColor(R.color.tv_black))
                    }


                    EventKey.WHITELIST_EDIT_TIME_LEVEL ->{
                        mWhitelistTimeBean = eventMessage.eventContent as WhitelistTimeBean
                        tv_whitelist_time_value.text = TimeUtils.minuteToHour(mWhitelistTimeBean?.time?:0).toString() + "小时"
                    }
                }
            }.addTo(viewModel.compositeDisposable)
    }



    //修改白名单结果
    override fun editOrderWhiteListSuccess(msg: String, holder: WhitelistRecordAdapter.ViewHolder?, position: Int?) {
        //修改成功,
        showToast("修改成功")
        BusProvider.getBus()?.post(EventMessage<Boolean>(EventKey.WHITELIST_REFRESH, false))
        close()
    }

    override fun editOrderWhiteListFail(msg: String) {
        showToast(msg)
    }


    override fun handleError(throwable: Throwable) {

    }


    companion object {
        fun newInstance(whitelist: TblOrderWhiteList) = EditWhitelistFragment().apply {
            mWhitelist = whitelist
        }
    }


}