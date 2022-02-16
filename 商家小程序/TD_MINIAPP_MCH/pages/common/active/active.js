// pages/active/active.js
import { Api } from '../../../utils/api.js';
import Http from '../../../utils/http.js';
import { wxLogin, checkIsActive } from '../../../utils/user.js';
import { removeStorageItem } from '../../../utils/util.js';

Page({

  /**
   * 页面的初始数据
   */
  data: {
    qrCode: '',
    needRefresh: true,
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    this.getQrCode();
  },

  onHide: function () {
    this.data.needRefresh && this.removeToken();
  },

  removeToken() {
    removeStorageItem('token');
  },

  getQrCode: function () {
    Api.getQrCode().then((res) => {
      this.setData({
        qrCode: `data:image/png;base64,${res.data}`
      });
    });
  },

  checkBind: function () {
    wx.showLoading();
    wxLogin().then((res) => {
      wx.hideLoading();
      if (checkIsActive()) {
        this.setData({
          needRefresh: false,
        });
        wx.reLaunch({
          url: '/pages/money/index/index',
        })
      } else {
        this.confirmBind();
      }
    }).catch(e => {
      console.log(e);
      wx.hideLoading();
    });
  },

  confirmBind: function () {
    wx.hideToast();
    wx.showModal({
      title: '提示',
      content: '您的商户账号还未绑定，请联系代理商',
      showCancel: false,
    })
  }
})