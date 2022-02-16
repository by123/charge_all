// pages/mine/bankDetail/bankDetail.js
import { Api } from '../../../utils/api.js';
import {
  formatBankCode,
} from '../../../utils/util.js';

Page({

  /**
   * 页面的初始数据
   */
  data: {
    detailList: [],
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function(options) {
    this.getBankInfo();
  },

  getBankInfo() {
    Api.getBankInfo().then(res => {
      this.setData({
        init: true,
      });
      if (res.data) {
        this.setData({
          detailList: this.generateDetailList(res.data),
        });
      }
    }).catch(e => {
      this.setData({
        init: true,
      });
      console.log(e);
    });
  },

  generateDetailList(data) {
    let {
      bankId,
      bankName,
      accountName,
      isPublic,
      cityCode,
      bankBranch,
      cityName = '',
    } = data;

    bankId = formatBankCode(bankId);
    isPublic = !!isPublic;
    var list = [{
      name: '账户类型：',
      value: `对${isPublic ? '公' : '私'}银行账户`
    }, ];

    if (isPublic) {
      list = list.concat([{
        name: '账户名称：',
        value: accountName,
      }, {
        name: '银行对公账户：',
        value: bankId,
      }, {
        name: '开户银行：',
        value: bankName,
      }, {
        name: '支行名称：',
        value: bankBranch,
      }, {
        name: '开户行所在地：',
        value: cityName || '',
      }, ]);
    } else {
      list = list.concat([{
        name: '开卡人姓名：',
        value: accountName,
      }, {
        name: '银行卡号：',
        value: bankId,
      }, {
        name: '开户银行：',
        value: bankName,
      }, ]);
    }

    return list;
  },

})