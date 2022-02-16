package com.xhd.td.di.builder;

import com.xhd.td.ui.MainActivity;
import com.xhd.td.ui.MainFragment;
import com.xhd.td.ui.home.*;
import com.xhd.td.ui.income.*;
import com.xhd.td.ui.login.ForgetPwdFragment;
import com.xhd.td.ui.login.LoginFragment;
import com.xhd.td.ui.login.SplashFragment;
import com.xhd.td.ui.map.MapFragment;
import com.xhd.td.ui.mine.*;
import com.xhd.td.ui.mine.bank.AddCardFragment;
import com.xhd.td.ui.mine.bank.CardDetailFragment;
import com.xhd.td.ui.mine.bank.CardListFragment;
import com.xhd.td.ui.mine.bank.SelectBankAddCardFragment;
import com.xhd.td.ui.order.OrderDetailFragment;
import com.xhd.td.ui.order.OrderFragment;
import com.xhd.td.ui.order.RefundFragment;
import com.xhd.td.ui.order.SearchOrderFragment;
import com.xhd.td.ui.social.SocialFragment;
import com.xhd.td.ui.taxi.AddGroupSuccessFragment;
import com.xhd.td.ui.taxi.ScanTaxiActivateDeviceFragment;
import com.xhd.td.ui.taxi.TaxiGroupFragment;
import com.xhd.td.ui.taxi.TaxiListFragment;
import com.xhd.td.ui.unbind.ScanUnbindDeviceFragment;
import com.xhd.td.ui.unbind.UnbindFragment;
import com.xhd.td.ui.unbind.UnbindMerchantDeviceFragment;
import com.xhd.td.ui.unbind.UnbindResultFragment;
import com.xhd.td.ui.whitelist.*;
import dagger.Module;
import dagger.android.ContributesAndroidInjector;

/**
 * Created by amitshekhar on 14/09/17.
 */
@Module
public abstract class ActivityBuilder {

//    @ContributesAndroidInjector(modules = {
//            FeedActivityModule.class,
//            BlogFragmentProvider.class,
//            OpenSourceFragmentProvider.class})
//    abstract FeedActivity bindFeedActivity();

    @ContributesAndroidInjector
    abstract MainActivity bindMainActivity();

    @ContributesAndroidInjector
    abstract MainFragment bindMainFragment();

    @ContributesAndroidInjector
    abstract HomeFragment bindHomeFragment();

    @ContributesAndroidInjector
    abstract LoginFragment bindLoginFragment();

    @ContributesAndroidInjector
    abstract SplashFragment bindSplashFragment();

    @ContributesAndroidInjector
    abstract ForgetPwdFragment bindForgetPwdFragment();

    @ContributesAndroidInjector
    abstract AddMerchantFragment bindAddMerchantFragment();

    @ContributesAndroidInjector
    abstract AddMerchantSuccessFragment bindAddMerchantSuccessFragment();

    @ContributesAndroidInjector
    abstract AddAgentAndChainFragment bindAddAgentAndChainFragment();

    @ContributesAndroidInjector
    abstract AddSalesmanFragment bindAddSalesmanFragment();

    @ContributesAndroidInjector
    abstract SelectMerchantFragment bindSelectMerchantFragment();

    @ContributesAndroidInjector
    abstract ScanActivateDeviceFragment bindActivateDeviceFragment();

    @ContributesAndroidInjector
    abstract IncomeFragment bindIncomeFragment();

    @ContributesAndroidInjector
    abstract ScanBindMerchantFragment bindBindMerchantFragment();

    @ContributesAndroidInjector
    abstract ScanDeviceResetFragment bindScanDeviceResetFragment();

    @ContributesAndroidInjector
    abstract DeviceResetFragment bindDeviceResetFragment();

    @ContributesAndroidInjector
    abstract PerformanceFragment bindPerformanceFragment();

    @ContributesAndroidInjector
    abstract TotalMerchantFragment bindMerchantTotalFragment();

    @ContributesAndroidInjector
    abstract TotalActivateDeviceFragment bindTotalActivateDeviceFragment();


    @ContributesAndroidInjector
    abstract CapitalHelpFragment bindCapitalHelpFragment();

    @ContributesAndroidInjector
    abstract IncomeListFragment bindIncomeListFragment();

