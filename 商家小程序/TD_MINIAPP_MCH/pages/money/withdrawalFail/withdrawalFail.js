// pages/money/withdrawalFail/withdrawalFail.js
import { Api } from '../../../utils/api.js';
import { makePhoneCall } from '../../../utils/util.js';

Page({

  /**
   * 页面的初始数据
   */
  data: {
    reason: '',
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    console.log(options);
    const {
      withdrawId,
    } = options;
    this.getWithdrawalDetail(withdrawId);
  },

  getWithdrawalDetail(withDrawId) {
    let data = {};
    Api.getWithdrawalDetail({
      withDrawId,
    }).then(res => {
      this.setData({
        reason: this.getReason(res.data),
      });
    }).catch(e => {
      console.log(e);
    });
  },

  getReason(data) {
    const { withdrawState, alarmCheckMessage, failedMsg } = data;
    let reason = '';
    if (withdrawState === -3) {
      reason = alarmCheckMessage || '';
    } else if (withdrawState === 3) {
      reason = failedMsg || '';
    }
    return reason;
  },

  makePhoneCall,
})