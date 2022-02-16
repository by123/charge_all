// pages/mine/bindWechat/bindWechat.js
import { Api } from '../../../utils/api.js';
import { getAndSaveUserInfo } from '../../../utils/user.js';

let canClick = true;

Page({

  /**
   * 页面的初始数据
   */
  data: {
    bindModalVisible: false,
    userInfo: null,
    back: 1, // 绑定完成回退几个页面
    min: 0,
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    const { back = 1 } = options;
    this.setData({
      back: Number(back),
    });
    getAndSaveUserInfo().then((userInfo) => {
      this.setData({
        userInfo,
      });
    });
    this.getWithdrawalConfig();
  },

  handleBindWechat() {
    this.setData({
      bindModalVisible: true,
    });
  },

  handleCancel() {
    this.setData({
      bindModalVisible: false,
    });
  },

  handleOk() {
    if (!canClick) return;
    canClick = false;
    Api.bindWechat().then(() => {
      this.setData({
        bindModalVisible: false,
      });
      wx.showToast({
        title: '绑定成功',
      });
      setTimeout(() => {
        wx.navigateBack({
          delta: this.data.back,
        });
      }, 1500)
    }).catch(err => {
      this.setData({
        bindModalVisible: false,
      });
      canClick = true;
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
      });
    });
  },
})