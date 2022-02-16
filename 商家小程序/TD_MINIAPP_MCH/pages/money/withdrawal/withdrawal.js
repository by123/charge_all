// pages/money/withdrawal/withdrawal.js
import { Api } from '../../../utils/api.js';
import {
  formatMoney,
  showMessage,
  formatBankCode,
  getStorageItem,
  setStoregeItem,
} from '../../../utils/util.js';
import { getAndSaveUserInfo, checkIsAdmin } from '../../../utils/user.js';
import { WITHDRAWAL_TYPE, bankCardType } from '../../../utils/enum.js';

let timeSpace = 10;
let timerId = null;

Page({

  /**
   * 页面的初始数据
   */
  data: {
    bankInfo: {},
    balance: 0,
    balanceText: '0.00',
    min: 0,
    fee: 0,
    withdrawalValue: '',
    loading: false,
    placeholderText: '',
    actualMoney: '0.00',
    hasBankInfo: false,
    withdrawalTimeDesc: '', //提现周期
    needRefresh: false,
    userInfo: null,
    hasWechat: true,
    isInit: false,
    modalVisible: false,
    count: timeSpace,
    isFocus: false,
    bottom: 80,
    needAuth: false,
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    this.getBankInfo();
    this.getWithdrawalRule();
    this.getWithdrawalConfig();
    this.getBalance();
    this.getWithdrawalTime();
    getAndSaveUserInfo().then(userInfo => {
      this.setData({
        userInfo,
      });
    });
    this.checkAuth();
  },

  onShow() {
    if (this.data.needRefresh) {
      this.getBankInfo();
    }
  },

  getWithdrawalBank(banks) {
    const withdrawalType = getStorageItem(WITHDRAWAL_TYPE);
    let bank = banks.filter(bank => {
      return bank.isPublic === withdrawalType;
    });

    if (bank.length) {
      bank = bank[0];
    } else {
      bank = banks[0];
    }
    return bank;
  },

  handleChooseType() {
    this.setData({
      needRefresh: true,
    });
    wx.navigateTo({
      url: '../chooseWithdrawalType/chooseWithdrawalType',
    });
  },

  getWithdrawalConfig() {
    Api.getConfig({
      cfgKey0: 'withdraw_start_num',
      cfgKey1: '1'
    }).then(res => {
      let { cfgValue } = res.data;
      const min = Number(cfgValue) / 100;
      this.setData({
        min,
        placeholderText: min > 0 ? `提现金额不可少于${min}元` : '请输入提现金额',
      });
    });
    Api.getConfig({
      cfgKey0: 'wxpay_max_withdraw_money',
      cfgKey1: '1'
    }).then(res => {
      let { cfgValue } = res.data;
      const max = Number(cfgValue) / 100;
      this.setData({
        max
      });
    });
  },

  getBankInfo() {
    wx.showLoading();
    Api.getBankInfo().then(res => {
      if (res.data && res.data.banks && res.data.banks.length) {
        const banks = res.data.banks;
        let bankInfo = this.getWithdrawalBank(banks);
        let {
          bankId,
          bankName,
          accountName,
          isPublic,
        } = bankInfo;
        let _accountName = isPublic !== 2 ? bankCardType[isPublic] : accountName;
        if (isPublic !== 2) {
          _accountName += `(${bankId.slice(-4)})`;
        }
        this.setData({
          bankInfo: {
            bankId,
            bankName,
            accountName,
            _accountName,
            isPublic,
          },
          isInit: true,
          hasBankInfo: true,
          hasWechat: this.checkHasWechat(banks),
        });
      }
      wx.hideLoading();
      this.setData({
        isInit: true,
      });
    }).catch(e => {
      this.setData({
        isInit: true,
      });
      wx.hideLoading();
      console.log(e);
    });
  },

  checkHasWechat(banks) {
    return banks.filter(bank => {
      return bank.isPublic === 2;
    }).length;
  },

  getWithdrawalRule() {
    Api.getWithdrawalRule().then(res => {
      this.setData({
        rules: this.formatWithdrawalRule(res.data),
      });
    }).catch(err => {
      console.log(err);
    });
  },

  bindWechat() {
    this.setData({
      needRefresh: true,
    });
    
    let url = '../../mine/bindWechat/bindWechat';
    if (this.data.needAuth) {
      url = '../../mine/auth/auth';
    }
    wx.navigateTo({
      url,
    });
  },

  getWithdrawalTime() {
    Api.getConfig({
      cfgKey0: 'withdraw_hint',
    }).then((res) => {
      let data = res.data;
      const { cfgValue } = data || {};
      this.setData({
        withdrawalTimeDesc: cfgValue,
      });
    }).catch(e => {
      console.log(e);
    });
    Api.getConfig({
      cfgKey0: 'withdraw_hint',
      cfgKey1: 'wechat',
    }).then((res) => {
      let data = res.data;
      const { cfgValue } = data || {};
      this.setData({
        withdrawalTimeDescWechat: cfgValue,
      });
    }).catch(e => {
      console.log(e);
    });
  },

  getBalance: function () {
    Api.getProfit().then((res) => {
      if (res.data) {
        let {
          canWithdrawNum,
        } = res.data;
        this.setData({
          balance: canWithdrawNum,
          balanceText: formatMoney(canWithdrawNum),
        });
      }
    });
  },

  handleInput(e) {
    const {
      value
    } = e.detail;
    this.setInput(value);
  },

  handleFocus() {
    let { hasWechat } = this.data;
    this.setData({
      isFocus: true,
      bottom: hasWechat ? 220 : 150,
    });
  },

  handleBlur() {
    this.setData({
      isFocus: false,
      bottom: 80,
    });
  },

  withdrawalAll() {
    const {
      balance,
    } = this.data;
    this.setInput(balance);
  },

  formatWithdrawalRule(rules) {
    return rules.sort((a, b) => {
      return a.withdrawStartNumYuan < b.withdrawStartNumYuan;
    });
  },

  getFee(withdrawalMoney) {
    const { rules } = this.data;
    let fee = 0;
    for (let i = 0, len = rules.length; i < len; i++) {
      let rule = rules[i];
      if (withdrawalMoney >= rule.withdrawStartNumYuan) {
        fee = rule.auxiliaryExpensesYuan;
        break;
      }
    }
    return fee;
  },

  setInput(withdrawalValue) {
    withdrawalValue = withdrawalValue >= 0 ? withdrawalValue : '';

    let _value = String(withdrawalValue).split('.');
    if (_value.length > 1 && _value[1].length > 2) {
      _value[1] = _value[1].substr(0, 2);
      withdrawalValue = _value.join('.');
    }
    const fee = this.getFee(Number(withdrawalValue))
    this.setData({
      withdrawalValue,
      fee,
      actualMoney: formatMoney(Math.max(Number(withdrawalValue) - fee, 0)),
    });
  },

  handleCancel() {
    wx.navigateBack();
  },

  handleWithdrawal() {
    if (this.data.loading) return;
    if (this.validateInput()) {
      const { bankInfo: { isPublic } } = this.data;
      if (isPublic === 2) {
        this.withdrawalToWechat();
      } else {
        this.withdrawalToBank();
      }
    }
  },

  withdrawalToBank() {
    this.setData({
      loading: true,
    });
    const {
      withdrawalValue,
      bankInfo,
    } = this.data;
    Api.withdrawal({
      withdrawMoney: withdrawalValue,
      bankId: bankInfo.bankId,
    }).then(res => {
      const { withdrawId } = res.data;
      showMessage('申请成功');
      setTimeout(() => {
        wx.redirectTo({
          url: `../withdrawalSuccess/withdrawalSuccess?withdrawId=${withdrawId}`,
        });
      }, 1500);
    }).catch(e => {
      console.log(e);
      this.setData({
        loading: false,
      });
    });
  },

  withdrawalToWechat() {
    this.showResultModal();
    this.setData({
      loading: true
    });
    const {
      withdrawalValue,
      bankInfo,
    } = this.data;
    Api.withdrawal({
      withdrawMoney: withdrawalValue,
      bankId: bankInfo.bankId,
    }).then(res => {
      const status = this.formatWithdrawalResultStatus(res.data);
      this.gowithdrawalResult(status, withdrawalValue, res.data.errMsg);
    }).catch(err => {
      console.log(err);
      clearInterval(timerId);
      this.setData({
        modalVisible: false,
        loading: false,
      });
    });
  },

  formatWithdrawalResultStatus(data) {
    const state = formatWithdrawalState(Number(data.withdraw_state)).code;
    let status = 'pending';
    switch (state) {
      case 0:
      case 1:
        status = 'pending';
        break;
      case 2:
        status = 'success';
        break;
      case 3:
        status = 'fail';
        break;
    }
    return status;
  },

  formatWithdrawalResultStatus(data) {
    const state = formatWithdrawalState(Number(data.withdraw_state)).code;
    let status = 'pending';
    switch (state) {
      case 0:
      case 1:
        status = 'pending';
        break;
      case 2:
        status = 'success';
        break;
      case 3:
        status = 'fail';
        break;
    }
    return status;
  },

  showResultModal() {
    this.setData({
      modalVisible: true,
    });
    this.startCount();
  },

  gowithdrawalResult(status, money, errMsg) {
    wx.navigateTo({
      url: `../withdrawalResult/withdrawalResult?status=${status}&money=${money}&errMsg=${errMsg}`,
    });
  },

  validateInput() {
    const {
      min,
      withdrawalValue,
      balance,
    } = this.data;
    let msg = '';
    if (!withdrawalValue || withdrawalValue < min) {
      msg = `提现金额不可少于${min}元`;
    } else if (balance < withdrawalValue) {
      msg = '提现金额不能大于可提现金额';
    }

    msg && wx.showModal({
      title: '提示',
      content: msg,
      showCancel: false,
    });

    return !msg;
  },

  addBank() {
    this.setData({
      needRefresh: true,
    });
    let url = '../../mine/chooseType/chooseType';
    if (this.data.needAuth) {
      url = "../../mine/auth/auth"
    }
    wx.navigateTo({
      url,
    });
  },

  checkAuth() {
    checkIsAdmin(true).then((res) => {
      this.setData({
        needAuth: res === null,
      });
    });
  },


  showResultModal() {
    this.setData({
      modalVisible: true,
    });
    this.startCount();
  },

  startCount() {
    let {
      count,
    } = this.data;

    timerId = setInterval(() => {
      --count;
      if (count < 0) {
        clearInterval(timerId);
        this.gowithdrawalResult('pending');
        this.setData({
          count: timeSpace
        });
      } else {
        this.setData({
          count,
        });
      }
    }, 1000);
  },

})