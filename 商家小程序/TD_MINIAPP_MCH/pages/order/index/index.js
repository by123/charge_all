// pages/order/index.js
import {
  formatOrderData,
} from '../../../utils/util.js';
import {
  orderStatus,
  orderBtnType,
  CANCEL,
  DEPOSIT,
  REFUND,
} from '../../../utils/enum.js';
import { Api } from '../../../utils/api.js';

Page({

  /**
   * 页面的初始数据
   */
  data: {
    tabsArray: [],
    tabActive: '',

    pageId: 1,
    pageSize: 10,
    list: [],
    hasMore: true,
    init: true,
    isLoaded: false,
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function(options) {
    const tabsArray = this.generateTabs();
    this.setData({
      tabsArray,
      tabActive: tabsArray[0].value,
    });

    this.getOrderList();
  },

  handleItemTap(e) {
    const {
      id
    } = e.currentTarget.dataset;
    wx.navigateTo({
      url: `../detail/detail?orderId=${id}`,
    })
  },

  changeTab(e) {
    this.resetListQuery();
    this.setData({
      tabActive: e.detail,
    });
    this.getOrderList();
  },

  generateTabs() {
    let tabs = [];
    for (let key in orderStatus) {
      tabs.push({
        name: orderStatus[key],
        value: key,
      });
    }
    return tabs.sort((a, b) => {
      return Number(a.value) > Number(b.value);
    });
  },

  getOrderList(isRefresh, isLoadmore) {
    let {
      pageSize,
      pageId,
      list,
      tabActive,
    } = this.data;
    !isLoadmore && (pageId = 1);
    Api.getOrderList({
      pageSize,
      pageId: isLoadmore ? pageId + 1 : pageId,
      orderState: tabActive,
    }).then((res) => {
      !isLoadmore && (list = []);

      if (res.data && res.data.rows) {
        list = list.concat(formatOrderData(res.data.rows));
        this.setData({
          list,
          pageId: isLoadmore && res.data.rows.length ? pageId + 1 : pageId,
          hasMore: res.data.rows.length === pageSize,
          init: true,
          isLoaded: true,
        });
      } else {
        this.setData({
          init: true,
          isLoaded: true,
        });
      }

      isRefresh && wx.stopPullDownRefresh();
    }).catch((e) => {
      isRefresh && wx.stopPullDownRefresh();
      console.log(e);
      this.setData({
        init: true,
        isLoaded: true,
      });
    });
  },

  // 切换Tab时重置表单
  resetListQuery() {
    this.setData({
      pageId: 1,
      list: [],
      hasMore: true,
      init: false,
    });
  },

  // 列表按钮点击
  handleBtnTap(e) {
    const {
      orderId,
    } = e.detail;
    // let status = orderBtnType[btnType].value;

    // switch (status) {
    //   case CANCEL:
    //     this.cancelOrder(orderId);
    //     break;
    //   case DEPOSIT:
    //     this.returnDeposit(orderId);
    //     break;
    //   case REFUND:
    //     this.refund(orderId);
    //     break;
    // }

    this.refund(orderId);
  },

  cancelOrder(orderId) {},

  // 申请退款
  refund(orderId) {
    wx.navigateTo({
      url: `../refund/refund?orderId=${orderId}&toDetail=true`,
    });
  },

  // 退押金
  returnDeposit() {
    console.log('refund: ', orderId);
  },

  catchTap() {
    console.log('refund: ', orderId);
  },

  /**
   * 页面相关事件处理函数--监听用户下拉动作
   */
  onPullDownRefresh() {
    this.getOrderList(true);
  },

  /**
   * 页面上拉触底事件的处理函数
   */
  onReachBottom() {
    this.getOrderList(false, true);
  },

})