    @ContributesAndroidInjector
    abstract WithdrawListFragment bindWithdrawListFragment();

    @ContributesAndroidInjector
    abstract IncomeDetailFragment bindIncomeDetailFragment();


    @ContributesAndroidInjector
    abstract SourceOfIncomeFragment bindSourceOfIncomeFragment();

    @ContributesAndroidInjector
    abstract DeviceOfIncomeFragment bindDeviceOfIncomeFragment();


    @ContributesAndroidInjector
    abstract WithdrawDetailFragment bindWithdrawDetailFragment();


    @ContributesAndroidInjector
    abstract SelectBankAddCardFragment bindSelectBankAddCardFragment();

    @ContributesAndroidInjector
    abstract AddCardFragment bindAddCardFragment();

    @ContributesAndroidInjector
    abstract WithdrawFragment bindWithdrawFragment();

    @ContributesAndroidInjector
    abstract OrderFragment bindOrderFragment();

    @ContributesAndroidInjector
    abstract SearchOrderFragment bindSearchOrderFragment();

    @ContributesAndroidInjector
    abstract OrderDetailFragment bindOrderDetailFragment();

    @ContributesAndroidInjector
    abstract RefundFragment bindRefundFragment();


    @ContributesAndroidInjector
    abstract MineFragment bindMineFragment();


    @ContributesAndroidInjector
    abstract AccountFragment bindAccountFragment();


    @ContributesAndroidInjector
    abstract CardDetailFragment bindCardDetailFragment();


    @ContributesAndroidInjector
    abstract SettingFragment bindSettingFragment();

    @ContributesAndroidInjector
    abstract EditPwdFragment bindEditPwdFragment();


    @ContributesAndroidInjector
    abstract AboutFragment bindAboutFragment();

    @ContributesAndroidInjector
    abstract UserProtocolFragment bindUserProtocolFragment();


    @ContributesAndroidInjector
    abstract AgentManageFragment bindManageAgentFragment();


    @ContributesAndroidInjector
    abstract AgentMerchantDetailFragment bindAgentDetailFragment();

    @ContributesAndroidInjector
    abstract EditAgentAndChainFragment bindEditAgentAndChainFragment();

    @ContributesAndroidInjector
    abstract EditMerchantFragment bindEditMerchantFragment();

    @ContributesAndroidInjector
    abstract WhitelistFragment bindWhitelistFragment();

    @ContributesAndroidInjector
    abstract SelectWhitelistFragment bindSelectWhitelistFragment();

    @ContributesAndroidInjector
    abstract WhitelistRecordFragment bindWhitelistRecordFragment();

    @ContributesAndroidInjector
    abstract TaxiGroupFragment bindGroupFragment();

    @ContributesAndroidInjector
    abstract TaxiListFragment bindTaxiListFragment();

    @ContributesAndroidInjector
    abstract AddGroupSuccessFragment bindAddGroupSuccessFragment();

    @ContributesAndroidInjector
    abstract ScanTaxiActivateDeviceFragment bindScanTaxiActivateDeviceFragment();

    @ContributesAndroidInjector
    abstract SocialFragment bindSocialFragment();

    @ContributesAndroidInjector
    abstract CardListFragment bindCardListFragment();

    @ContributesAndroidInjector
    abstract UnbindFragment bindUnbindingFragment();

    @ContributesAndroidInjector
    abstract UnbindMerchantDeviceFragment bindUnbindMerchantDeviceFragment();

    @ContributesAndroidInjector
    abstract ScanUnbindDeviceFragment bindScanUnbindDeviceFragment();

    @ContributesAndroidInjector
    abstract UnbindResultFragment bindUnbindResultFragment();

    @ContributesAndroidInjector
    abstract MapFragment bindMapFragment();

    @ContributesAndroidInjector
    abstract SelectWhitelistTimeFragment bindSelectWhitelistTimeFragment();

    @ContributesAndroidInjector
    abstract EditWhitelistFragment bindEditWhitelistFragment();


    @ContributesAndroidInjector
    abstract TotalDeviceIncomeFragment bindTotalDeviceIncomeFragment();

    @ContributesAndroidInjector
    abstract MessageListFragment bindMessageListFragment();

    @ContributesAndroidInjector
    abstract MessageDetailFragment bindMessageDetailFragment();
}
