var netutil = require("../../../../utils/netutil.js");
var constant = require("../../../../utils/constant.js");
var util = require("../../../../utils/util.js");


let homePage = '../../../home/home';

Page({
  /**
   * 页面的初始数据
   */
  data: {
    img_drive_bg:getApp().globalData.sk+"/bg_drive_bg.png",
    img_charge_help:getApp().globalData.sk + "/ic_charge_help.png",
    gif_yanshi:getApp().globalData.sk + "/yanshi.gif",
    password :"*****",
    animation: null,
    point1: { content:'司机专属充电密码，充电不限时长，请勿告知乘客',height:516},
    point2: {
      content: '司机充电中拔掉手机，充电器将断电。重新输入司机密码即可恢复充电。',height:566}
  },

  onLoad: function (options) {
    this.setData({
      password: options.psw
    })
    this.startPlay();
    this.startAnim();
  },

  //点击帮助
  onHelpTap: function () {
    this.openAnimation();
  },

  //点击我知道了
  onKnowTap: function () {
    this.closeAnimation();
  },

  //点击返回
  onBackBtnTap:function(){
    getApp().reLunchPage(homePage, null);
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
  
  onPageTap: function () {
    console.log('page touch')
  },

  onShareAppMessage: function () {
    return util.shareContent();
  }
}
)

