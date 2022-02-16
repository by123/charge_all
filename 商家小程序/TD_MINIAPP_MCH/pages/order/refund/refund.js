// pages/money/refund/refund.js
import { Api } from '../../../utils/api.js';
import {
  showMessage,
  formatDepositStatus,
  moneyAddPre,
  formatMoney,
} from '../../../utils/util.js';

Page({

  /**
   * 页面的初始数据
   */
  data: {
    orderId: '',
    toDetail: false, //来源页
    orderData: null,
    loading: false,
    disable: false,
    moneyData: {
      title: '退款操作',
    },
    reasonData: {
      title: '退款原因',
    },
    reason: '',
    refundMoney: '', // 退款金额
    actualPrice: 0,

    pickerIndex: -1,
    reasonArray: [],
    reasonText: '请选择',
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function(options) {
    const {
      orderId,
      toDetail = false,
    } = options;
    this.setData({
      orderId,
      toDetail: !!toDetail,
    });

    this.getOrderData(orderId);
    this.getReasonArray();
  },

  getOrderData(orderId) {
    Api.getOrderDetail({
      orderId,
    }).then((res) => {
      if (res.data) {
        const data = {
          ...res.data,
          ...res.data.tblOrder,
        };
        const {
          orderPriceYuan,
          depositPriceYuan
        } = data;
        let actualPrice = 0;
        if (orderPriceYuan && depositPriceYuan) {
          actualPrice = Number(orderPriceYuan) - Number(depositPriceYuan);
        } else {
          actualPrice = orderPriceYuan || depositPriceYuan || 0;
        }
        this.setData({
          orderData: this.generateOrderData(data),
          actualPrice: formatMoney(actualPrice),
        });
      }
    });
  },

  submit(data) {
    const {
      loading,
      disable,
      toDetail,
      orderId,
    } = this.data;
    if (loading || disable) return;
    this.setData({
      loading: true,
    });
    Api.refund({ ...data
    }).then((res) => {
      showMessage('退款提交成功', 3000);

      setTimeout(() => {
        if (toDetail) {
          wx.redirectTo({
            url: `../detail/detail?orderId=${orderId}`,
          });
        } else {
          wx.navigateBack();
        }
      }, 3000);
      this.setData({
        disable: true
      });
    }).catch(e => {
      console.log(e);
      this.setData({
        loading: false,
      });
    });
  },

  onConfirm() {
    const {
      orderId,
      reason,
      refundMoney,
      orderData,
      actualPrice,
      reasonText,
      reasonArray,
      pickerIndex,
    } = this.data;

    let msg = '';
    if (!refundMoney) {
      msg = '请输入退款金额';
    } else if (refundMoney > actualPrice) {
      msg = '退款金额不能超过用户实际支付金额';
    } else if (pickerIndex === -1) {
      msg = '请选择退款原因';
    } else if (reasonArray[pickerIndex].id === 7 && !reason) {
      msg = '请输入退款原因';
    }

    if (msg) {
      wx.showModal({
        title: '提示',
        content: msg,
        showCancel: false,
      });
      return
    }

    let options = {
      orderId,
      reason,
      refundMoney
    };
    this.submit(options);
  },

  generateOrderData(data) {
    let orderData = {
      content: [
        [{
          name: '订单编号',
          value: data.orderId,
        }, {
          name: '订单金额',
            value: moneyAddPre(data.orderPriceYuan),
        }, {
          name: '设备押金',
            value: `${moneyAddPre(data.depositPriceYuan)} (${formatDepositStatus(data.orderStateWeb)})`,
        }, ],
      ]
    };

    return orderData;
  },

  handleInput: function(e) {
    this.setData({
      refundMoney: e.detail.value,
    });
  },

  handleInputReason: function(e) {
    this.setData({
      reason: e.detail.value,
    });
  },


  getReasonArray() {
    Api.getConfig({
      cfgKey0: 'refund_reason',
      cfgKey1: 'web',
    }).then(res => {
      let { cfgValue } = res.data;
      cfgValue = JSON.parse(cfgValue || '[]');
      this.setData({
        reasonArray: cfgValue,
      });
    });
  },

  bindPickerChange(e) {
    const { value } = e.detail;
    const { reasonArray } = this.data;
    this.setData({
      pickerIndex: value,
      reasonText: reasonArray[value].desc,
    });
  },
})