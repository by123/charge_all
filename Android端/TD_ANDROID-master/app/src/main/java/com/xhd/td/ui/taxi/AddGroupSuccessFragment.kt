package com.xhd.td.ui.taxi

import android.os.Bundle
import android.view.View
import cn.xuexuan.mvvm.event.BusProvider
import com.xhd.td.R
import com.xhd.td.base.BaseFragmentNoCb
import com.xhd.td.base.BaseViewModelNoCb
import com.xhd.td.constants.EventKey
import com.xhd.td.databinding.FragmentAddGroupSuccessBinding
import com.xhd.td.model.EventMessage
import kotlinx.android.synthetic.main.fragment_add_group_success.*
import kotlinx.android.synthetic.main.title_bar.*


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */

class AddGroupSuccessFragment : BaseFragmentNoCb<FragmentAddGroupSuccessBinding, BaseViewModelNoCb>() {


    override val bindingViewModel: Int get() = 0
    override val viewModel: BaseViewModelNoCb? get() = null
    override val layoutId: Int get() = R.layout.fragment_add_group_success

    lateinit var mGroupId:String
    lateinit var mGroupName:String
    override fun lazyInitView(view: View) {
        super.lazyInitView(view)

        toolBar.setNavigationOnClickListener { close() }
        title.text = "创建分组成功"

        btn_add_device.setOnClickListener { addDevice(mGroupId,mGroupName) }
        btn_no_add_device.setOnClickListener { toGroupListFragment() }
    }

    override fun initData(savedInstanceState: Bundle?) {
        super.initData(savedInstanceState)
        BusProvider.getBus()?.post(EventMessage<String>(EventKey.TAXI_LIST_REFRESH, ""))

    }



    private fun addDevice(groupId: String, groupName: String){

        startWithPop(ScanTaxiActivateDeviceFragment.newInstance(groupId,groupName))
    }

    private fun toGroupListFragment(){
       pop()

    }


    companion object {
        fun newInstance(groupId:String,groupName:String) = AddGroupSuccessFragment()
            .apply {
                mGroupId = groupId
                mGroupName = groupName
            }
    }


}