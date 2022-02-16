const constants = require("../../utils/constant.js");
const netutil = require("../../utils/netutil.js");
const util = require("../../utils/util.js");

Page({
  data: {
    product: getApp().globalData.product,
    img_delete:getApp().globalData.sk+"/delete-gray.png",
    tempFilePathsArr: [],
    isEmpty: true,
    phoneVal: '',
    deleteIndex: -1,
    phoneStyle: '',
    problemVal: '',
    truePhone: false,
    noPhoneVal: false,
    orderId: ""
  },
  onLoad: function (options) {
    this.data.orderId = options.orderId;
    console.log('其他问题->' + this.data.orderId)
  },

  onphoneVal(e) {
    const flag = e.detail.value != '' ? false : true;
    let value = e.detail.value.replace(/[^\d]/g, '');
    this.setData(
      {
        isEmpty: flag,
        phoneVal: value
      }
    );
    if (!flag) {
      this.setData({
        phoneStyle: 52
      })
    } else {
      this.setData({ phoneStyle: 0 })
    }
  },

  emptyPhoneVal() {
    this.setData({
      phoneVal: '',
      isEmpty: !this.isEmpty,
      phoneStyle: 0
    })
  },

  onChooseimage: function () {
    var _this = this;
    wx.chooseImage({
      count: 5, // 默认9
      sizeType: ['original', 'compressed'], // 可以指定是原图还是压缩图，默认二者都有
      sourceType: ['album', 'camera'], // 可以指定来源是相册还是相机，默认二者都有
      success: function (res) {
        _this.setData({
          tempFilePathsArr: res.tempFilePaths
        })
      }
    })
  },

  deletePicture(e) {
    let id = e.currentTarget.id;
    this.setData({ deleteIndex: id });
    this.data.tempFilePathsArr.splice(id, 1);
    setTimeout(() => {
      this.setData({
        deleteIndex: -1,
        tempFilePathsArr: this.data.tempFilePathsArr
      })
    }, 200)
  },
  submitComplainMessage() {
    const params = {
      "complainContent": this.data.problemVal,
      "complainPics": "",
      "phone": this.data.phoneVal,
      "orderId": this.data.orderId,
      "classifyType": "其他"
    }
    if (this.data.phoneVal.length === 0) {
      util.showToast('请输入手机号码');
      return;
    } else if (this.data.problemVal === "") {
      util.showToast('请输入遇到问题');
      return;
    } else if (this.data.phoneVal.length !== 0 && this.data.problemVal !== "") {
      if (!util.checkPhoneVal(this.data.phoneVal)) {
        this.setData({ truePhone: true })
        return false;
      } else {
        netutil.postRequest(constants.URL_COMMIT_COMPLAIN, JSON.stringify(params), function (success) {
          util.showToast('提交成功');
          wx.navigateBack({
            delta: 2
          })
        }, function (fail) {
          util.showToast('提交失败');
          console.error(fail);
        })
      }
    }
  },
  meetProblem(e) {
    this.setData({ problemVal: e.detail.value })
  },

  onPageTap: function () {
    console.log('page touch')
  }
})