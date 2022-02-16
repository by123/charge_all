package com.xhd.td.ui.income

import android.os.Bundle
import android.text.Editable
import android.text.TextWatcher
import android.util.TypedValue
import android.view.View
import android.widget.LinearLayout
import android.widget.RelativeLayout
import android.widget.TextView
import androidx.databinding.ObservableBoolean
import androidx.databinding.ObservableInt
import androidx.lifecycle.ViewModelProviders
import cn.xuexuan.mvvm.event.BusProvider
import cn.xuexuan.mvvm.extensions.addTo
import com.google.gson.Gson
import com.xhd.td.BR
import com.xhd.td.R
import com.xhd.td.base.BaseFragment
import com.xhd.td.constants.Constants
import com.xhd.td.constants.EventKey
import com.xhd.td.databinding.FragmentWithdrawBinding
import com.xhd.td.model.EventMessage
import com.xhd.td.model.UserModel
import com.xhd.td.model.bean.*
import com.xhd.td.ui.mine.bank.CardListFragment
import com.xhd.td.ui.mine.bank.SelectBankAddCardFragment
import com.xhd.td.ui.social.SocialFragment
import com.xhd.td.utils.CashierInputFilter
import com.xhd.td.utils.loadCirclePic
import com.xhd.td.vm.ViewModelProviderFactory
import com.xhd.td.vm.cb.income.WithdrawCB
import com.xhd.td.vm.income.WithdrawVM
import kotlinx.android.synthetic.main.title_bar.*
import kotlinx.android.synthetic.yellow.fragment_withdraw.*
import java.util.*
import javax.inject.Inject
import kotlin.concurrent.timerTask


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */

class WithdrawFragment : BaseFragment<FragmentWithdrawBinding, WithdrawVM, WithdrawCB>(),
    WithdrawCB {

    @Inject
    lateinit var factory: ViewModelProviderFactory
    override val bindingViewModel: Int get() = BR.viewModel
    override val bindingFragment: Int get() = BR.fragment
    override val layoutId: Int get() = R.layout.fragment_withdraw
    override val viewModel: WithdrawVM
        get() = ViewModelProviders.of(
            this,
            factory
        ).get(WithdrawVM::class.java)

    lateinit var mBankCardBean: Bank
    var mWechatInfo: TblUserUnionid? = null

    var mCardAmount: ObservableInt = ObservableInt(0)

    var mDisplayWechatBind: ObservableBoolean = ObservableBoolean(false)
    var mCurrentSelectWechat = false

    var mMinLimitWithdraw: Double = 0.0 //提现最低起提金额，根据当前的用户角色，提现类型而变化
    var mMaxLimitWithdraw: Double? = null //提现最高可提金额，根据当前的用户角色，提现类型而变化
    var mInputCashNum: Double = 0.0 //输入的提现金额
    var mFrozenMoney: Double = 0.0  //冻结金额，从上一个界面带过来的
    var mTotalWithdraw = 0.0  //从服务器获取的可提现金额，可以发起提现的金额，需减去冻结金额 为mTotalWithdraw - mFrozenMoney

//    在小米手机上，这里设置了hint的字体为14，而在xml中设置text的字体是30，那么在edit没有输入字符时，会出现光标是14大小的
//    var mMinLimitWithdraw: Double by Delegates.observable(0.0) { _: KProperty<*>, _: Double, _: Double ->
//        tv_input_cash.hint = SpannedString(SpannableString("提现金额不可少于${mMinLimitWithdraw}元").apply {
//            setSpan(AbsoluteSizeSpan(14, true), 0, length, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE)
//        })
//    }


    var mTimer = Timer()

    var mTextWatcher = object : TextWatcher {
        override fun afterTextChanged(s: Editable?) {

            mInputCashNum = 0.0
            if (s.toString() != "." && s.toString().isNotEmpty()) {
                mInputCashNum = s.toString().toDouble()
                //提现手续费,支付手续费，代扣税，都是由服务端计算
                mTimer.cancel()
                mTimer.purge()
                mTimer = Timer()
                val task = timerTask {
                    viewModel.queryWithdrawTax(
                        mInputCashNum,
                        UserModel.mchBean?.mchType
                    )
                }
                // 0.5秒后发送消息
                mTimer.schedule(task, 500)
            }

        }

        override fun beforeTextChanged(s: CharSequence?, start: Int, count: Int, after: Int) {

        }

        override fun onTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) {

        }
    }


    override fun lazyInitView(view: View) {
        super.lazyInitView(view)
        viewModel.mCallback = this
        toolBar.setNavigationOnClickListener { close() }
        title.text = "提现"

        tv_input_cash.filters = Array(1) { CashierInputFilter() }
        tv_input_cash.addTextChangedListener(mTextWatcher)
        tv_total_cash.text = "可提现金额：${mTotalWithdraw}元"
        tv_withdraw_all.setOnClickListener {
            tv_input_cash.setText((mTotalWithdraw - mFrozenMoney).toString())
        }

        tv_frozen_money.visibility = if (mFrozenMoney > 0.0) View.VISIBLE else View.GONE
        tv_frozen_money.text = "账户冻结金额为${mFrozenMoney}元"

        registerEventBus()
    }

    @Volatile
    var mGetBankListSuccess = false
    @Volatile
    var mGetConfigSuccess = false

    override fun initData(savedInstanceState: Bundle?) {
        super.initData(savedInstanceState)
        viewModel.getBankListInfo()

        //获取起提金额
        viewModel.getConfig(Constants.CFG_WITHDRAW_ALL_HINT, UserModel.mchBean?.mchType.toString())

    }


    /**
     *  添加体现规则提示
     */
    private fun addHint(list: List<String>) {

        layout_withdraw_hint.removeAllViews()
        list.forEach {

            val tvLp = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                RelativeLayout.LayoutParams.WRAP_CONTENT
            )
            val tvMargin =
                TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 5f, resources.displayMetrics)
                    .toInt()
            tvLp.topMargin = tvMargin


            //动态添加 失败原因的标题
            val textView = TextView(context!!)
