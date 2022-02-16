// pages/mine/detail/detail.js
import { Api } from '../../../utils/api.js';
import {
  formatTime,
  makePhoneCall,
} from '../../../utils/util.js';
import { getMchInfo } from '../../../utils/user.js';

Page({

  /**
   * 页面的初始数据
   */
  data: {
    accountData: null,
    profitData: null,
    deviceData: null,
    numberData: null,
    salesPhone: '',
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad(options) {
    this.getDetail();
  },

  getSalesPhone(mchInfo) {
    const { mchId } = mchInfo;
    Api.getUserContactPhone({
      mchId,
    }).then(res => {
      this.setData({
        salesPhone: res.data,
      });
    });
  },

  getDetail() {
    wx.showLoading();
    Api.getUserInfo().then((res) => {
      let data = res.data;

      this.setData({
        accountData: this.generateAccount(data.mch || {}),
        profitData: this.generateProfit(data.mch || {}),
        deviceData: this.generateDevice(data),
        numberData: this.generatePhone(data.mch),
      });
      this.getSalesPhone(data.mch);
      wx.hideLoading();
    }).catch(e => {
      wx.hideLoading();
      console.log(e);
    });
  },

  generateAccount(data) {
    let address = '';
    const {
      area,
      city,
      province,
      mchName,
      industry,
      contactUser,
      createTime,
      settementPeriod,
      detailAddr,
    } = data;
    address += province ? province + '省' : '';
    address += city ? city + '市' : '';
    address += area ? area : '';
    address += detailAddr ? detailAddr : '';

    return {
      title: '账户信息',
      content: [
        [{
            name: '商户名称',
            value: mchName
          },
          {
            name: '所属行业',
            value: industry,
          },
          {
            name: '联系人姓名',
            value: contactUser || '',
          },
          {
            name: '地理位置',
            value: address,
          },
          {
            name: '结算周期',
            value: settementPeriod ? 'T+' + (settementPeriod) : '',
          },
          {
            name: '账号创建日期',
            value: formatTime(createTime, true, true),
          },
        ],
      ],
    }
  },

  generateProfit(data) {
    return {
      title: '商户分润',
      content: [
        [{
          name: '分润比例',
          value: (data.totalPercent || 0) + '%',
        }],
      ],
    };
  },

  generatePhone(data) {
    return {
      title: '认证手机号',
      content: [
        [{
          name: '手机号码',
          value: data.contactPhone,
        }],
      ],
    };
  },

  generateDevice(data) {

    return {
      title: '设备信息',
      content: [
        [{
          name: '设备总数',
          value: data.total || 0,
        }, {
          name: '设备激活数',
          value: data.activeTotal || 0,
        }],
      ],
    }
  },

  handleContact() {
    const { salesPhone } = this.data;
    if (!salesPhone) {
      wx.showToast({
        title: '手机号不正确',
      })
      return;
    }
    makePhoneCall(this.data.salesPhone);
  },

})