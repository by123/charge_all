// pages/mine/activeDevice/activeDevice.js
import {
  openScanCode,
  showMessage,
  vaildateUrl,
} from '../../../utils/util.js';
import { Api } from '../../../utils/api.js';

Page({

  /**
   * 页面的初始数据
   */
  data: {
    activeTotal: 0,
    mchName: '',
    mchId: '',
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function(options) {
    this.getBusinessInfo();
  },

  handleCantinue() {
    this.handleScanCode();
  },

  handleScanCode() {
    openScanCode().then(res => {
      const {
        result
      } = res;

      // console.log(result, vaildateUrl(result));
      if (!vaildateUrl(result)) {
        showMessage('设备不存在');
        return;
      }
      const deviceSn = result.split('?sn=')[1];
      if (deviceSn) {
        this.setData({
          deviceSn,
        });
        this.activeDevice();
      }
    }).catch(e => {
      console.log(e);
    });
  },

  activeDevice() {
    let {
      deviceSn,
      mchId,
      activeTotal,
    } = this.data;
    const activeDeviceVo = {
      deviceSn,
      mchId,
    };
    // console.log(deviceSn);
    Api.activeDevice({
      ...activeDeviceVo,
    }).then(res => {
      showMessage('激活设备成功');
      this.setData({
        activeTotal: ++activeTotal,
      });
    }).catch(e => {
      console.log(e);
    });
  },

  getBusinessInfo() {
    Api.getUserInfo().then(res => {
      const {
        mch: {
          mchName,
          mchId,
        },
      } = res.data;
      this.setData({
        mchName,
        mchId,
      });

      setTimeout(this.handleScanCode, 500);
      // this.handleScanCode();
    }).catch(e => {
      console.log(e);
    });
  },

})