//            textView.draw
//            textView.typeface = Typeface.defaultFromStyle(Typeface.BOLD)
            textView.setCompoundDrawablesWithIntrinsicBounds(
                resources.getDrawable(R.drawable.shape_dot),
                null,
                null,
                null
            )
            textView.compoundDrawablePadding =
                TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 5f, resources.displayMetrics)
                    .toInt()
            textView.layoutParams = tvLp//设置布局参数
            textView.text = it
            textView.setTextColor(resources.getColor(R.color.tv_color))
            textView.textSize = 10f
            //设置行间距
//        textView.setLineSpacing(TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 10f, resources.displayMetrics),1f)
            layout_withdraw_hint.addView(textView)

        }
    }


    private fun displayBankInfo() {
        when (mBankCardBean.isPublic) {
            Constants.CARD_WECHAT_PAY -> {
                //设置微信头像
                loadCirclePic(
                    context!!,
                    mWechatInfo?.headUrl,
                    img_wechat_avatar,
                    R.drawable.ic_withdraw_wechat_default_portrait
                )
                //设置微信昵称
                tv_card_content.text = mWechatInfo?.nickname
            }

            Constants.CARD_PERSONAL -> {
                tv_card_content.text =
                    getString(com.xhd.td.R.string.person_card) + "(${mBankCardBean.bankId.substring(
                        mBankCardBean.bankId.length - 4,
                        mBankCardBean.bankId.length
                    )})"
            }
            Constants.CARD_COMPANY -> {
                tv_card_content.text =
                    getString(com.xhd.td.R.string.company_card) + "(${mBankCardBean.bankId.substring(
                        mBankCardBean.bankId.length - 4,
                        mBankCardBean.bankId.length
                    )})"
            }
        }

        mViewDataBinding.bean = mBankCardBean
        //切换提现方式后，设置不同的提现规则
        if (mCurrentSelectWechat) {

            //微信提现的最大和最小金额
            mMaxLimitWithdraw = mWithdrawAllHint?.wechat?.max?.div(100)?.toDouble()
            mMinLimitWithdraw = mWithdrawAllHint?.wechat?.min?.div(100)?.toDouble() ?: 0.0
            //微信提现的提示显示
            addHint(mWithdrawAllHint?.wechatHint?.plus(mWithdrawAllHint?.commonHint ?: listOf()) ?: listOf())

        } else {
            //银行卡提现的最大和最小金额
            mMaxLimitWithdraw = mWithdrawAllHint?.bank?.max?.div(100)?.toDouble()
            mMinLimitWithdraw = mWithdrawAllHint?.bank?.min?.div(100)?.toDouble() ?: 0.0

            //银行卡提现的提示显示
            addHint(
                mWithdrawAllHint?.bankHint?.plus(mWithdrawAllHint?.commonHint ?: listOf())
                    ?: listOf()
            )

        }
    }

    private fun checkInput(): Boolean {
        val inputCash = tv_input_cash.text.toString().apply {
            if (this.isEmpty() || this.startsWith(".")) {
                showToast("请输入提现金额")
                return false
            }
        }.toDouble()
        mInputCashNum = inputCash
        return when {

            inputCash > (mTotalWithdraw - mFrozenMoney) -> {
                showToast("冻结金额为${mFrozenMoney}元，实际可提现金额不足")
                false
            }

            inputCash > mMaxLimitWithdraw ?: Double.MAX_VALUE -> {
                showToast("提现金额必须小于最高可提金额")
                false
            }

            inputCash < mMinLimitWithdraw -> {
                showToast("提现金额必须大于最低起提金额")
                false
            }

            inputCash == 0.0 -> {
                showToast("提现金额不能为0")
                false
            }
            else -> true
        }
    }

    /**
     * 申请提现
     */
    fun startWithdraw() {
        if (checkInput()) {
            viewModel.applyWithdrawal(mBankCardBean.bankId, mInputCashNum)
        }
    }


    fun selectCard() {
        //选择提现的银行卡
        start(CardListFragment.newInstance(CardListFragment.TYPE_WITHDRAW_SELECT_CARD) { bank: Bank, wechatInfo ->
            pop()
            mBankCardBean = bank
            mWechatInfo = wechatInfo
            mCurrentSelectWechat = bank.isPublic == Constants.CARD_WECHAT_PAY
            displayBankInfo()
        })
    }

    fun bindWechatChange() {
        //绑定微信
        start(SocialFragment.newInstance(mMinLimitWithdraw))
    }


    fun addCard() {
        //一张银行卡都没有，才会在提现界面出现，添加银行卡的选项
        start(SelectBankAddCardFragment.newInstance())
    }


    /**
     * 处理rxBus数据
     */
    private fun registerEventBus() {

        BusProvider.getBus()?.toFlowable(EventMessage::class.java)!!
            .subscribe { eventMessage ->
                when (eventMessage.tag) {
                    EventKey.REFRESH_CARD_LIST -> {
                        viewModel.getBankListInfo()
                    }
                }
            }.addTo(viewModel.compositeDisposable)
    }


    override fun handleError(throwable: Throwable) {

    }

    override fun queryWithdrawTaxSuccess(bean: WithDrawFee) {
        //根据提现的金额，进行从小到大排序
        tv_withdraw_fee.visibility = View.VISIBLE
        tv_withdraw_fee.text = bean.tipsInfo
    }

    override fun queryWithdrawTaxFail(msg: String?) {
        msg?.let { showToast(it) }
        tv_withdraw_fee.visibility = View.GONE
    }


    private var mWithdrawAllHint: WithdrawAllHintBean? = null

    override fun getConfigSuccess(data: String?, key: String) {

        when (key) {

            Constants.CFG_WITHDRAW_ALL_HINT -> {
                mWithdrawAllHint =
                    Gson().fromJson<WithdrawAllHintBean>(data, WithdrawAllHintBean::class.java)
                mGetConfigSuccess = true
            }
        }

        if (mGetBankListSuccess && mGetConfigSuccess) {
            //重新显示界面
            displayBankInfo()
        }


    }

    override fun getConfigFail(msg: String?) {
        msg?.let { showToast(it) }
    }


    override fun applyWithdrawalSuccess(withdrawalResultBean: WithDrawResultBean) {
        BusProvider.getBus()?.post(EventMessage<Boolean>(EventKey.REFRESH_INCOME, false))
        startWithPop(WithdrawDetailFragment.newInstance(withdrawalResultBean))
    }

    override fun applyWithdrawalFail(msg: String?) {
        msg?.let { showToast(it) }
    }


    override fun getListSuccess(data: BankListBean) {

        mCardAmount.set(data.banks.size)
        if (data.banks.isNotEmpty()) {
            //银行卡信息不为空，去到提现界面,并
            //判断是否已经绑定了微信零钱
            var bank = data.banks.firstOrNull { bank -> bank.isPublic == Constants.CARD_WECHAT_PAY }
            if (bank == null) {
                bank = data.banks.first()
                mDisplayWechatBind.set(false)
                mCurrentSelectWechat = false
            } else {
                //有微信零钱
                mWechatInfo = data.tblUserUnionid
                mDisplayWechatBind.set(true)
                mCurrentSelectWechat = true
            }

            mBankCardBean = bank

            mGetBankListSuccess = true

            if (mGetBankListSuccess && mGetConfigSuccess) {
                //重新显示界面
                displayBankInfo()
            }
        }
    }

    override fun getListFail(msg: String?) {
        msg?.let { showToast(it) }

    }


    companion object {
        fun newInstance(totalWithdraw: Double?, frozenMoney: Double?) = WithdrawFragment()
            .apply {
                mTotalWithdraw = totalWithdraw ?: 0.0
                mFrozenMoney = frozenMoney ?: 0.0
            }
    }


}