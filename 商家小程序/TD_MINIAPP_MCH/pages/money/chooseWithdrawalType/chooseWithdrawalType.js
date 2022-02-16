
import {
  Api
} from '../../../utils/api.js';
import {
  formatBankCode,
  getMoneyStart,
  getStorageItem,
  setStorageItem,
} from '../../../utils/util.js';
import {
  bankCardType,
  WITHDRAWAL_TYPE
} from '../../../utils/enum.js';
import {
  getAndSaveUserInfo
} from '../../../utils/user.js';

Page({

  /**
   * 页面的初始数据
   */
  data: {
    bankInfo: null,
    init: false,
    banks: null,
    userInfo: null,
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
  },

  getWithdrawalTypeIndex() {
    const isPublic = getStorageItem(WITHDRAWAL_TYPE);
    const {
      banks
    } = this.data;
    let index = 0;
    banks.forEach((bank, i) => {
      if (isPublic === bank.isPublic) {
        index = i;
        return false;
      }
    });
    banks[index].active = true;
    this.setData({
      banks,
    });
  },

  getWithdrawalConfig() {
    Api.getConfig({
      cfgKey0: 'withdraw_start_num',
      cfgKey1: '1'
    }).then(res => {
      let {
        cfgValue
      } = res.data;
      const min = Number(cfgValue) / 100;
      this.setData({
        startMoney: min,
      });
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
        this.setData({
          banks,
        });
        this.getWithdrawalTypeIndex();
      }
    }).catch(e => {
      this.setData({
        init: true,
      });
      console.log(e);
    });
  },

  handleToggle(e) {
    const {
      index
    } = e.currentTarget.dataset;
    let {
      banks
    } = this.data;

    if (banks[index].active) return;
    banks = banks.map(bank => {
      bank.active = false;
      return bank;
    });
    banks[index].active = true;
    setStorageItem(WITHDRAWAL_TYPE, banks[index].isPublic);
    this.setData({
      banks,
    });
    setTimeout(wx.navigateBack, 200);
  },

})