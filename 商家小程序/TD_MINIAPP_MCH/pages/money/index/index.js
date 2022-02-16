// pages/money/index.js
import {
  formatProfit,
  formatWithdrawal,
  dateFormatter,
  getNextDay,
  formatMoney,
} from '../../../utils/util.js'
import { Api } from '../../../utils/api.js';
import { checkIsAdmin } from '../../../utils/user.js';

const DEFAULT_DATE_TEXT = '全部';

Page({

  /**
   * 页面的初始数据
   */
  data: {
    pageId: 1,
    pageSize: 10,
    list: [],
    hasMore: true,
    init: false,

    profit: {},
    tab: 'profit', // profit withdrawal
    startDate: '2018-11-01',
    endDate: '',
    withdrawalDate: '',
    withdrawalPickerText: DEFAULT_DATE_TEXT,
    profitDate: '',
    profitPickerText: DEFAULT_DATE_TEXT,
    noticeVisible: false,
    noticeContent: '',
    noticeIcon: '',

    canWithdraw: false,
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    const { tab } = options;
    this.setData({
      endDate: dateFormatter(new Date(), 'yyyy-MM-dd'),
      tab: tab || 'profit',
    });
    this.getListData(true);
    this.getProfit();
    this.getNotice();
  },

  onShow() {
    this.checkAuth();
  },

  checkAuth() {
    checkIsAdmin().then((res) => {
      this.setData({
        canWithdraw: res === true || res === null,
      });
    });
  },

  getListData: function (isRefresh, isLoadmore) {
    let {
      pageSize,
      pageId,
      list,
      tab,
    } = this.data;
    let listApi = '';
    let formatFn = '';
    let selectedDate = this.data[tab + 'Date'];

    !isLoadmore && (pageId = 1);
    if (isRefresh && tab === 'withdrawal') {
      this.setData({
        list: [],
        init: false,
      });
    }
    if (tab === 'profit') {
      listApi = 'getProfitList';
      formatFn = 'formatProfit';
    } else {
      listApi = 'getWithdrawalList';
      formatFn = 'formatWithdrawal';
    }

    let query = {
      pageSize: pageSize,
      pageId: isLoadmore ? pageId + 1 : pageId,
    };
    if (selectedDate) {
      query[tab === 'profit' ? 'beginDate' : 'startDate'] = selectedDate;
      query['endDate'] = getNextDay(selectedDate);
    }

    Api[listApi](query).then((res) => {

      if (res.data) {
        !isLoadmore && (list = []);
        const {
          rows,
        } = res.data;
        // console.log('formatData', this[formatFn](rows));
        list = list.concat(this[formatFn](rows));
        this.setData({
          list,
          hasMore: rows && rows.length === pageSize,
          init: true,
          pageId: isLoadmore && rows && rows.length ? pageId + 1 : pageId,
        });
      } else {
        this.setData({
          init: true,
        });
      }

      isRefresh && wx.stopPullDownRefresh();
    }).catch((e) => {
      console.log(e);
      this.setData({
        init: true,
      });
      isRefresh && wx.stopPullDownRefresh();
    });
  },

  getProfit: function () {
    Api.getProfit().then((res) => {
      if (res.data) {
        let {
          canWithdrawNum,
          freezeNum,
          total,
          balanceAmount
        } = res.data;
        let profit = {
          canWithdrawNum: formatMoney(canWithdrawNum),
          balance: formatMoney(balanceAmount),
          total: formatMoney(total),
        };

        this.setData({
          profit,
        });
      }
    });
  },

  onWithdrawal() {
    const { profit: { canWithdrawNum } } = this.data;
    if (canWithdrawNum > 0) {
      wx.navigateTo({
        url: '../withdrawal/withdrawal',
      });
    } else {
      wx.showModal({
        title: '提示',
        content: '可提现金额不足',
        showCancel: false,
      });
    }
  },

  goDetail(e) {
    const {
      id
    } = e.currentTarget.dataset;
    wx.navigateTo({
      url: `../../order/detail/detail?orderId=${id}`,
    })
  },

  bindDateChange(e) {
    this.setFilter(e.detail.value);
    this.setData({
      list: [],
    });
    this.getListData(true);
  },

  formatDateText(date) {
    let result = '';
    let dateArr = date.split('-');
    return `${dateArr[1]}月${dateArr[2]}日`;
  },

  changeTab(e) {
    const {
      tab
    } = e.currentTarget.dataset;
    this.setData({
      tab,
      init: false,
      list: [],
      hasMore: true,
    });
    this.resetFilter();
  },

  resetFilter() {
    this.setFilter('');
    this.getListData(true);
  },

  setFilter(date) {
    const {
      tab,
    } = this.data;
    const dateText = date ? this.formatDateText(date) : DEFAULT_DATE_TEXT;
    this.setData({
      [tab + 'Date']: date,
      [tab + 'PickerText']: dateText,
    });
  },

  goWithdrawalFail(e, id) {
    id = id || e.currentTarget.dataset.id;
    wx.navigateTo({
      url: `../withdrawalFail/withdrawalFail?withdrawId=${id}`,
    })
  },

  formatProfit,

  formatWithdrawal,

  checkDetail(e) {
    const { id, state } = e.currentTarget.dataset;
    if (!id) return;
    if (state !== 3) {
      wx.navigateTo({
        url: `../withdrawalSuccess/withdrawalSuccess?withdrawId=${id}`,
      });
    } else {
      this.goWithdrawalFail(null, id);
    }
  },

  getNotice() {
    Api.getConfig({
      cfgKey0: 'profit_notice',
      cfgKey1: 'mch_mini_app',
    }).then(res => {
      if (res.data) {
        let cfgValue = res.data.cfgValue;
        cfgValue = cfgValue.length ? JSON.parse(cfgValue) : {};
        const { imgUrl = '', content = '' } = cfgValue;
        const { noticeVisible } = getApp().globalData;

        this.setData({
          noticeVisible: !!content && noticeVisible,
          noticeIcon: imgUrl,
          noticeContent: content,
        });
      }
    });
  },

  closeNotice() {
    this.setData({
      noticeVisible: false,
    });
    getApp().globalData.noticeVisible = false;
  },

  /**
   * 页面相关事件处理函数--监听用户下拉动作
   */
  onPullDownRefresh: function () {
    this.getListData(true);
    this.getProfit();
  },

  /**
   * 页面上拉触底事件的处理函数
   */
  onReachBottom: function () {
    this.getListData(false, true);
  },

})