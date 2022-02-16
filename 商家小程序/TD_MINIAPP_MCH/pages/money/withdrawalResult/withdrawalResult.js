// pages/mine/withdrawalResult/withdrawalResult.js
import { makePhoneCall } from '../../../utils/util.js';
import { getUserData } from '../../../utils/user.js';

Page({

  /**
   * 页面的初始数据
   */
  data: {
    status: 'pending',
    errMsg: '',
    money: '',
    statusText: '',
    statusTip: '',
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    const { status = 'pending', errMsg = '', money = 0 } = options;
    this.setData({
      status,
      errMsg,
      money,
      userInfo: getUserData(),
    });
    this.generateText();
  },

  generateText() {
    const { status, errMsg, money, userInfo} = this.data;
    const textObj = {
      success: {
        statusText: `微信钱包（${userInfo.nickName}）到账：${money}元`,
        statusTip: '请到微信钱包查收提现金',
      },
      fail: {
        statusText: '提现失败',
        statusTip: `失败原因：${errMsg || '未知错误'}`,
      },
      pending: {
        statusText: '微信处理中',
        statusTip: '请耐心等待，最晚不超过1个工作日',
      }
    };

    const result = textObj[status];
    this.setData({
      statusText: result.statusText,
      statusTip: result.statusTip
    });
  },

  handleOk() {
    wx.switchTab({
      url: '../../money/index/index',
    })
  },

  handleContact() {
    makePhoneCall();
  }

})