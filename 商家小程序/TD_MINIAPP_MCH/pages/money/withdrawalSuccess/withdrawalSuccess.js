// pages/money/withdrawalSuccess/withdrawalSuccess.js
import { Api } from '../../../utils/api.js';
import {
  formatMoney,
  dateFormatter,
} from '../../../utils/util.js';

Page({

  /**
   * 页面的初始数据
   */
  data: {
    withdrawalInfo: {},
    status: 0,
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function(options) {
    console.log(options);
    const {
      withdrawId
    } = options;
    this.getWithdrawalDetail(withdrawId);
  },

  getWithdrawalDetail(withDrawId) {
    let data = {};
    Api.getWithdrawalDetail({
      withDrawId,
    }).then(res => {
      this.setData({
        withdrawalInfo: this.generateListData(res.data),
        status: this.formatStatus(res.data.withdrawState),
      });
    }).catch(e => {
      console.log(e);
    });
  },

  checkHistory() {
    wx.switchTab({
      url: '../../money/index/index',
    })
  },

  generateListData(data) {
    const {
      bankId,
      withdrawMoneyYuan,
      auxiliaryExpensesYuan,
      createTime,
      bank_orderid,
      accountName,
      withdrawMoneyTotalYuan,
    } = data;
    let list = [{
        name: '提现卡号',
        value: bankId,
      }, {
        name: '提现账户名',
        value: accountName,
      }, {
        name: '提现金额',
        value: `${formatMoney(withdrawMoneyTotalYuan)}元`,
      },
      {
        name: '手续费',
        value: `${formatMoney(auxiliaryExpensesYuan)}元`,
      },
      {
        name: '实际到账',
        value: `${formatMoney(withdrawMoneyYuan)}元`,
      }, 
      {
        name: '申请时间',
        value: dateFormatter(createTime, 'yyyy-MM-dd hh:mm:ss'),
      },
    ];

    bank_orderid && (list.concat([{
      name: '银行流水号',
      value: bank_orderid,
    }, ]));

    return list;
  },

  formatStatus(status) {
    let result = 0;
    switch (status) {
      case -3:
      case 3:
        result = 0;
        break;
      case -2:
      case -1:
      case 0:
      case 1:
      case 4:
        result = 1;
        break;
      case 2:
        result = 2;
        break;
    }
    return result;
  },

})