package com.xhd.td.ui.home

import android.os.Bundle
import android.text.Html
import android.view.View
import androidx.lifecycle.ViewModelProviders
import androidx.recyclerview.widget.LinearLayoutManager
import com.google.gson.JsonObject
import com.xhd.td.R
import com.xhd.td.adapter.home.AddBillingAdapter
import com.xhd.td.constants.Constants
import com.xhd.td.model.UserModel
import com.xhd.td.model.bean.AddMerchantBean
import com.xhd.td.model.bean.AddResponseBean
import com.xhd.td.model.bean.PriceBean
import com.xhd.td.utils.showListToPickerView
import com.xhd.td.vm.ViewModelProviderFactory
import com.xhd.td.vm.home.MerchantVM
import kotlinx.android.synthetic.main.fragment_abstract_merchant.*
import javax.inject.Inject

/**
 * create by xuexuan
 * 来自薛瑄独创的自定义模板
 */

class AddMerchantFragment : AbstractAddModifyFragment<MerchantVM>() {


    @Inject
    lateinit var factory: ViewModelProviderFactory
    override val viewModel: MerchantVM get() = ViewModelProviders.of(this, factory).get(MerchantVM::class.java)

    lateinit var mAdapter: AddBillingAdapter

    //连锁门店的信息（id，name，行业，分润比例）
    private var mChainStoreIdNameIndustryProfit = arrayListOf<ArrayList<String>>()
    //连锁门店的姓名，这个字段信息是从mChainStoreIdNameIndustryProfit 解析出来的，用于显示到连锁门店选择列表
    private var mChainStoreNameList = arrayListOf<String?>()

    private var mSelectChainId = 0

    private var mServiceList = arrayListOf<String?>()

    private var mSelectService = 0

    override fun lazyInitView(view: View) {
        super.lazyInitView(view)

        //初始化，添加商户需要显示和隐藏的UI
        //隐藏代理商级别
        tv_agent_level.visibility = View.GONE
        spinner_agent_level.visibility = View.GONE
        line_agent_level.visibility = View.GONE


        tv_add_billing.setOnClickListener {
            if (mAdapter.itemCount ?: 0 >= 5) {
                showToast("计费规则不能超过5档")
            } else {
                mAdapter.addCount()
            }
        }
        tv_profit_share_hint.text = Html.fromHtml(
            "您的总利润比例为：<font color=\"${R.color.black}\" > ${mSuperProfitPercent}%</font>，剩余分润：<font color=\"${R.color.black}\" > ${mSuperProfitPercent}%</font>"
        )

        tv_phone_hint.text = "手机号码填写错误，商户将无法提现"
    }


    override fun initData(savedInstanceState: Bundle?) {
        super.initData(savedInstanceState)
        mServiceList = arrayListOf("阶梯收费","预付费")
        if (UserModel.type == Constants.CHAIN_AGENT) {
            //当前账户是连锁总店，创建商户，直接使用他的总店信息
            mChainStoreIdNameIndustryProfit.add(
                arrayListOf(
                    UserModel.mchBean?.mchId ?: "",
                    UserModel.mchBean?.mchName ?: "",
                    UserModel.mchBean?.industry ?: "",
                    UserModel.mchBean?.totalPercent.toString()
                )
            )
            mChainStoreNameList = mChainStoreIdNameIndustryProfit.mapTo(arrayListOf()) { it[1] }
            tv_chain_store_value.text = UserModel.mchBean?.mchName
            spinner_industry.text = UserModel.mchBean?.industry
            // 因为默认是已经有行业了
            mIndustryCorrect = true
            edit_contact_phone.hint = "非必填"

            //当前账户是连锁总店，创建的就是连锁分店
            mType = CHAIN_STORE

            //连锁门店，隐藏相对分润比例
            group_relatively_profit_type.visibility = View.GONE
            group_absolute_profit_type.visibility = View.VISIBLE
            tv_profit_type.visibility = View.GONE

        } else {
            //当前账户是代理，获取该代理创建的连锁总店
            viewModel.getChainStore()
            //点击下拉箭头和点击连锁的字，都触发下拉选择事件
            tv_chain_store.setOnClickListener(mChainStoreClickListener)

            mType = MERCHANT
//            viewModel.getBillingRules()
            edit_relatively_profit_pool.setText(mSuperProfitPercent.toString())
        }

        //默认显示计费规则
        spinner_service.text = mServiceList[mSelectService]
        tv_service.setOnClickListener(mServiceClickListener)



        if(mSelectService == 0){
            view_pre.visibility = View.GONE
            rv_billing.visibility = View.VISIBLE
            tv_add_billing.visibility = View.VISIBLE
        }else{
            view_pre.visibility = View.VISIBLE
            rv_billing.visibility = View.GONE
            tv_add_billing.visibility = View.GONE
        }
    }


