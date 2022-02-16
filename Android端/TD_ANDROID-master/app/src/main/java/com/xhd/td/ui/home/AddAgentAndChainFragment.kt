package com.xhd.td.ui.home

import android.os.Bundle
import android.text.Html
import android.view.View
import androidx.lifecycle.ViewModelProviders
import com.xhd.td.R
import com.xhd.td.constants.Constants
import com.xhd.td.model.UserModel
import com.xhd.td.model.bean.AddMerchantBean
import com.xhd.td.model.bean.AddResponseBean
import com.xhd.td.utils.showListToPickerView
import com.xhd.td.vm.ViewModelProviderFactory
import com.xhd.td.vm.home.AgentAndChainVM
import kotlinx.android.synthetic.main.fragment_abstract_merchant.*
import javax.inject.Inject

/**
 * create by xuexuan
 * time 2019/3/30 14:24
 * 添加代理和连锁门店
 */
class AddAgentAndChainFragment : AbstractAddModifyFragment<AgentAndChainVM>() {


    @Inject
    lateinit var factory: ViewModelProviderFactory
    override val viewModel: AgentAndChainVM
        get() = ViewModelProviders.of(this, factory).get(AgentAndChainVM::class.java)

    //    代理级别选择
    lateinit var mLevelList: List<String>

    override fun lazyInitView(view: View) {
        super.lazyInitView(view)

        //代理和连锁总店，都需要隐藏计费规则
        tv_title_billing.visibility = View.GONE
        rv_billing.visibility = View.GONE
        tv_add_billing.visibility = View.GONE
        tv_billing_hint.visibility = View.GONE

        //隐藏,在创建连锁分店的时候，选择所属连锁门店的选项
        tv_chain_store.visibility = View.GONE

        tv_chain_store_value.visibility = View.GONE
        line_chain_store.visibility = View.GONE


        tv_address_title.text = "区域位置(非必填)"
        if (mType == AGENT) {
            tv_merchant_info.text = "代理商信息"
            tv_merchant_name.text = "代理商名称"
            edit_merchant_name.hint = "请输入代理商名称"
            mNoMerchantAgentHint = "请输入代理商名称"

            tv_contact_phone.text = "代理人电话"
            tv_contact_name.text = "代理人姓名"

            tv_profit_share_title.text = "代理商分润"
            tv_profit_share.text = "设置子代理分润比例"

            //隐藏所属行业
            tv_industry.visibility = View.GONE
            spinner_industry.visibility = View.GONE
            line_industry.visibility = View.GONE

            view_pre.visibility = View.GONE
            tv_service.visibility = View.GONE
            spinner_service.visibility = View.GONE
            line_service.visibility = View.GONE

            //初始化数据，代理级别选择
            mLevelList = resources.getStringArray(if (UserModel.mchBean?.level == 1) R.array.array_provincial_agent else R.array.array_municipal_agent).toList()
            spinner_agent_level.setOnClickListener(mLevelClickListener)
        } else if (mType == CHAIN_AGENT) {
            tv_merchant_info.text = "账户信息"
            tv_merchant_name.text = "连锁门店名称"
            edit_merchant_name.hint = "请输入连锁门店名称"
            mNoMerchantAgentHint = "请输入连锁门店名称"
            tv_profit_share_title.text = "设置分润"
            tv_profit_share.text = "分润比例"
            //初始化，添加商户需要显示和隐藏的UI
            //隐藏代理商级别
            tv_agent_level.visibility = View.GONE
            spinner_agent_level.visibility = View.GONE
            line_agent_level.visibility = View.GONE

            view_pre.visibility = View.GONE
            tv_service.visibility = View.GONE
            spinner_service.visibility = View.GONE
            line_service.visibility = View.GONE

            //初始化数据，所属行业选择
            viewModel.getConfig(Constants.CFG_INDUSTRY_TYPE)

        }


        tv_profit_share_hint.text = Html.fromHtml(
            "您的总利润比例为：<font color=\"${R.color.black}\" > ${mSuperProfitPercent}%</font>，剩余分润：<font color=\"${R.color.black}\" > ${mSuperProfitPercent}%</font>")

    }


    var mLevelClickListener: View.OnClickListener = View.OnClickListener {
        showListToPickerView(_mActivity, mLevelList) { item, position ->
            //选择代理级别
            spinner_agent_level.text = item
            mAgentLevelCorrect = true
            inspectData()
        }
    }


    //添加商户的时候，点击确定的回调函数
    override fun addOne() {
        if (!checkInput()) return
        var level: Int = 1
        if (mType == CHAIN_AGENT) {
            level = 4
        } else if (mType != CHAIN_AGENT) {
            level = if (spinner_agent_level.text.toString() == "市代") {
                //市代
                2
            } else {
                //区县代
                3
            }
        }

        var freezeAmount: Int? = null
        if (edit_freeze_amount.text.toString().isNotEmpty()) {
            freezeAmount = (edit_freeze_amount.text.toString().toFloat() * 100).toInt()
        }

        viewModel.addChainAgent(
            AddMerchantBean(
                edit_contact_phone.text.toString(),
                edit_contact_name.text.toString(),
                edit_profit_percent.text.toString().toFloat(),
                edit_merchant_name.text.toString(),
                spinner_industry.text.toString(),
                level,
                //如果是商户，普通商户是0
                salesId = UserModel.userBean?.userId ?: "",
                superUser = edit_contact_phone.text.toString(),
                province = mProvince,
                city = mCity,
                area = mCounty,
                detailAddr = edit_detail_address.text.toString(),
                blockedAmount = freezeAmount
            ),
            mType
        )
    }


    override fun addSuccess(bean: AddResponseBean) {
        //跳转到商户添加成功界面
        startWithPop(
            AddMerchantSuccessFragment.newInstance(
                bean.SuperUser,
                bean.password,
                false,
                edit_merchant_name.text.toString()
            )
        )
    }

    override fun addFail(msg: String?) {
        msg?.let { showToast(it) }
    }

    companion object {
        fun newInstance(type: Int = 1, title: String) = AddAgentAndChainFragment().apply {
            arguments = Bundle().apply {
                putInt(PARAM_TYPE, type)
                putInt(PARAM_STATUS, ADD)
                putString(PARAM_TITLE, title)

            }
        }
    }


}