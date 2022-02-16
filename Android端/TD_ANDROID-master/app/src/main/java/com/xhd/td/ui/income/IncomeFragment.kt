package com.xhd.td.ui.income

import android.os.Bundle
import android.view.View
import androidx.databinding.ObservableBoolean
import androidx.lifecycle.ViewModelProviders
import cn.xuexuan.mvvm.event.BusProvider
import cn.xuexuan.mvvm.extensions.addTo
import com.xhd.td.BR
import com.xhd.td.R
import com.xhd.td.adapter.home.FragmentTitleAdapter
import com.xhd.td.base.BaseFragment
import com.xhd.td.constants.EventKey
import com.xhd.td.databinding.FragmentIncomeBinding
import com.xhd.td.model.EventMessage
import com.xhd.td.model.bean.IncomeBean
import com.xhd.td.ui.MainFragment
import com.xhd.td.utils.showDateDialog
import com.xhd.td.vm.ViewModelProviderFactory
import com.xhd.td.vm.cb.income.IncomeCB
import com.xhd.td.vm.income.IncomeVM
import kotlinx.android.synthetic.main.fragment_income.*
import java.util.*
import javax.inject.Inject


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */

class IncomeFragment : BaseFragment<FragmentIncomeBinding, IncomeVM, IncomeCB>(),
    IncomeCB {


    @Inject
    lateinit var factory: ViewModelProviderFactory
    override val bindingViewModel: Int get() = BR.viewModel
    override val bindingFragment: Int get() = BR.fragment
    override val layoutId: Int get() = R.layout.fragment_income
    override val viewModel: IncomeVM get() = ViewModelProviders.of(this, factory).get(IncomeVM::class.java)
    override var mHasToolbar = false

    var mSelectedYear: Int = Calendar.getInstance().get(Calendar.YEAR)
    var mSelectedMonth: Int = Calendar.getInstance().get(Calendar.MONTH) + 1
    var displayFreezeTip = ObservableBoolean(false)
    private var mGetOverviewSuccess = false
    private var mCanWithdrawValue = 0.0
    private var mFrozenMoney = 0.0

    override fun lazyInitView(view: View) {
        super.lazyInitView(view)
        setSwipeBackEnable(false)
        viewModel.mCallback = this
        tv_time.setOnClickListener {
            showDateDialog(_mActivity) { year: Int, month: Int ->

                tv_time.text = "${year}年${month}月"
                mSelectedYear = year
                mSelectedMonth = month
                BusProvider.getBus()?.post(EventMessage<List<Int>>(EventKey.INCOME_TIME_CHANGE, listOf(year, month)))
            }
        }
        tv_time.text = "${mSelectedYear}年${mSelectedMonth}月"
//

        viewPager_income.adapter = FragmentTitleAdapter(
            childFragmentManager,
            arrayOf(IncomeListFragment.newInstance(), WithdrawListFragment.newInstance()),
            arrayOf("收益明细", "提现明细")
        )
//        refresh_income_overview.setOnRefreshListener { viewModel.getIncomeOverview() }
        tabLayout_income.setupWithViewPager(viewPager_income)

        img_freeze.setOnClickListener {
            displayFreezeTip.set(!displayFreezeTip.get())
        }
        registerEventBus()
    }

    override fun initData(savedInstanceState: Bundle?) {
        super.initData(savedInstanceState)
        viewModel.getIncomeOverview()
    }


    /**
     * 处理rxBus数据
     */
    private fun registerEventBus() {

        BusProvider.getBus()?.toFlowable(EventMessage::class.java)!!
            .subscribe { eventMessage ->
                when (eventMessage.tag) {
                    EventKey.REFRESH_INCOME -> {
                        viewModel.getIncomeOverview()
                    }
                }
            }.addTo(viewModel.compositeDisposable)
    }


    override fun handleError(throwable: Throwable) {

    }


    /**
     * 收益界面，资金帮助
     */
    fun startFundHelpFragment() {
        (parentFragment as MainFragment).startBrotherFragment(CapitalHelpFragment.newInstance())
    }

    /**
     * 收益界面，提现 事件
     */
    fun withdraw() {
        if (mGetOverviewSuccess) {
            when {
                mCanWithdrawValue > 0 -> //提现金额大于0，则去提现
                    (parentFragment as MainFragment).startBrotherFragment(WithdrawFragment.newInstance(mCanWithdrawValue,mFrozenMoney))
                mFrozenMoney > 0 -> {
                    //冻结金额大于0，显示冻结的提醒
                    displayFreezeTip.set(true)
                }
                else -> showToast("暂无可提现金额")
            }
        } else {
            showToast("未获取到可提现金额，请刷新界面")
        }

    }


    override fun getIncomeOverviewSuccess(income: IncomeBean) {
        mGetOverviewSuccess = true
        mCanWithdrawValue = income.canWithdrawNum.toDouble()
        mFrozenMoney = income.frozenMoney
        if (income.frozenMoney > 0) {
            img_freeze.visibility = View.VISIBLE
            tv_freeze.text = "冻结金额：${income.frozenMoney}元"
        }
    }

    override fun getIncomeOverviewFail(msg: String) {
        showToast(msg)
    }

    companion object {
        fun newInstance() = IncomeFragment()
    }


}