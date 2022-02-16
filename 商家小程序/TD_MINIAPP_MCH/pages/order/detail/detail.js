// pages/order/detail/detail.js
import { Api } from '../../../utils/api.js';
import {
  orderStatus,
  payTypeObj,
  refundStatus,
  depositRefundStatus,
} from '../../../utils/enum.js';
import {
  formatTime,
  moneyAddPre,
} from '../../../utils/util.js';

Page({

  /**
   * 页面的初始数据
   */
  data: {
    orderData: null,
    profitData: null,
    tradeData: null,
    deviceData: null,
    depositData: null,
    refundData: null,
    orderState: -1,
    canRefund: false,

    shouldRefresh: false,
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function(options) {
    const {
      orderId
    } = options;
    this.setData({
      orderId,
    });
    this.getDetail(orderId);
  },

  onShow() {
    const {
      shouldRefresh,
      orderId
    } = this.data;
    if (shouldRefresh) {
      this.setData({
        shouldRefresh: false,
      });
      this.getDetail(orderId);
    }
  },

  getDetail(orderId) {
    wx.showLoading();
    Api.getOrderDetail({
      orderId,
    }).then((res) => {
      let data = res.data.tblOrder;
      data = {
        ...res.data,
        ...res.data.tblOrder,
      };
      // console.log('detail', data);

      this.setData({
        orderState: data.orderStateWeb,
        canRefund: data.canRefund,
        orderData: this.formatOrderData(data),
        profitData: this.formatProfitData(data),
        tradeData: this.formatTradeData(data),
        deviceData: this.formatDeviceData(data),
        depositData: this.formatDepositData(data),
        refundData: this.formatRefundData(data),
      });

      wx.hideLoading();
    }).catch(e => {
      wx.hideLoading();
      console.log(e);
    });
  },

  handleRefund: function() {
    const {
      orderId
    } = this.data;
    this.setData({
      shouldRefresh: true,
    });
    wx.navigateTo({
      url: `../refund/refund?orderId=${orderId}`,
    });
  },

  // 订单信息
  formatOrderData(data) {
    let orderState = data.orderStateWeb;
    // console.log(orderState);
    let orderIdData = [{
        name: '订单状态',
        value: orderStatus[orderState],
      },
      {
        name: '下单时间',
        value: formatTime(data.createTime, true, true),
      },
      {
        name: '用户微信ID',
        value: data.userName || '',
      },
    ];

    if ([2, 3, 5, 6].indexOf(orderState) > -1) {
      orderIdData.push({
        name: '充电开始时间',
        value: formatTime(data.startTime, true, true),
      });
    }

    if ([3, 5, 6].indexOf(orderState) > -1) {
      orderIdData.push({
        name: '充电结束时间',
        value: formatTime(data.endTime, true, true),
      });
    }

    let orderData = {
      content: [
        [{
          name: '订单编号',
          value: data.orderId,
          customStyle: {
            name: 'font-weight: 500; color: #353648;',
          },
        }, ],
        orderIdData,
      ],
    };
    return Object.assign({}, orderData);
  },

  // 分润信息
  formatProfitData(data) {
    return {
      title: '分润信息',
      content: [
        [{
          name: '我的收益',
          value: moneyAddPre(data.myProfilt),
        }, ],
      ],
    };
  },

  // 设备信息
  formatDeviceData(data) {
    return {
      title: '设备信息',
      content: [
        [{
          name: '设备编号',
          value: data.deviceSn || '',
        }, ],
      ],
    };
  },

  // 交易信息
  formatTradeData(data) {
    let orderState = data.orderStateWeb;
    let tradeContent = [];

    if ([1, 4].indexOf(orderState) > -1) {
      tradeContent = [{
        name: '待支付金额',
        value: moneyAddPre(data.orderPriceYuan),
      }];
    } else {
      let transactionId = '';

      if (data.transactionId) {
        let tmp = data.transactionId.split('');
        tmp.splice(Math.round(tmp.length / 2), 0, '\n');
        transactionId = tmp.join('');
      }

      tradeContent = [{
          name: '订单金额',
          value: moneyAddPre(data.orderPriceYuan),
        },
        {
          name: '订单支付时间',
          value: formatTime(data.payTime, true, true),
        },
        {
          name: '订单支付方式',
          value: payTypeObj[data.payType],
        },
        {
          name: '订单支付流水',
          value: transactionId,
        },
      ];
    }

    return {
      title: '交易信息',
      content: [tradeContent],
    }
  },

  // 押金信息
  formatDepositData(data) {
    let orderState = data.orderStateWeb;
    let depositState = orderState === 2 ? '未返还' :
      orderState === 3 ? '已返还' : depositRefundStatus[data.refundDepositState];

    if ([2, 3, 5, 6].indexOf(orderState) > -1) {
      let depositContent = [{
          name: '设备押金',
          value: moneyAddPre(data.pledgeRuan || 0),
        },
        {
          name: '押金状态',
          value: depositState,
        },
      ];

      if ([3, 5, 6].indexOf(orderState) > -1) {
        depositContent.push({
          name: '押金退款时间',
          value: formatTime(data.refundDepositTime, true, true),
        });
        depositContent.push({
          name: '押金退款方式',
          value: payTypeObj[data.payType],
        });
        depositContent.push({
          name: '押金退款流水',
          value: data.refundDepositId,
        });
      }

      let depositData = {
        title: '押金信息',
        content: [depositContent],
      };

      return depositData;
    } else {
      return null;
    }

  },

  // 退款信息
  formatRefundData(data) {
    let orderState = data.orderStateWeb;
    if ([5, 6].indexOf(orderState) > -1) {
      let refundData = {
        title: '退款信息',
        content: [
          [{
              name: '退款金额',
              value: moneyAddPre(data.refundMoneyYuan),
            },
            {
              name: '退款时间',
              value: formatTime(data.refundTime, true, true),
            },
            {
              name: '退款方式',
              value: payTypeObj[data.payType],
            },
            {
              name: '退款流水',
              value: data.refundId,
            },
            {
              name: '发起退款账号',
              value: (data.refundOperatorId || '') + '\n' + (data.refundOperatorName || ''),
            },
            {
              name: '退款原因',
              value: data.refundReason,
            },
          ]
        ],
      };
      return refundData;
    }
    return null;
  },
})