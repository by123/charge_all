import { Api } from './api.js';
import {
  setStorageItem,
  getStorageItem,
  getCurrentPageInstance,
  getCurrentPagePath,
  removeStorageItem,
} from './util.js';
import {
  TOKEN_KEY
} from './enum.js';
import CustomEvent from './event.js';

let userInfo = null;
let isLogin = false;
let loginSuccessQueue = [];
let getUserInfoSuccessQueue = [];
let wxCode = '';
let loginModalSet = {};
let loading = false;
let isActive = true; // 是否激活
let needLogin = false; // 弹窗是否需要登录
let MchInfo = null;
let IsAdmin = null; // null true false

init();

export function userLogin(wxUserInfo) {
  if (!needLogin) return;

  Api.sign(wxUserInfo).then((res) => {
    // console.log('userinfo', wxUserInfo);
    // console.log('asdasda', res);
    if (res.data.tokenType === 0) {
      isActive = true;
      setStorageItem(TOKEN_KEY, res.data.token);
    }
    loginSuccess(wxUserInfo);
  }, (err) => {
    // console.log('errdata', err.data);
    // 未激活
    const { status } = err.data || {};
    if (status === "24") {
      goActive();
    }
  });
}

// 登录成功
function loginSuccess() {
  removeStorageItem('token');
  needLogin = false;

  isLogin = true;
  handleLoginSuccessQueue();
  hideLoginModal();
}

// 保存用户信息
export function saveUserInfo(wxUserInfo) {
  userInfo = wxUserInfo.userInfo;
  setStorageItem('userInfo', JSON.stringify(userInfo));

  if (getUserInfoSuccessQueue && getUserInfoSuccessQueue.length) {
    while (getUserInfoSuccessQueue.length) {
      try {
        getUserInfoSuccessQueue.pop()(userInfo);
      } catch (e) {
        console.log(e);
      }
    }
  }
}

// 激活页
function goActive() {
  wx.reLaunch({
    url: `/pages/common/active/active`,
  });
}

/**
 * 微信登录，获取token
 */
export function wxLogin() {
  return new Promise((resolve, reject) => {
    if (wxCode) {
      return resolve(_wxLogin());
    } else {
      getCode().then((code) => {
        return resolve(_wxLogin());
      }).catch((e) => {
        return reject(e);
      });
    }
  });
}

function _wxLogin() {
  return new Promise((resolve, reject) => {
    Api.login({
      code: wxCode
    }).then((res) => {
      // console.log('asdaqwe', res);
      deleteCode();
      isActive = true;
      setStorageItem(TOKEN_KEY, res.data.token);

      resolve(res);
      loading = false;
    }).catch((res) => {
      deleteCode(); 
      if (res.data) {
        res = res.data;
        if (res.status === '24' && res.data && res.data.tokenType === 1) {
          saveToken(res.data.token);
          isActive = false;
          resolve(res);
        }
      }

      reject(res);
      loading = false;
    });
  })
}

// 登录，先调用wxlogin，判断tokenType，1为未绑定，0为绑定
// 判断是否需要授权
// 绑定的弹出登录窗，未绑定的跳转至绑定页
export function login(cb) {
  // console.log('loading ', loading);
  if (cb && cb instanceof Function) {
    loginSuccessQueue.push(cb);
  }
  if (loading) return;
  loading = true;

  wxLogin().then((res) => {
    if (!isActive) {
      needLogin = true;
      // console.log('wxCode', wxCode);
      checkNeedAuth().then((res) => {
        userLogin(res);
      }, () => {
        showLoginModal();
      });
    } else {
      loginSuccess();
    }
  }, (res) => {
    console.log(res);
  });
}

// 判断是否需要弹窗
function checkNeedAuth() {
  return new Promise((resolve, reject) => {
    wx.getSetting({
      success: res => {
        if (res.authSetting['scope.userInfo']) {
          wx.getUserInfo({
            withCredentials: true,
            success: res => {
              resolve(res);
            },
            fail: err => {
              reject(err);
            }
          })
        } else {
          reject(res);
        }
      }
    })
  });
}

/**
 * 获取用户信息
 */
