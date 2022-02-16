// pages/mine/reset/action/action.js
import { makePhoneCall } from '../../../../utils/enum.js';
import { Api } from '../../../../utils/api.js';
import { showMessage } from '../../../../utils/util.js';

Page({

  /**
   * 页面的初始数据
   */
  data: {
    loading: false,
    deviceSn: '',
    code1: '00000',
    code2: '00000',
    videoSrc: 'http://xhdianapp.oss-cn-beijing.aliyuncs.com/action.mp4',
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    const { deviceSn, code1, code2 } = options;
    this.setData({
      deviceSn,
      code1,
      code2,
      videoEle: wx.createVideoContext('actionVideo'),
    });
  },

  handleContact() {
    makePhoneCall();
  },

  handleReset() {
    const { deviceSn } = this.data;
    this.setData({
      loading: true,
    });
    Api.confirmResetCode({
      deviceSn,
    }).then(res => {
      this.setData({
        loading: false,
      });
      wx.redirectTo({
        url: `../result/result?deviceSn=${deviceSn}`,
      });
    }).catch(e => {
      this.setData({
        loading: false,
      });
    });
  },
})