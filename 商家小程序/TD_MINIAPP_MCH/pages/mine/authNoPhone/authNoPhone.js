// pages/mine/authNoPhone/authNoPhone.js

import { makePhoneCall } from '../../../utils/util.js';
import { Api } from '../../../utils/api.js';
import { getAndSaveUserInfo, getMchInfo } from '../../../utils/user.js';

Page({

  /**
   * 页面的初始数据
   */
  data: {
    salesPhone: '',
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    this.getSalesPhone();
  },

  getSalesPhone() {
    getMchInfo().then(mchInfo => {
      const { mchId } = mchInfo;
      Api.getUserContactPhone({
        mchId,
      }).then(res => {
        this.setData({
          salesPhone: res.data,
        });
      });
    });
  },

  handleContact() {
    const { salesPhone } = this.data;
    if (salesPhone) {
      makePhoneCall(salesPhone);
    } else {
      wx.showToast({
        title: '未获取到手机号',
        icon: 'none',
      })
    }
  },
})