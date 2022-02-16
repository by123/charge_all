package com.xhd.td.ui.income

import android.view.View
import androidx.lifecycle.ViewModelProviders
import cn.droidlover.xrecyclerview.RecyclerItemCallback
import cn.xuexuan.mvvm.adapter.SimpleRecAdapter
import cn.xuexuan.mvvm.event.BusProvider
import com.xhd.td.constants.EventKey
import com.xhd.td.model.EventMessage
import com.xhd.td.model.bean.EarningDetailDeveloperBeam
import com.xhd.td.ui.MainFragment
import com.xhd.td.vm.income.AbstractLoadMoreVM


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 *
 * 收益界面的收益明细tab，这个界面的item点击去是IncomeDetailFragment
 *
 */

class IncomeListFragment :
    AbstractLoadMoreFragment<EarningDetailDeveloperBeam, IncomeListAdapter.ViewHolder, AbstractLoadMoreVM>() {

    override var mIsAtTime: Boolean = false
    //  override val layoutId: Int get() = R.layout.fragment_income_detail
    override val viewModel: AbstractLoadMoreVM
        get() = ViewModelProviders.of(
            this,
            factory
        ).get(AbstractLoadMoreVM::class.java)

    override lateinit var mAdapter: SimpleRecAdapter<EarningDetailDeveloperBeam, IncomeListAdapter.ViewHolder>

    override fun lazyInitView(view: View) {
        mAdapter = IncomeListAdapter(context!!)
        //注意这里的mAdapter一定要在调用父类的initview 之上
        super.lazyInitView(view)
        mAdapter.recItemClick = object : RecyclerItemCallback<EarningDetailDeveloperBeam, IncomeListAdapter.ViewHolder>() {
                override fun onItemClick(position: Int, model: EarningDetailDeveloperBeam?, tag: Int, holder: IncomeListAdapter.ViewHolder?) {
                    (parentFragment?.parentFragment as MainFragment) .startBrotherFragment(
                        IncomeDetailFragment.newInstance(model?.profitDate?:0))
                }
            }
    }

    override fun getDataInTime(pageId: Int, startTime: String, endTime: String) {
        //下拉刷新界面，需要更新收益概览的数据
        BusProvider.getBus()?.post(EventMessage<Boolean>(EventKey.REFRESH_INCOME, false))
        viewModel.getIncomeDetail(startTime, endTime, pageId)
    }

    override fun <T> returnDataToView(datas: List<T>) {
        mAdapter.addData(datas as List<EarningDetailDeveloperBeam>)

    }


    companion object {
        fun newInstance() = IncomeListFragment()
    }

}