// pages/mine/personManage/personManage.js
import { Api } from '../../../utils/api.js';


Page({

  /**
   * 页面的初始数据
   */
  data: {
    list: [],
    isInit: false,
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    this.getListData();
  },

  getListData() {
    Api.getOperatorList({
      pageId: 1,
      pageSize: 999999,
    }).then(res => {
      const list = res.data.rows || [];
      this.setData({
        list,
        isInit: true,
      });
    });
  },

  deleteManage(index) {
    const { list } = this.data;
    const userId = list[index].userId;
    Api.deleteOperator({
      userId,
    }).then(res => {
      list.splice(index, 1);
      this.setData({
        list,
      });
      wx.showToast({
        title: '删除成功',
      });
    });
  },

  handleTransfer(e) {
    const { index } = e.currentTarget.dataset;
    wx.showModal({
      title: '转让管理员',
      content: '转让后，此运营人员将成为商户管理员，具有提现权限，原管理员将成为运营人员，没有提现权限',
      success: e => {
        if (e.confirm) {
          this.transferManege(index);
        }
        console.log(e.confirm);
      }
    })
  },

  transferManege(index) {
    const { list } =  this.data;
    Api.transferAdmin({
      userId: list[index].userId,
    }).then(res => {
      wx.showToast({
        title: '转让成功',
      });
      setTimeout(() => {
        wx.reLaunch({
          url: '../index/index',
        })
      }, 1500);
    });
  },

  handleDelete(e) {
    const { index } = e.currentTarget.dataset;
    const { list } = this.data;
    wx.showModal({
      title: '提示',
      content: `是否确认删除运营人员 ${list[index].name}，删除后该用户将不能继续查看数据`,
      success: e => {
        if (e.confirm) {
          this.deleteManage(index);
        }
      },
    });
  },
})