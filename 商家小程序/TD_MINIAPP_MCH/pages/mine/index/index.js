// pages/mine/index.js
import {
  getAndSaveUserInfo,
  checkIsAdmin,
} from '../../../utils/user.js';
import {
  openScanCode,
  showMessage,
} from '../../../utils/util.js';
import { Api } from '../../../utils/api.js';

Page({

  /**
   * 页面的初始数据
   */
  data: {
    userInfo: null,
    tipVisible: false,
    isAdmin: false,
    roleText: '',
    isChecked: false,
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function(options) {
    const {
      redirect,
    } = options;
    getAndSaveUserInfo().then(userInfo => {
      this.setData({
        userInfo,
        isChecked: true,
      });

      this.setRedirect(redirect);
      this.checkAuth();
    });
  },

  onShow() {
    !this.data.isChecked && this.checkAuth();
  },

  onHide() {
    this.setData({
      isChecked: false,
    });
  },

  checkAuth() {
    checkIsAdmin(true).then((res) => {
      let roleText = '';
      if (res === true) {
        roleText = '商户管理员';
      } else if (res === false) {
        roleText = '商户运营人员';
      }
      this.setData({
        isAdmin: res,
        roleText,
      });
    });
  },

  setRedirect(redirect) {
    if (!redirect) return;
    // redirect = 'bankInfo detail active reset
    if (redirect === 'reset') {
      setTimeout(this.openScanCode, 600);
    } else {
      wx.navigateTo({
        url: `../${redirect}/${redirect}`,
      });
    }
  },

  openScanCode() {
    openScanCode().then(res => {
      // console.log(res);
      const {
        result
      } = res;
      const deviceSn = result.split('?sn=')[1];
      if (deviceSn) {
        this.getDeviceInfo(deviceSn);
      } else {
        this.showError();
      }
    }).catch(e => {
      console.log(e);
    });
  },

  showError(msg = '扫码错误') {
    wx.showToast({
      title: msg,
      icon: 'none',
    });
  },

  getDeviceInfo(deviceSn) {
    Api.getResetCode({ deviceSn }).then(res => {
      const code = res.data;
      const code1 = code.substr(0, 5);
      const code2 = code.substr(5, 9);
      this.setData({
        code1,
        code2,
      });
      wx.navigateTo({
        url: `../reset/action/action?deviceSn=${deviceSn}&code1=${code1}&code2=${code2}`,
      });
    }).catch(e => {
      if (e.data && !e.data.msg) {
        showMessage('未知错误');
      }
      // setTimeout(wx.navigateBack, 2000);
    });
  },

  handleTipClick() {
    this.setData({
      tipVisible: true,
    });
  },

  handleOk() {
    this.setData({
      tipVisible: false,
    });
  },

})