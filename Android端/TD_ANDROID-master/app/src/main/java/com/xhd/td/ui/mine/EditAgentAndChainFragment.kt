package com.xhd.td.ui.mine

import android.os.Bundle
import android.view.View
import androidx.lifecycle.ViewModelProviders
import com.xhd.td.constants.Constants
import com.xhd.td.model.bean.EditBeam
import com.xhd.td.model.bean.MchBean
import com.xhd.td.ui.home.AbstractAddModifyFragment
import com.xhd.td.vm.ViewModelProviderFactory
import com.xhd.td.vm.home.AgentAndChainVM
import kotlinx.android.synthetic.main.fragment_abstract_merchant.*
import javax.inject.Inject


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */

class EditAgentAndChainFragment : AbstractAddModifyFragment<AgentAndChainVM>() {


    @Inject
    lateinit var factory: ViewModelProviderFactory

    override val viewModel: AgentAndChainVM get() = ViewModelProviders.of(this, factory).get(AgentAndChainVM::class.java)

//    private lateinit var mMerchantBean: MchBean

    override fun lazyInitView(view: View) {
        super.lazyInitView(view)
        viewModel.mCallback = this



        //代理和连锁总店，都需要隐藏计费规则
        tv_title_billing.visibility = View.GONE
        rv_billing.visibility = View.GONE
        tv_add_billing.visibility = View.GONE


        //隐藏,在创建连锁分店的时候，选择所属连锁门店的选项
        tv_chain_store.visibility = View.GONE

        tv_chain_store_value.visibility = View.GONE
        line_chain_store.visibility = View.GONE


        //隐藏代理商级别的选择
        tv_agent_level.visibility = View.GONE
        spinner_agent_level.visibility = View.GONE
        line_agent_level.visibility = View.GONE

        //隐藏所属行业的选择
        tv_industry.visibility = View.GONE
        spinner_industry.visibility = View.GONE
        line_industry.visibility = View.GONE

        //因为在添加商户的时候，行业已经添加了，所以在编辑商户的时候，这个字段是true
        mIndustryCorrect = true
    }


    override fun setData() {
        super.setData()
        //可用分润比例，连锁分店使用连锁总店的可用分润。普通商户使用他上级的可用分润
        mSuperProfitPercent = (mMerchantBean?.totalPercent?:0F.toDouble())  + (mMerchantBean?.profitPercent?:0F.toDouble())
    }

    override fun submitChange() {
        if (!checkInput()) return
        var freezeAmount :Int? = null
        if (edit_freeze_amount.text.toString().isNotEmpty()) {
            freezeAmount =  (edit_freeze_amount.text.toString().toFloat() * 100).toInt()
        }

        viewModel.editAgentAndChain(EditBeam(mMerchantBean?.mchId?:"",
            edit_merchant_name.text.toString(),
            edit_contact_name.text.toString(),
            edit_contact_phone.text.toString(),
            edit_profit_percent.text.toString().toFloat(),
            blockedAmount = freezeAmount,
            province = mProvince,
            city = mCity,
            area = mCounty,
            detailAddr = edit_detail_address.text.toString()))
    }

    override fun modifyAgentSuccess(msg: String) {
        showToast("修改成功")

        val bundle = Bundle()
        bundle.putString(Constants.RESULT_KEY, "")
        setFragmentResult(RESULT_OK, bundle)

        close()
    }

    override fun modifyAgentFail(msg: String) {
        showToast(msg)
    }

    companion object {

        fun newInstance(type: Int = 1, title: String,bean: MchBean) = EditAgentAndChainFragment().apply {
            arguments = Bundle().apply {
                putInt(PARAM_TYPE, type)
                putInt(PARAM_STATUS, MODIFY)
                putString(PARAM_TITLE, title)

            }

            mMerchantBean = bean
        }
    }


}