export function getAndSaveUserInfo() {
  return new Promise((resolve, reject) => {
    if (userInfo) return resolve(userInfo);
    checkNeedAuth().then((res) => {
      // userLogin(res);
      saveUserInfo(res);
      resolve(res.userInfo);
    }, () => {
      getUserInfoSuccessQueue.push(resolve);
      showLoginModal();
      getUserInfoSuccessQueue.push(() => {
        hideLoginModal();
      });
    });
  });
}

/**
 * 获取用户信息
 */
export function getMchInfo(needRefresh) {
  return new Promise((resolve, reject) => {
    if (MchInfo && !needRefresh) return resolve(MchInfo);
    Api.getUserInfo().then(res => {
      const { mch } = res.data;
      saveMchInfo(mch);
      resolve(mch);
    }, err => {
      reject(err);
    });
  });
}

function saveMchInfo(mchInfo) {
  MchInfo = mchInfo;
  // setStorageItem('mchInfo', JSON.stringify(mchInfo));
}

/**
 * 执行所有登录成功回掉
 */
function handleLoginSuccessQueue() {
  if (loginSuccessQueue.length) {
    while (loginSuccessQueue.length) {
      try {
        loginSuccessQueue.pop()(userInfo);
      } catch (e) {
        console.log(e);
      }
    }
  }
}

function saveToken(token) {
  setStorageItem('token', token);
}

/**
 * 获取code
 */
export function getCode() {
  return new Promise((resolve, reject) => {
    wx.login({
      success: function(code) {
        wxCode = code.code;
        resolve(code);
      },
      fail: function(err) {
        reject(err);
      },
    });
  });

}

/**
 * code为一次性的，使用完即删除
 */
export function deleteCode() {
  wxCode = '';
}

/**
 * 判断是否登陆
 */
export function checkLogin() {
  return isLogin;
}

/**
 * 登录后执行方法
 * @doLogin Boolean
 * @cb Function
 */
export function doIfLogin(cb, doLogin) {
  if (!cb instanceof Function) return;
  if (isLogin) {
    cb();
  } else {
    loginSuccessQueue.push(cb);
  }

  if (doLogin) {
    login();
    // showLoginModal();
  }
}

export function loginIfNot() {
  if (!isLogin) showLoginModal();
}

/**
 * 显示当前页面的登录窗
 */
export function showLoginModal() {
  let modal = loginModalSet[getCurrentPagePath()];
  if (modal && !modal.visible) {
    wx.hideLoading();
    getCode();
    modal.instance.setData({
      visible: true,
    });
    modal.visible = true;
  }
}

/**
 * 隐藏页面的登录窗
 */
export function hideLoginModal(key) {
  if (key) {
    let cur = loginModalSet[key];
    cur.instance.setData({
      visible: false,
    });
    cur.visible = false;
  } else {
    for (let modalKey in loginModalSet) {
      let modal = loginModalSet[modalKey];
      if (modal.visible) {
        modal.instance.setData({
          visible: false,
        });
        modal.visible = false;
      }
    }
  }
}

/**
 * 保存登录窗的引用
 */
export function addLoginModal(key, modalInstance) {
  loginModalSet[key] = {
    instance: modalInstance,
    visible: false,
  };
}

export function removeLoginModal(key) {
  delete loginModalSet[key];
}

// 获取保存的用户信息
export function getUserData() {
  return userInfo;
}

export function checkIsActive() {
  return isActive;
}

export function checkIsAdmin(needRefresh) {
  return new Promise((resolve, reject) => {
    if (!needRefresh) resolve(IsAdmin);
    Api.checkIsAdmin().then((res) => {
      IsAdmin = res.data;
      resolve(IsAdmin);
    }).catch(e => {
      reject(e);
    });
  });
}

/**
 * 初始化，获取存储的用户信息和token
 */
function init() {
  CustomEvent.off('reLogin', login);
  CustomEvent.on('reLogin', login);
  if (getStorageItem(TOKEN_KEY)) {

    isLogin = true;
    userInfo = getStorageItem('userInfo');
    userInfo = userInfo ? JSON.parse(userInfo) : null;
    // MchInfo = getStorageItem('mchInfo');
    // MchInfo = MchInfo ? JSON.parse(MchInfo) : null;
    checkIsAdmin(true);
  };
}