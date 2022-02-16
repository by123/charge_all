// pages/mine/reset/result/result.js
import { makePhoneCall } from '../../../../utils/util.js';
Page({

  /**
   * 页面的初始数据
   */
  data: {
    deviceSn: '',
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    const { deviceSn } = options;
    this.setData({
      deviceSn
    });
  },

  handleContact() {
    makePhoneCall(); 
  },
})