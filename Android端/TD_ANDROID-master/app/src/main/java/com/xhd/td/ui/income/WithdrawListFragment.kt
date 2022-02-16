package com.xhd.td.ui.income

import android.view.View
import androidx.lifecycle.ViewModelProviders
import cn.droidlover.xrecyclerview.RecyclerItemCallback
import cn.xuexuan.mvvm.adapter.SimpleRecAdapter
import cn.xuexuan.mvvm.event.BusProvider
import com.xhd.td.adapter.income.WithdrawListAdapter
import com.xhd.td.constants.EventKey
import com.xhd.td.model.EventMessage
import com.xhd.td.model.bean.WithDrawResultBean
import com.xhd.td.ui.MainFragment
import com.xhd.td.vm.income.AbstractLoadMoreVM


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 *
 * 收益界面的提现明细tab
 */

class WithdrawListFragment :
    AbstractLoadMoreFragment<WithDrawResultBean, WithdrawListAdapter.ViewHolder, AbstractLoadMoreVM>() {
    override var mIsAtTime: Boolean = false

    //  override val layoutId: Int get() = R.layout.fragment_income_detail
    override val viewModel: AbstractLoadMoreVM
        get() = ViewModelProviders.of(this, factory).get(AbstractLoadMoreVM::class.java)

    override lateinit var mAdapter: SimpleRecAdapter<WithDrawResultBean, WithdrawListAdapter.ViewHolder>

    override fun lazyInitView(view: View) {
        mAdapter = WithdrawListAdapter(context!!)
        //注意这里的mAdapter一定要在调用父类的initview 之上
        super.lazyInitView(view)
        mAdapter.recItemClick = object : RecyclerItemCallback<WithDrawResultBean, WithdrawListAdapter.ViewHolder>() {
            override fun onItemClick(position: Int, model: WithDrawResultBean?, tag: Int, holder: WithdrawListAdapter.ViewHolder?) {
                model?.let { WithdrawDetailFragment.newInstance(it) }?.let {
                    (parentFragment?.parentFragment as MainFragment) .startBrotherFragment(it)
                }
            }
        }
    }

    override fun getDataInTime(pageId: Int, startTime: String, endTime: String) {
        //下拉刷新界面，需要更新收益概览的数据
        BusProvider.getBus()?.post(EventMessage<Boolean>(EventKey.REFRESH_INCOME, false))
        viewModel.getWithDrawList(startTime, endTime, pageId)
    }

    override fun <T> returnDataToView(datas: List<T>) {
        mAdapter.addData(datas as List<WithDrawResultBean>)

    }

    companion object {
        fun newInstance() = WithdrawListFragment()
    }


}