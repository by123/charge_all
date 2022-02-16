// pages/mine/bankInfo/bankInfo.js
import {
  Api
} from '../../../utils/api.js';
import {
  formatBankCode,
  getMoneyStart,
} from '../../../utils/util.js';
import { bankCardType } from '../../../utils/enum.js';
import { getAndSaveUserInfo, checkIsAdmin } from '../../../utils/user.js';

Page({

  /**
   * 页面的初始数据
   */
  data: {
    init: false,
    shouldRefresh: false,
    needAuth: false,
    banks: null,
    startMoney: 0, // 起提金额
    userInfo: null,
    canAddType: [0, 1, 2], // 可以继续添加的卡类型 0：对私 1：对公 2：微信
    canAddWechat: false, // 可以添加微信
    canAddBank: false, // 可以添加银行卡
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function(options) {
    this.getBankInfo();
    this.getWithdrawalConfig();

    getAndSaveUserInfo().then(userInfo => {
      this.setData({
        userInfo,
      });
    });

    this.checkAuth();
  },

  checkAuth() {
    checkIsAdmin(true).then((res) => {
      this.setData({
        needAuth: res === null,
      });
    });
  },

  onShow() {
    const {
      shouldRefresh,
    } = this.data;
    if (shouldRefresh) {
      this.getBankInfo();
      this.setData({
        shouldRefresh: false,
      });
      this.checkAuth();
    }
  },

  getWithdrawalConfig() {
    Api.getConfig({
      cfgKey0: 'withdraw_start_num',
      cfgKey1: '1'
    }).then(res => {
      let { cfgValue } = res.data;
      const min = Number(cfgValue) / 100;
      this.setData({
        startMoney: min,
      });
    });
  },

  addBank() {
    this.setData({
      shouldRefresh: true,
    });
    let url = `../chooseType/chooseType?canAddType=${this.data.canAddType}`;
    if (this.data.needAuth) {
      url = '../auth/auth';
    }
    wx.navigateTo({
      url,
    });
  },

  handleAddWechat() {
    this.setData({
      shouldRefresh: true,
    });
    let url = '../bindWechat/bindWechat';
    if (this.data.needAuth) {
      url = '../auth/auth';
    }
    wx.navigateTo({
      url,
    });
  },

  getBankInfo() {
    Api.getBankInfo().then(res => {
      this.setData({
        init: true,
      });
      if (res.data) {
        let {
          banks,
        } = res.data;
        if (banks) {
          banks = banks.map(bank => {
            bank._bankId = formatBankCode(bank.bankId);
            bank._type = bankCardType[bank.isPublic];
            return bank;
          });
        }
        let canAddType = this.calcCardCanAddType(banks)
        this.setData({
          banks,
          canAddType,
          canAddWechat: canAddType.indexOf(2) > -1,
          canAddBank: canAddType.indexOf(0) > -1 || canAddType.indexOf(1) > -1
        })
      }
    }).catch(e => {
      this.setData({
        init: true,
      });
      console.log(e);
    });
  }, 

  calcCardCanAddType(banks) {
    let result = [0, 1, 2];
    let canAddType = -2;
    banks.forEach(bank => {
      let index = result.indexOf(bank.isPublic);
      result.splice(index, 1);
    });

    return result;
  },

})