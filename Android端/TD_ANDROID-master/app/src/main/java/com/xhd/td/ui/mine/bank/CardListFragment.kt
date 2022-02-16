package com.xhd.td.ui.mine.bank

import android.os.Bundle
import android.view.View
import android.widget.RelativeLayout
import androidx.databinding.ObservableBoolean
import androidx.databinding.ObservableInt
import androidx.lifecycle.ViewModelProviders
import cn.xuexuan.mvvm.event.BusProvider
import cn.xuexuan.mvvm.extensions.addTo
import com.xhd.td.BR
import com.xhd.td.R
import com.xhd.td.adapter.mine.CardListAdapter
import com.xhd.td.base.BaseFragment
import com.xhd.td.constants.Constants
import com.xhd.td.constants.EventKey
import com.xhd.td.databinding.FragmentCardListBinding
import com.xhd.td.model.EventMessage
import com.xhd.td.model.bean.Bank
import com.xhd.td.model.bean.BankListBean
import com.xhd.td.model.bean.TblUserUnionid
import com.xhd.td.view.LoadMoreView
import com.xhd.td.vm.ViewModelProviderFactory
import com.xhd.td.vm.cb.income.WithdrawCB
import com.xhd.td.vm.income.WithdrawVM
import kotlinx.android.synthetic.main.fragment_card_list.*
import kotlinx.android.synthetic.main.title_bar.*
import javax.inject.Inject


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */

class CardListFragment : BaseFragment<FragmentCardListBinding, WithdrawVM, WithdrawCB>(), WithdrawCB {


    @Inject
    lateinit var factory: ViewModelProviderFactory
    override val bindingViewModel: Int get() = BR.viewModel
    override val bindingFragment: Int get() = BR.fragment
    override val layoutId: Int get() = R.layout.fragment_card_list
    override val viewModel: WithdrawVM get() = ViewModelProviders.of(this, factory).get(WithdrawVM::class.java)

    lateinit var mListLayout: LoadMoreView<Bank, CardListAdapter.BankHolder>
    var mHasWechat = false //是否显示添加微信零钱的选项
    var mHasPersonCard = false //是否显示添加个人银行的选项
    var mHasCompanyCard = false //是否显示添加对公账户的选项
    var mDisplayAddCard: ObservableBoolean = ObservableBoolean(false)
    var mType = 0
    lateinit var mItemCallback: (Bank, TblUserUnionid?) -> Unit
    var mCardAmount: ObservableInt = ObservableInt(0)
    var mTblUserUnionid: TblUserUnionid? = null

    override fun lazyInitView(view: View) {
        super.lazyInitView(view)
        viewModel.mCallback = this
        toolBar.setNavigationOnClickListener { close() }
        layout_no_card.visibility = View.GONE
        //创建adapter，并设置点击回调事件
        val listAdapter = CardListAdapter(context!!) { params: Bank -> mItemCallback(params, mTblUserUnionid) }


        mListLayout = LoadMoreView(context!!, listAdapter) { pageId: Int -> getList(pageId) }

        val view = mListLayout.initView()
        val lp = RelativeLayout.LayoutParams(
            RelativeLayout.LayoutParams.MATCH_PARENT, RelativeLayout.LayoutParams.MATCH_PARENT
        )

        lp.addRule(RelativeLayout.ALIGN_PARENT_LEFT)//与父容器的左侧对齐
        lp.addRule(RelativeLayout.ALIGN_PARENT_TOP)//与父容器的上侧对齐
//      view.setId(1)//设置这个View 的id
        view.layoutParams = lp//设置布局参数
        rl_content.addView(view)
        registerEventBus()

        if (mType == TYPE_VIEW_CARD_LIST) {
            title.text = "银行卡信息"
            //这里不显示添加银行卡的按钮，显示的逻辑交给mDisplayAddCard
//            btn_add_card.visibility = View.VISIBLE
        } else if (mType == TYPE_WITHDRAW_SELECT_CARD) {
            title.text = "选择提现方式"
            btn_add_card.visibility = View.GONE
        }

    }

    override fun initData(savedInstanceState: Bundle?) {
        super.initData(savedInstanceState)
        viewModel.getBankListInfo()
    }


    /**
     * 处理rxBus数据
     */
    private fun registerEventBus() {

        BusProvider.getBus()?.toFlowable(EventMessage::class.java)!!
            .subscribe { eventMessage ->
                when (eventMessage.tag) {
                    EventKey.REFRESH_CARD_LIST -> {
                        getList(START_PAGE_ID)
                    }
                }
            }.addTo(viewModel.compositeDisposable)
    }

    fun addCard() {
        start(SelectBankAddCardFragment.newInstance(mHasWechat,mHasPersonCard,mHasCompanyCard))
    }

    private fun getList(pageId: Int) {

        if (pageId == START_PAGE_ID) {
            mListLayout.clearData()
        }
        viewModel.getBankListInfo()
    }


    override fun getListSuccess(data: BankListBean) {
        //根据分页的数量和总数据是否为0 ，显示不同的界面
        mListLayout.setTotal(data.banks.size)
        mCardAmount.set(data.banks.size)
        mListLayout.mAdapter.addData(data.banks)
        data.banks.map { bank ->
            when (bank.isPublic) {
                Constants.CARD_WECHAT_PAY -> mHasWechat = true
                Constants.CARD_PERSONAL -> mHasPersonCard = true
                Constants.CARD_COMPANY -> mHasCompanyCard = true
            }
        }
        mDisplayAddCard.set((!(mHasWechat && mHasPersonCard && mHasCompanyCard)) && mType == TYPE_VIEW_CARD_LIST)
        mTblUserUnionid = data.tblUserUnionid
        mTblUserUnionid?.let { (mListLayout.mAdapter as CardListAdapter).setWechatInfo(it) }
    }

    override fun getListFail(msg: String?) {
        msg?.let { showToast(it) }
        mListLayout.setRefreshState(false)
    }


    override fun handleError(throwable: Throwable) {

    }


    companion object {
        fun newInstance(type: Int, itemCallback: (Bank, TblUserUnionid?) -> Unit) =
            CardListFragment().apply { mType = type;mItemCallback = itemCallback }

        const val START_PAGE_ID = 1
        const val TYPE_VIEW_CARD_LIST = 1
        const val TYPE_WITHDRAW_SELECT_CARD = 2
    }


}