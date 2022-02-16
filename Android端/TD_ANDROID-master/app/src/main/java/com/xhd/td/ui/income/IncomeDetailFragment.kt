package com.xhd.td.ui.income

import android.view.View
import androidx.lifecycle.ViewModelProviders
import com.xhd.td.BR
import com.xhd.td.R
import com.xhd.td.adapter.home.FragmentTitleAdapter
import com.xhd.td.base.BaseFragment
import com.xhd.td.databinding.FragmentIncomeDetailBinding
import com.xhd.td.model.UserModel
import com.xhd.td.model.bean.AccountDetailBean
import com.xhd.td.model.bean.IncomeTempBeam
import com.xhd.td.model.bean.IncomeTopBeam
import com.xhd.td.utils.TimeUtils.formatData
import com.xhd.td.utils.showDateDialogWithDay
import com.xhd.td.vm.ViewModelProviderFactory
import com.xhd.td.vm.cb.income.IncomeDetailCB
import com.xhd.td.vm.income.IncomeDetailVM
import kotlinx.android.synthetic.main.fragment_income_detail.*
import kotlinx.android.synthetic.main.title_bar.*
import java.text.SimpleDateFormat
import java.util.*
import javax.inject.Inject


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */

class IncomeDetailFragment : BaseFragment<FragmentIncomeDetailBinding, IncomeDetailVM, IncomeDetailCB>(), IncomeDetailCB {


    @Inject
    lateinit var factory: ViewModelProviderFactory
    override val bindingViewModel: Int get() = BR.viewModel
    override val bindingFragment: Int get() = BR.fragment
    override val layoutId: Int get() = R.layout.fragment_income_detail
    override val viewModel: IncomeDetailVM get() = ViewModelProviders.of(this, factory).get(IncomeDetailVM::class.java)


    var mSelectData: String = formatData(System.currentTimeMillis())
    var mPeriod: String? = null

    lateinit var mSourceOfIncomeFragment :SourceOfIncomeFragment
    lateinit var mDeviceOfIncomeFragment :DeviceOfIncomeFragment

    override fun lazyInitView(view: View) {
        super.lazyInitView(view)
        viewModel.mCallback = this

        toolBar.setNavigationOnClickListener { close() }
        title.text = "收益详情"

        tv_time.setOnClickListener {
            showDateDialogWithDay(_mActivity) { year: Int, month: Int, day: Int ->
                mSelectData = "$year-$month-$day"
                tv_time.text = mSelectData
                setWithdrawDataToView(mSelectData,mPeriod)
                viewModel.getIncomeCondition(mSelectData)
                viewModel.getChildrenDeviceUsingScenes(mSelectData,0)
//                (binding.detailVP.adapter as? DetailVpAdapter)?.loadData(selectDate)
//                BusProvider.getBus()?.post(EventMessage<List<Int>>(EventKey.INCOME_DETAIL_TIME_CHANGE, listOf(year, month, day)))
            }
        }
        tv_time.text = mSelectData
        //获取资金提现周期
//        viewModel.getMyDetail()

        mPeriod = UserModel.mchBean?.settementPeriod
        //获取到周期，在这里进行ui更新
        setWithdrawDataToView(mSelectData,mPeriod)
        viewModel.getIncomeCondition(mSelectData)


        mSourceOfIncomeFragment = SourceOfIncomeFragment.newInstance(mSelectData)
        mDeviceOfIncomeFragment = DeviceOfIncomeFragment.newInstance(mSelectData)

        viewPager.adapter = FragmentTitleAdapter(
            childFragmentManager,
            arrayOf(mSourceOfIncomeFragment, mDeviceOfIncomeFragment),
            arrayOf("渠道收入", "设备使用")
        )
        tabLayout.setupWithViewPager(viewPager)
    }


    private fun setWithdrawDataToView(selectData: String, period: String?) {

        if (!period.isNullOrEmpty()) {

            val sdf = SimpleDateFormat("yyyy-MM-dd")
            val date = sdf.parse(selectData)
            val calendar = Calendar.getInstance()
            calendar.time = date
            calendar.add(Calendar.DATE, period.toIntOrNull() ?: 0)
            val date1 = calendar.time
            tv_withdraw_day.text = "预计提现日期 " + sdf.format(date1)
        } else {
            showToast("未获取到提现周期")
        }
    }

    override fun handleError(throwable: Throwable) {

    }


    override fun getMyDetailSuccess(merchant: AccountDetailBean) {

        mPeriod = UserModel.mchBean?.settementPeriod
        //获取到周期，在这里进行ui更新
        setWithdrawDataToView(mSelectData,mPeriod)
    }

    override fun getMyDetailFail(msg: String) {
        showToast(msg)
    }


    override fun getIncomeConditionSuccess() {
    }

    override fun getIncomeConditionFail(msg: String) {
        showToast(msg)
        //网络正常的情况下，获取失败，就是没有数据，则需要把他的两个子界面置为空
        mSourceOfIncomeFragment.setData(arrayListOf<IncomeTopBeam>(),0,0,0,mSelectData)
        mDeviceOfIncomeFragment.setData(arrayListOf<IncomeTopBeam>(),0,0,0,mSelectData)

    }


    override fun getIncomeDetailSuccess(bean: IncomeTempBeam<IncomeTopBeam>){
        mSourceOfIncomeFragment.setData(bean.rows,bean.pageId,bean.pageCount,bean.totalCount,mSelectData)
        mDeviceOfIncomeFragment.setData(bean.rows,bean.pageId,bean.pageCount,bean.totalCount,mSelectData)
    }

    override fun getIncomeDetailFail(msg: String) {
        showToast(msg)
    }


    companion object {
        fun newInstance(selectData:Long) = IncomeDetailFragment().apply {
            mSelectData = formatData(selectData) }
    }


}