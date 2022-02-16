// pages/mine/auth/auth.js
import { getAndSaveUserInfo, getMchInfo } from '../../../utils/user.js';
import { Api } from '../../../utils/api.js';

Page({

  /**
   * 页面的初始数据
   */
  data: {
    userInfo: null,
    hasPhone: false,
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    getAndSaveUserInfo().then(userInfo => {
      this.setData({
        userInfo,
      });
    });
    this.getUserDetail();
  },

  getUserDetail() {
    getMchInfo(true).then(mchInfo => {
      const { contactPhone } = mchInfo;
      this.setData({
        hasPhone: !!contactPhone
      });
    });
  },

  handleAuth() {
    const { hasPhone } = this.data;
    let url = '';
    if (hasPhone) {
      url = '../authPhone/authPhone';
    } else {
      url = '../authNoPhone/authNoPhone';
    }
    wx.navigateTo({
      url,
    });
  },

})