    override fun initRecyclerView() {
        val gridManager = LinearLayoutManager(context)
        rv_billing.layoutManager = gridManager
        mAdapter = AddBillingAdapter(context!!, mTextWatcher)
        rv_billing.adapter = mAdapter
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

    var mChainStoreClickListener: View.OnClickListener = View.OnClickListener {
        hideSoftInput()
        showListToPickerView(_mActivity, mChainStoreNameList) { item, position ->
            mSelectChainId = position

            //根据是否选择连锁门店，来判断是否是添加连锁分店,手机号是否是必填，总的分润比例
            if (position != 0) {
                mType = CHAIN_STORE
                edit_contact_phone.hint = "非必填"
                mSuperProfitPercent = mChainStoreIdNameIndustryProfit[position][3]?.toDouble()
                //创建连锁分店，使用了连锁总店的信息，所以这里行业信息判断正确
                mIndustryCorrect = true
                //使用连锁门店的行业对应的计费方式
                industryClickListener(mChainStoreIdNameIndustryProfit[position][2])

                //连锁门店，隐藏相对分润比例
                group_relatively_profit_type.visibility = View.GONE
                group_absolute_profit_type.visibility = View.VISIBLE
                tv_profit_type.visibility = View.GONE

            } else {
                mType = MERCHANT
                edit_contact_phone.hint = "请输入电话"
                mSuperProfitPercent = UserModel.mchBean?.totalPercent ?: 0.0
                mIndustryCorrect = false
                tv_profit_type.visibility = View.VISIBLE
            }


            //显示所选择的连锁门店的名称
            tv_chain_store_value.text = item
            //默认显示连锁门店的行业
            spinner_industry.text = mChainStoreIdNameIndustryProfit[position][2] ?: "请选择行业"

            //连锁门店的选择发生了变化，则检查数据是否合法，主要是判断分润比例
            inspectData()
        }
    }

    override fun inspectBilling(): Boolean {
        //检查价格是否合法
        return mAdapter.checkPrice(mMinMoney)
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


    //添加商户的时候，点击确定的回调函数
    override fun addOne() {
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


        if (mType == MERCHANT) {
            //添加普通商户
            viewModel.addMerchant(
                AddMerchantBean(
                    edit_contact_phone.text.toString(),
                    edit_contact_name.text.toString(),
                    profitPercent,
                    edit_merchant_name.text.toString(),
                    spinner_industry.text.toString(),
                    0,
//                pledge = binding.cashPledge.text.toString(),

                    service = if(mSelectService == 0)  mAdapter.getBillingList() else   "{\"prepaid\" : ${edit_pre_amount.text.toString().toDouble() * 100}," +
                            "\"maxMoney\" : ${edit_max_amount.text.toString().toDouble() * 100}," +
                            "\"minMinutes\" : ${edit_min_hour.text.toString().toInt() * 60}," +
                            "\"minMoney\" : ${edit_min_amount.text.toString().toDouble() * 100}," +
                            "\"stepMinutes\" : ${edit_upper_hour.text.toString().toInt() * 60}," +
                            "\"price\" : ${edit_upper_amount.text.toString().toDouble() * 100}" +
                            "}",
                    serviceType = if(mSelectService == 0) 1 else 2,
                    salesId = UserModel.userBean?.userId ?: "",
                    superUser = edit_contact_phone.text.toString(),
                    province = mProvince,
                    city = mCity,
                    area = mCounty,
                    detailAddr = edit_detail_address.text.toString(),
                    blockedAmount = freezeAmount,
                    profitPool = profitPool,
                    percentInPool = percentInPool
                )
            )
        } else if (mType == CHAIN_STORE) {
            //添加连锁门店
            viewModel.addChainTenant(
                AddMerchantBean(
                    edit_contact_phone.text.toString(),
                    edit_contact_name.text.toString(),
                    edit_profit_percent.text.toString().toFloat(),
                    edit_merchant_name.text.toString(),
                    spinner_industry.text.toString(),
                    1,
//                pledge = binding.cashPledge.text.toString(),
                    service = if(mSelectService == 0)  mAdapter.getBillingList() else  "{\"prepaid\" : ${edit_pre_amount.text.toString().toDouble() * 100}," +
                            "\"maxMoney\" : ${edit_max_amount.text.toString().toDouble() * 100}," +
                            "\"minMinutes\" : ${edit_min_hour.text.toString().toInt() * 60}," +
                            "\"minMoney\" : ${edit_min_amount.text.toString().toDouble() * 100}," +
                            "\"stepMinutes\" : ${edit_upper_hour.text.toString().toInt() * 60}," +
                            "\"price\" : ${edit_upper_amount.text.toString().toDouble() * 100}" +
                            "}",
                    serviceType = if(mSelectService == 0) 1 else 2,
                    salesId = UserModel.userBean?.userId ?: "",
                    superUser = edit_contact_phone.text.toString(),
                    province = mProvince,
                    city = mCity,
                    area = mCounty,
                    detailAddr = edit_detail_address.text.toString(),
                    mchParentChainAgentId = mChainStoreIdNameIndustryProfit[mSelectChainId][0] ?: "",
                    blockedAmount = freezeAmount
                )
            )
        }
    }


    override fun addSuccess(bean: AddResponseBean) {
        //跳转到商户添加成功界面
        startWithPop(
            AddMerchantSuccessFragment.newInstance(
                bean.SuperUser,
                bean.password,
                true,
                edit_merchant_name.text.toString()
            )
        )
    }

    override fun addFail(msg: String?) {
        msg?.let { showToast(it) }
    }


    override fun getChainStoreSuccess(chainStoreInfos: ArrayList<ArrayList<String>>) {
        mChainStoreIdNameIndustryProfit = chainStoreInfos
        mChainStoreIdNameIndustryProfit.add(0, arrayListOf("0", "无", "请选择行业", "0"))
        mChainStoreNameList = mChainStoreIdNameIndustryProfit.mapTo(arrayListOf()) { it[1] }
    }

    override fun getChainStoreFail(msg: String?) {
        showToast("获取商户列表失败:${msg}")
    }


    companion object {
        fun newInstance(type: Int = MERCHANT, title: String) = AddMerchantFragment().apply {
            arguments = Bundle().apply {
                putInt(PARAM_TYPE, type)
                putInt(PARAM_STATUS, ADD)
                putString(PARAM_TITLE, title)

            }
        }
    }


}