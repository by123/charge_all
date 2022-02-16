// pages/mine/chooseType/chooseType.js
import { Api } from '../../../utils/api.js';

const categoryObj = {
  2: 'wechat',
  0: 'private',
  1: 'public',
};

Page({

  /**
   * 页面的初始数据
   */
  data: {
    category: 'wechat',
    startMoney: 0,
    canAddType: [],
    canAddWechat: false,
    canAddPublic: false,
    canAddPrivite: false,
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function(options) {
    let { canAddType = '2,1,0' } = options;
    canAddType = canAddType.split(',');
    this.setData({
      canAddType,
      category: categoryObj[canAddType[0]],
      canAddWechat: canAddType.indexOf('2') > -1,
      canAddPublic: canAddType.indexOf('1') > -1,
      canAddPrivite: canAddType.indexOf('0') > -1,
    });
    this.getWithdrawalConfig();
  },

  changeType: function(e) {
    let {
      category
    } = e.currentTarget.dataset;
    if (category !== this.data.category) {
      this.setData({
        category,
      });
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

  goNext: function() {
    let {
      category,
      needAuth,
    } = this.data;
    let url = '';
    if (needAuth) {
      url = '../auth/auth';
    } else {
      if (category === 'wechat') {
        url = '../bindWechat/bindWechat?back=2';
      } else {
        url = `../addBank/addBank?category=${category}`;
      }
    }
    
    wx.navigateTo({
      url,
    })
  },
})