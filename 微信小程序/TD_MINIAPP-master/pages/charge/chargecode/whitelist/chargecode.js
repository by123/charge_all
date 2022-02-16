var netutil = require("../../../../utils/netutil.js");
var constant = require("../../../../utils/constant.js");
var util = require("../../../../utils/util.js");
var analysis = require("../../../../utils/analysis.js");

let startPage = '../../../start/start';
let customerPage = '../../../customer/customer';
let chargePage = '../../../charge/charge/origin/charge';

Page({
  /**
   * 页面的初始数据
   */
  data: {
    product: getApp().globalData.product,
    img_psw_top:getApp().globalData.sk+"/bg_pswtop.png",
    img_charge_help:getApp().globalData.sk+"/ic_charge_help.png",
    gif_yanshi:getApp().globalData.sk+"/yanshi.gif",
    img_net_error:getApp().globalData.sk+"/img_net_error.png",
    //倒计时
    timer: 'chargeTimer',//定时器名字
    items: [],
    timeStr: "0小时0分0秒",
    seconds: 0,
    countDownNum: 0,
    totalPrice: 0,
    selectIndex: -1,
    deviceCodeStr: "",
    orderId: "",
    //轮询查密码
    countRequest: 0,
    FromBackgroud: false,
    blurValue: 0,
    netHidden: true,
    nextHidden: true,
    loadingHidden: true,
    animation: null,
    snStr: "",
    //loading轮询
    pointTimerId: 88,
    pointIndex: 0,
    point1: { point: false },
    point2: { point: false },
    point3: { point: false },
    point4: { point: false },
    point5: { point: false },
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    console.log("生命周期onLoad")
    wx.setNavigationBarColor({
      frontColor: this.data.product == 0 ? '#000000' : '#ffffff',
      backgroundColor: this.data.product == 0 ? '#FCE447' : '#ECA296',
    })
    var app = getApp();
    var sameDevice = options.sameDevice;
    this.data.snStr = options.sn;
    this.setData({
      contentHeight: app.globalData.windowH,
      loadingHidden: true,
      point1: { point: true },
      point2: { point: false },
      point3: { point: false },
      point4: { point: false },
      point5: { point: false },
    });
    this.checkSameDevice(sameDevice);
    this.startPlay();
    this.startAnim();

    //显示广告
    var adview = this.selectComponent("#adview")
    adview.showAdWithSn(this.data.snStr); 
  },

  onHide: function () {
    console.log("隐藏页面")
    this.data.countRequest = 0;
    clearInterval(this.data.pointTimerId);
    clearInterval(this.data.timer);
  },

  onShow: function () {
    this.loading();
    this.queryPassword();
    if (getApp().globalData.nextStepChargeCode == 1) {
      getApp().globalData.nextStepChargeCode = 0;
      this.nextStepin();
    };
  },

  //播放音频
  startPlay: function () {
    util.audioPlay({ authorization: getApp().globalData.authorization, audioUrl: '/audio/audio2.mp3' });
  },

  //播放动画
  startAnim: function () {
    var that = this;
    wx.getStorage({
      key: constant.KEY_NEW_USER,
      success: function (res) {
        if (res.data == 1) {
          setTimeout(function () {
            that.openAnimation();
          }, 2000);
          wx.setStorage({
            key: constant.KEY_NEW_USER,
            data: 0,
          });
        }
      },
    })
  },

  //检查是否扫描同一台设备
  checkSameDevice: function (sameDevice) {
    if (sameDevice == 0) {
      var that = this;
      wx.showModal({
        content: '您已经有一台设备正在充电中，如需使用其他设备，请先结束正在使用的设备',
        showCancel: true,
        cancelText: "取消",
        cancelColor: "#353648",
        confirmText: "结束订单",
        confirmColor: "#353648",
        success: function (res) {
          if (res.confirm) {
            that.closeOrder();
          }
        }
      })
    }
  },
  /**
  * 点击结束订单
  */
  closeOrder: function () {
    var that = this;
    var params = { 'orderId': this.data.orderId };
    netutil.getRequest(constant.URL_CLOSE_ORDER, params, function (success) {
      var status = success.status;
      wx.setStorage({ key: "charge_statu", data: 0 });
      util.showToast('上笔订单已结束');
      var result = constant.scanUrl + that.data.snStr;
      getApp().openPageWithoutBack(chargePage,
        [{ 'key': 'scanUrl', 'value': encodeURIComponent(result) }]);
    }, function (fail) { });
  },
  //轮询查询密码
  queryPassword: function () {
    this.data.countRequest++;
    //最多查询三次结果
    if (this.data.countRequest > 3) {
      console.log("查询3次失败");
      this.reGetPassword();
      return;
    }
    console.log("查询" + this.data.countRequest + "次")
    this.getPassword();
  },

  //获取充电密码
  getPassword() {
    var that = this;
    netutil.getRequest(constant.URL_GETLASTCHARGE_STATU, null, function (success) {
      var data = success.data;
      if (data.chargingFlag == 1) {
        that.handleSuccess(data);
      } else {
        clearInterval(that.data.timer);
        getApp().reLunchPage(startPage,null);
      }
    }, function (fail) {
      that.queryPassword();
      //失败统计
      var mark = { statu: 0, password: "none", apiname: "lastOrder", orderid: "" };
      analysis.markData("get_password", mark);
    });
  },

  //获取密码成功处理
  handleSuccess: function (data) {
    if (data.chargingFlag == 1) {
      var ramainTime = parseInt(data.remainTime / 1000);
      if (data.password != null) {
        this.setData({
          seconds: ramainTime,
          countDownNum: ramainTime,
          deviceCodeStr: data.password,
          loadingHidden: false
        });
        //开始倒计时
        this.countDown();
        //保存充电状态
        wx.setStorage({ key: "charge_statu", data: 1 });
        //成功统计
        var mark = {
          statu: 1, password: data.password,
          apiname: "lastOrder", orderid: data.orderid
        };
        analysis.markData("get_password", mark);
      }
    }
  },

  //重新获取充电密码
  reGetPassword() {
    if (this.data.deviceCodeStr != "" && !util.isBlank(this.data.deviceCodeStr)) {
      console.log("设备密码已缓存：" + this.data.deviceCodeStr);
      //继续倒计时
      this.countDown();
      return;
    }
    this.setData({
      netHidden: false,
      blurValue: 0
    });
  },

  /**点击重新获取密码 */
  onRefreshTap: function () {
    this.data.countRequest = 0;
    this.setData({
      netHidden: true,
      blurValue: 0
    })
    this.getPassword();
  },

  /**再次进入显示密码**/
  onCloseTap: function () {
    this.setData({
      nextHidden: true,
      blurValue: 0
    });
  },
  /**
   * 用户点击右上角分享
   */
  onShareAppMessage: function () {
    return util.shareContent();
  },

  /**
   * 点击item
   */
  onItemTap: function (e) {
    var item = e.currentTarget.dataset.name;
    for (var index in this.data.items) {
      this.data.items[index].checked = false;
      if (this.data.items[index].id == item.id) {
        this.data.selectIndex = index;
      }
    }
    this.data.items[this.data.selectIndex].checked = true;
    var totalTime = this.data.countDownNum + item.time * 60 * 60;
    this.setData({
      items: this.data.items,
      totalPrice: parseInt(item.price),
      selectIndex: this.data.selectIndex,
      countDownNum: totalTime
    });
  },

  /**
   * 开始倒计时
   */
  countDown: function () {
    if (this.data.seconds == 0) return;
    var that = this;
    //清除计时
    clearInterval(this.data.timer);
    this.data.timer = setInterval(function () {
      that.data.countDownNum--;
      var h = parseInt(that.data.countDownNum / 3600);
      var m = parseInt((that.data.countDownNum - h * 3600) / 60);
      var s = that.data.countDownNum - h * 3600 - m * 60;
      that.setData({ timeStr: h + "小时" + m + "分" + s + "秒" });
      if (that.data.countDownNum <= 0) {
        clearInterval(that.data.timer);
        getApp().reLunchPage(startPage,null);
      }
    }, 1000);
  },

  onPageTap:function(){
    console.log('page touch')
  },

  onProblem: function () {
    getApp().openPage(customerPage, [{ 'key': 'orderId', 'value': this.data.orderId }, , { 'key': 'sn', 'value': this.data.snStr }]);
  },

  //第二次进入小程序
  nextStepin: function () {
    this.setData({
      blurValue: 0,
      nextHidden: false
    })
  },
  //点击帮助
  onHelpTap: function () {
    this.openAnimation();
  },

  //点击我知道了
  onKnowTap: function () {
    this.closeAnimation();
  },

  //打开动画
  openAnimation: function () {
    var anim = wx.createAnimation({
      duration: 300,
      delay: 0,
      timingFunction: "ease",
    });

    anim.translateY(420 * getApp().globalData.windowW / 375).step({ duration: 300 });
    anim.translateY(390 * getApp().globalData.windowW / 375).step({ duration: 300 });
    this.setData({ animation: anim.export() })
  },

  //关闭动画
  closeAnimation: function () {
    var anim = wx.createAnimation({
      duration: 300,
      delay: 0,
      timingFunction: "ease",
    });

    anim.translateY(0).step({ duration: 300 });
    this.setData({ animation: anim.export() })
  },

  //loading
  loading: function () {
    this.loadingTime();
  },

  loadingTime: function () {
    var that = this;
    this.data.pointTimerId = setInterval(function () {
      that.data.pointIndex++;
      if (that.data.pointIndex > 4) {
        that.data.pointIndex = 0;
      }
      that.setData({
        point1: { point: false },
        point2: { point: false },
        point3: { point: false },
        point4: { point: false },
        point5: { point: false },
      });
      switch (that.data.pointIndex) {
        case 0:
          that.setData({
            point1: { point: true },
          });
          break;
        case 1:
          that.setData({
            point2: { point: true },
          });
          break;
        case 2:
          that.setData({
            point3: { point: true },
          });
          break;
        case 3:
          that.setData({
            point4: { point: true },
          });
          break;
        case 4:
          that.setData({
            point5: { point: true },
          });
          break;
      }
    }, 400);
  },

  

},
)