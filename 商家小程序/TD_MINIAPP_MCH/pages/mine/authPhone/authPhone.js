// pages/mine/authPhone/authPhone.js
import {
  getAndSaveUserInfo,
  getMchInfo,
} from '../../../utils/user.js';
import {
  makePhoneCall
} from '../../../utils/util.js';
import {
  Api
} from '../../../utils/api.js';

let timer = null;
let timeSpace = 60;

Page({

  /**
   * 页面的初始数据
   */
  data: {
    disable: true,
    userInfo: null,
    focusList: [false, false, false, false, false, false],
    dataList: '',
    isFocus: false,
    contactPhone: '',
    salesPhone: '',
    time: timeSpace,
    timeText: '获取验证码',
    canSendCode: true,
    modalVisible: false,
    errMsg: '您的验证码有误，请重新认证。如手机号有误，请联系业务员更改',
    loading: false,
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function(options) {
    getAndSaveUserInfo().then(userInfo => {
      this.setData({
        userInfo,
      });
    });
    this.getPhone();
    this.getSalesPhone();
  },

  handleInput(e) {
    const { value } = e.detail;
    const dataList = value.slice(0, 6);
    this.setData({
      dataList,
      disable: dataList.length !== 6,
    });
  },

  handleTabInput() {
    this.setData({
      isFocus: true,
    });
  },

  handleCloseInput() {
    this.setData({
      isFocus: false,
    });
  },

  getPhone() {
    getMchInfo(true).then(mchInfo => {
      const {
        contactPhone
      } = mchInfo;
      this.setData({
        contactPhone,
      });
    });
  },

  getSalesPhone() {
    getMchInfo().then(mchInfo => {
      const {
        mchId
      } = mchInfo;
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
    this.setData({
      modalVisible: false,
    });
    const {
      salesPhone
    } = this.data;
    if (salesPhone) {
      makePhoneCall(salesPhone);
    } else {
      wx.showToast({
        title: '未获取到业务员手机号',
        icon: 'none',
      });
    }
  },

  showAuthSuccess() {
    wx.showModal({
      title: '认证通过',
      content: '您已成功认证为管理员账号',
      showCancel: false,
      success: function(e) {
        if (e.confirm) {
          wx.navigateBack({
            delta: 2,
          })
        }
      }
    });
  },

  showAuthFail(errMsg) {
    errMsg = errMsg || '您的验证码有误，请重新认证。如手机号有误，请联系业务员更改';
    this.setData({
      errMsg,
      modalVisible: true,
    });
  },

  handleCancel() {
    this.setData({
      modalVisible: false,
    });
  },

  handleSubmit() {
    this.setData({
      loading: true,
    });
    const {
      dataList,
      contactPhone
    } = this.data;
    Api.auth({
      code: dataList,
      mobile: contactPhone,
    }).then(res => {
      this.showAuthSuccess();
      this.setData({
        loading: false,
      });
    }).catch(e => {
      const msg = e.data ? e.data.msg : '';
      wx.hideToast();
      this.showAuthFail(msg);
      this.setData({
        loading: false,
      });
    });
  },
  
  onHide() {
    clearInterval(timer);
  },

  handleSendCode() {
    const {
      canSendCode
    } = this.data;
    if (!canSendCode) return;
    this.setData({
      canSendCode: false,
    });
    this.sendCode();
  },

  sendCode() {
    Api.getVerificationCode({
      mobile: this.data.contactPhone,
    }).then(res => {
      this.startTimer();
    });
  },

  startTimer() {
    clearInterval(timer);
    this.setData({
      timeText: `${this.data.time}S`,
    });
    timer = setInterval(() => {
      if (this.data.time == 0) {
        clearInterval(timer);
        this.setData({
          canSendCode: true,
          timeText: '发送验证码',
          time: timeSpace,
        });
      } else {
        let time = this.data.time - 1;
        this.setData({
          time,
          timeText: `${time}S`,
        });
      }
    }, 1000);
  }

})