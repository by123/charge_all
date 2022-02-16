//app.js
App({
  onLaunch: function () {
    wx.showLoading();

    setTimeout(wx.hideLoading, 1000);
  },
  globalData: {
    userInfo: null,
    noticeVisible: true,
  }
})