package com.xhd.td.ui.mine

import android.os.Bundle
import android.view.View
import androidx.lifecycle.ViewModelProviders
import androidx.recyclerview.widget.LinearLayoutManager
import com.google.gson.Gson
import com.xhd.td.R
import com.xhd.td.adapter.home.AddBillingAdapter
import com.xhd.td.constants.Constants
import com.xhd.td.model.UserModel
import com.xhd.td.model.bean.*
import com.xhd.td.ui.home.AbstractAddModifyFragment
import com.xhd.td.utils.showListToPickerView
import com.xhd.td.vm.ViewModelProviderFactory
import com.xhd.td.vm.home.MerchantVM
import kotlinx.android.synthetic.main.fragment_abstract_merchant.*
import javax.inject.Inject


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */

class EditMerchantFragment : AbstractAddModifyFragment<MerchantVM>() {


    @Inject
    lateinit var factory: ViewModelProviderFactory

    private var mServiceList = arrayListOf<String?>()

    private var mSelectService = 0

    override val viewModel: MerchantVM
        get() = ViewModelProviders.of(this, factory).get(MerchantVM::class.java)

    //    private lateinit var mMerchantBean: MchBean
    lateinit var mAdapter: AddBillingAdapter

    override fun lazyInitView(view: View) {
        super.lazyInitView(view)
        mServiceList = arrayListOf("阶梯收费","预付费")
        viewModel.mCallback = this

        //隐藏和显示一些，字段

        //在编辑商户和连锁分店时候，隐藏所属连锁门店的选项
        tv_chain_store.visibility = View.GONE

        tv_chain_store_value.visibility = View.GONE
        line_chain_store.visibility = View.GONE


        //在编辑商户和连锁分店时候，隐藏代理商级别的选择
        tv_agent_level.visibility = View.GONE
        spinner_agent_level.visibility = View.GONE
        line_agent_level.visibility = View.GONE

        tv_billing_hint.visibility = View.VISIBLE
        tv_add_billing.setOnClickListener {
            if (mAdapter.itemCount >= 5) {
                showToast("计费规则不能超过5档")
            } else {
                mAdapter.addCount()
            }
        }

        if (mType == MERCHANT) {
            //如果是商户，手机号码必填
            edit_contact_phone.hint = "请输入电话"
        } else if (mType == CHAIN_STORE) {
            //如果是连锁门店，手机号码非必填
            edit_contact_phone.hint = "非必填"
        }

        //因为在添加商户的时候，行业已经添加了，所以在编辑商户的时候，这个字段是true
        mIndustryCorrect = true
        tv_phone_hint.text = "手机号码填写错误，商户将无法提现"

        tv_service.setOnClickListener(mServiceClickListener)
    }


    override fun industryClickListener(item: String) {

        //获取
        val rule = mIndustryBillingRuleList?.firstOrNull { it.industry == item }

        val billing: List<PriceBean>? = rule?.rule?.map { PriceBean(it.price.toString(), it.time) }
        val adapter = rv_billing.adapter as AddBillingAdapter?
        if (adapter != null) {
            adapter.clearData()
            adapter.addData(billing)
        }
    }


    var mServiceClickListener: View.OnClickListener = View.OnClickListener {
        hideSoftInput()
        showListToPickerView(_mActivity, mServiceList) { item, position ->
            mSelectService = position
            if(position == 0){
                view_pre.visibility = View.GONE
                rv_billing.visibility = View.VISIBLE
                tv_add_billing.visibility = View.VISIBLE
            }else{
                view_pre.visibility = View.VISIBLE
                rv_billing.visibility = View.GONE
                tv_add_billing.visibility = View.GONE
            }

            //显示所选择的连锁门店的名称
            spinner_service.text = item

            //连锁门店的选择发生了变化，则检查数据是否合法，主要是判断分润比例
            inspectData()
        }
    }

    override fun initRecyclerView() {
        val gridManager = LinearLayoutManager(context)
        rv_billing.layoutManager = gridManager
        mAdapter = AddBillingAdapter(context!!, mTextWatcher)
        rv_billing.adapter = mAdapter
    }


