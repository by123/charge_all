package com.xhd.td.ui.income

import android.view.View
import androidx.lifecycle.ViewModelProviders
import cn.xuexuan.mvvm.adapter.SimpleRecAdapter
import com.xhd.td.adapter.income.DeviceOfIncomeAdapter
import com.xhd.td.model.bean.IncomeTopBeam
import com.xhd.td.vm.income.AbstractLoadMoreVM

/**
 * create by xuexuan
 * time 2019/4/4 14:19
 */
class DeviceOfIncomeFragment :
    AbstractLoadMoreFragment<IncomeTopBeam, DeviceOfIncomeAdapter.ViewHolder, AbstractLoadMoreVM>() {


    override var mIsAtTime: Boolean = true

    override val viewModel: AbstractLoadMoreVM
        get() = ViewModelProviders.of(
            this,
            factory
        ).get(AbstractLoadMoreVM::class.java)

    override lateinit var mAdapter: SimpleRecAdapter<IncomeTopBeam, DeviceOfIncomeAdapter.ViewHolder>

    override fun initView(view: View) {
        mAdapter = DeviceOfIncomeAdapter(context!!)
        //注意这里的mAdapter一定要在调用父类的initview 之上
        super.initView(view)

    }

    override fun getDataAtTime(pageId: Int, time: String) {
        viewModel.getChildrenDeviceUsingScenes(time, pageId)
    }

    override fun <T> returnDataToView(datas: List<T>) {
        mAdapter.addData(datas as List<IncomeTopBeam>)
    }

    /**
     * 这个是让他的父容器，调用这个来设置数据，因为本界面有个兄弟界面，分别是（渠道收入，设备使用），他们是从同一个接口获取数据的
     */
    fun <T> setData(datas: List<T>?, currentPage: Int, totalPage: Int, totalCount: Int, atTime: String) {
        //父界面的时间改变后，需要把这里的时间更新，保障上拉加载更多的时候，时间正确
        mAtTime = atTime
        mAdapter.clearData()
        if (datas != null) {

            mAdapter.addData(datas as List<IncomeTopBeam>)
        }
        getDataSuccess(currentPage, totalPage, totalCount)
    }


    companion object {
        fun newInstance(time: String) = DeviceOfIncomeFragment().apply {
            mAtTime = time
        }
    }

}