    override fun setData() {
        super.setData()
        //特有的，需要添加所属行业
        spinner_industry.text = mMerchantBean?.industry
        //可用分润比例，连锁分店使用连锁总店的可用分润。普通商户使用他上级的可用分润
        mSuperProfitPercent =
            (mMerchantBean?.totalPercent ?: 0F.toDouble()) + (mMerchantBean?.profitPercent ?: 0F.toDouble())

        var rule = mMerchantBean?.mchPriceRule?.get(0)
        mSelectService = if(rule?.serviceType == 1)  0 else 1
        //设置原有的计费档位
        if(rule?.serviceType == 1){
            val gradeList = parseGrade(rule?.service ?: return)
            val tempList = arrayListOf<PriceBean>()
            for ((t, p) in gradeList) {
                tempList.add(PriceBean(p, t))
            }
            mAdapter.setData(tempList)
            view_pre.visibility = View.GONE
            rv_billing.visibility = View.VISIBLE
            tv_add_billing.visibility = View.VISIBLE
        }else{
            var service =  Gson().fromJson(rule?.service, PreBean::class.java)
            edit_pre_amount.setText((service.prepaid / 100).toString())
            edit_max_amount.setText((service.maxMoney / 100).toString())
            edit_min_hour.setText((service.minMinutes / 60).toString())
            edit_min_amount.setText((service.minMoney / 100).toString())
            edit_upper_hour.setText((service.stepMinutes / 60).toString())
            edit_upper_amount.setText((service.price / 100).toString())

            view_pre.visibility = View.VISIBLE
            rv_billing.visibility = View.GONE
            tv_add_billing.visibility = View.GONE
        }
        spinner_service.text = mServiceList[mSelectService]


        //相对的字段为空，表示是绝对分润
        mIsAbsoluteProfitType = (mMerchantBean?.profitPool == null || mMerchantBean?.percentInPool == null) || mType == CHAIN_STORE || !UserModel.relativePercentWhitelist
        //根据当前的分润类型，显示对应的group
        if (mIsAbsoluteProfitType) {
            //下一次显示相对的布局
            tv_profit_type.setText(R.string.profit_relatively)
            //显示绝对的布局
            group_absolute_profit_type.visibility = View.VISIBLE
            group_relatively_profit_type.visibility = View.GONE

        } else {

            //下一次显示绝对的布局
            tv_profit_type.setText(R.string.profit_absolute)
            //显示相对的布局
            group_absolute_profit_type.visibility = View.GONE
            group_relatively_profit_type.visibility = View.VISIBLE
        }
    }

    override fun inspectBilling(): Boolean {
        //检查价格是否合法
        return mAdapter.checkPrice(mMinMoney)
    }


    override fun submitChange() {
        if (!checkInput()) return
        var freezeAmount: Int? = null
        if (edit_freeze_amount.text.toString().isNotEmpty()) {
            freezeAmount = (edit_freeze_amount.text.toString().toFloat() * 100).toInt()
        }

        val profitPool:Float?
        val percentInPool:Float?

        val profitPercent = if(mIsAbsoluteProfitType){
            //绝对分润
            profitPool = null
            percentInPool = null
            edit_profit_percent.text.toString().toFloat()
        }else{
            //相对分润
            profitPool = edit_relatively_profit_pool.text.toString().toFloat()
            percentInPool = edit_relatively_profit_percent.text.toString().toFloat()
            tv_actual_profit_value.text.toString().toFloat()
        }



        //修改商户信息
        viewModel.modifyMerchant(
            EditBeam(
                mMerchantBean?.mchId ?: "",
                edit_merchant_name.text.toString(),
                edit_contact_name.text.toString(),
                edit_contact_phone.text.toString(),
                profitPercent,
                spinner_industry.text.toString(),
                freezeAmount,
                province = mProvince,
                city = mCity,
                area = mCounty,
                detailAddr = edit_detail_address.text.toString(),
                bclearRelativeFlag = mIsAbsoluteProfitType,
                profitPool = profitPool, //分润比例池
                percentInPool = percentInPool//相对分润比例
            )
        )
    }


    //解析档位
    fun parseGrade(src: String): Array<ServiceBean> {
        try {
            return Gson().fromJson(src, Array<ServiceBean>::class.java)
        } catch (e: Exception) {

        }
        return arrayOf()
    }


    override fun modifyMerchantSuccess(msg: String) {
        //修改计费规则
        if(mSelectService == 0){
            viewModel.modifyBillingRules(ChangeRuleBeam(0f, mAdapter.getBillingList(), mMerchantBean?.mchId.toString(), 1))
        }else{
            viewModel.modifyBillingRules(ChangeRuleBeam(0f, "{\"prepaid\" : ${edit_pre_amount.text.toString().toDouble() * 100}," +
                    "\"maxMoney\" : ${edit_max_amount.text.toString().toDouble() * 100}," +
                    "\"minMinutes\" : ${edit_min_hour.text.toString().toInt() * 60}," +
                    "\"minMoney\" : ${edit_min_amount.text.toString().toDouble() * 100}," +
                    "\"stepMinutes\" : ${edit_upper_hour.text.toString().toInt() * 60}," +
                    "\"price\" : ${edit_upper_amount.text.toString().toDouble() * 100}" +
                    "}", mMerchantBean?.mchId.toString() , 2))
        }
    }

    override fun modifyMerchantFail(msg: String) {
        showToast(msg)
    }

    override fun modifyBillingRulesSuccess(msg: String) {
        showToast("修改成功")

        val bundle = Bundle()
        bundle.putString(Constants.RESULT_KEY, "")
        setFragmentResult(RESULT_OK, bundle)

        close()
    }

    override fun modifyBillingRulesFail(msg: String) {
        showToast(msg)
    }

    companion object {

        fun newInstance(type: Int = 1, title: String, bean: MchBean) = EditMerchantFragment().apply {
            arguments = Bundle().apply {
                putInt(PARAM_TYPE, type)
                putInt(PARAM_STATUS, MODIFY)
                putString(PARAM_TITLE, title)
            }

            mMerchantBean = bean
        }
    }


}