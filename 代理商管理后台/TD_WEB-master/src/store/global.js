/**
 * 通用的全局状态（或者说是系统状态，非业务状态）
 * 包括左侧导航菜单数据，登陆态数据，图片上传token等等
 */
import { message } from 'antd';
import moment from 'moment';
import { push } from '@/store/router-helper';
import * as types from './action-types';
import { request, post, get } from '../utils/request';
import { api } from './api';
import { loginErrCode } from '../utils/enum';
import {
  normalMenu,
  userMenu,
  superMenu,
  superUserMenu,
  factoryMenu,
  financeMenu,
  serviceMenu,
  statisticMenu,
  taxiItem,
  adMenu,
} from './menu/menu';
import { AUTH_TOKEN_KEY, USER_INFO_KEY } from '../utils/constants';
import { isExpired, createReducer, getExpireTime, mergeState } from '../utils/index';
import cookie from '../utils/cookie';

// 修改密码弹窗
function toggleMPModal(visible, isFirst = false) {
  return {
    type: types.toggleMPModal,
    visible,
    isFirst,
  };
}

function saveAccountInfo(accountInfo) {
  cookie.set('accountInfo', JSON.stringify(accountInfo), null, null, 7 * 24 * 60);
}

function getIndexPage(mchType, roleType) {
  let indexPage = '/';
  if (mchType === 2) {
    switch (roleType) {
      case 4:
        indexPage = '/order';
        break;
      case 5:
        indexPage = '/initialize';
        break;
      case 6:
        indexPage = '/financeCenter';
        break;
      case 7:
        indexPage = '/initialize/productionLogin';
        break;
      default:
        indexPage = '/';
        break;
    }
  }
  return indexPage;
}

// function getAdAuthList(mchId, mchType) {
//   if (mchType === 2) {
//     return Promise.resolve(false);
//   }
//   return get(api.getConfig, {
//     cfgKey0: 'ad_white_list',
//   }).then(res => {
//     const whiteList = JSON.parse(res.cfgValue || '{}');
//     return Promise.resolve(mchId in whiteList);
//   }).catch(e => {
//     return Promise.reject(e);
//   });
// }

function getAdAuthList(nextAction) {
  return {
    type: types.getAdAuthList,
    payload: get(api.getConfig, { cfgKey0: 'ad_white_list' }),
    nextAction,
  };
}

function loginSuccess(accountInfo) {
  return (dispatch, getState) => {
    const { global: { loginData } } = getState();

    // 持久化登陆信息
    window.localStorage.setItem(AUTH_TOKEN_KEY, loginData.result.token);
    const { user, tblMch } = loginData.result;
    user._mchCreateTime = tblMch.createTime;
    user.authBit = tblMch.authBit;
    user.level = tblMch.level;
    user.hasTaxi = tblMch.supportSevice === '1';
    if (user.roleType > 1) {
      user.name = user.name || tblMch.mchName; // 如果名字没有就用 代理商/商户 名称
    } else {
      user.name = tblMch.mchName;
    }
    window.localStorage.setItem(USER_INFO_KEY, JSON.stringify(user));
    // 记住账号密码
    accountInfo && saveAccountInfo(accountInfo);

    // 需要重置密码
    if (user.isFirst === 0) {
      dispatch(toggleMPModal(true, true));
    } else {
      // 跳转首页
      // const indexPage = '/';
      dispatch(push(getIndexPage(tblMch.mchType, user.roleType)));
    }

  };
}

const fetchImageTokenLock = {
  0: false,
  1: false,
};
function fetchImageToken(isError, isPrivate) {
  const isPublic = isPrivate ? 0 : 1;
  return (dispatch) => {
    if (fetchImageTokenLock[isPublic]) return false;
    fetchImageTokenLock[isPublic] = true;
    const data = {
      fileType: 'images',
      isPublic,
    };
    const promise = get(api.qiniuToken, data);
    promise.finally(() => { // finally的返回值是空，要抽出来写
      fetchImageTokenLock[isPublic] = false;
    });
    dispatch({
      type: isPrivate ? types.fetchPrivateImageToken : types.fetchImageToken,
      payload: promise,
      /* eslint-disable no-use-before-define */
      nextAction: fetchImageTokenSuccess(isError),
    });
  };
}

function fetchImageTokenSuccess(isError) {
  return (dispatch) => {
    // 如果是图片上传
    isError && dispatch(message.info('重新获取token成功，您可以重新上传图片'));
  };
}

function generateUuid(key = 'codeData') {
  let uuid = moment().unix() + Math.random();
  return {
    type: types.generateUuid,
    uuid,
    key,
  };
}

function getImageCode(key = 'codeData') {
  return (dispatch, getState) => {
    const { global } = getState();
    dispatch({
      type: types.getImageCode,
      payload: get(api.getImageCode, { uuid: global[key].uuid }),
      key,
    });
  };
}

function updatePasswordSuccess(isFirst) {
  return (dispatch) => {
    dispatch(toggleMPModal(false, isFirst));
    if (isFirst) {
      dispatch({
        type: types.cleanLoginForm,
      });
      dispatch(generateUuid());
      dispatch(getImageCode());
    } else {
      dispatch(push('/login'));
    }

    message.success('保存成功！');
    window.localStorage.removeItem(AUTH_TOKEN_KEY);
    window.localStorage.removeItem(USER_INFO_KEY);
  };
}

// 修改密码
function updatePassword(data, isFirst = false) {
  return {
    type: types.updatePassword,
    payload: post(api.updatePassword, data),
    nextAction: updatePasswordSuccess(isFirst),
  };
}

// 找回密码弹窗
function toggleFindPassword(visible) {
  return {
    type: types.toggleFindPassword,
    visible,
  };
}

// 获取短信验证码
function findGetSmsCode(data, nextAction) {
  return (dispatch, getState) => {
    const { findPasswordCode } = getState().global;
    data.codeKey = String(findPasswordCode.uuid);
    const fn = () => {
      return nextAction(dispatch, getState, data.codeKey);
    };
    dispatch({
      type: types.findGetSmsCode,
      payload: post(api.findGetSmsCode, data),
      nextAction: fn,
    });
  };
}

// 验证短信验证码
function findCheckSmsCode(data, nextAction) {
  return {
    type: types.findCheckSmsCode,
    payload: post(api.findCheckSmsCode, data),
    nextAction,
  };
}

// 重置密码
function findResetPassword(data, nextAction) {
  return {
    type: types.findResetPassword,
    payload: post(api.findResetPassword, data),
    nextAction,
  };
}

function findGetSmsCodeAgain(data, nextAction) {
  return {
    type: types.findGetSmsCodeAgain,
    payload: get(api.findGetSmsCodeAgain, data),
    nextAction,
  };
}

// 设备提交错误列表
function toggleErrorList(visible) {
  return {
    type: types.toggleErrorList,
    visible,
  };
}

function menuAddAdItem() {
  return {
    type: types.menuAddAdItem,
  };
}

export const action = {
  login(data) {
    const { remember, userName, password } = data;
    let accountInfo = remember ? {
      userName,
      password,
    } : null;

    delete data.remember;

    return (dispatch, getState) => {
      const { global: { codeData } } = getState();
      data.codeKey = codeData.uuid;
      dispatch({
        type: types.login,
        payload: request({
          url: api.login,
          method: 'post',
          hideError: true, // 隐藏全局错误，在输入框下面提示
          data,
        }),
        nextAction: loginSuccess(accountInfo),
      });
    };
  },
  getCurrentUser(nextAction) {
    return {
      type: types.getCurrentUser,
      payload: Promise.resolve(),
      nextAction,
    };
  },
  // fetchMenuList() {
  //   return (dispatch, getState) => {
  //     const { roleType, mchType } = getState().global.profile;
  //     let menu = userMenu;
  //     if (mchType === 2 && roleType === 0) {
  //       menu = superMenu;
  //     } else if (mchType === 2 && roleType === 2) {
  //       menu = superUserMenu;
  //     } else {
  //       menu = roleType === 1 ? normalMenu : userMenu;
  //     }
  //     // console.log(menu);
  //     dispatch({
  //       type: types.fetchMenuList,
  //       payload: Promise.resolve(menu),
  //     });
  //   };
  // },
  fetchMenuList() {
    return (dispatch, getState) => {
      const { roleType, mchType, level } = getState().global.profile;
      let menu = userMenu;
      // let hasTaxi = mchType === 2 || (mchType === 0 && level !== 4);
      let hasTaxi = false;
      if (mchType === 2 && roleType === 0) {
        menu = superMenu;
      } else if (mchType === 2 && roleType === 2) {
        menu = superUserMenu;
      } else {
        menu = roleType === 1 ? normalMenu : userMenu;
      }
      if (mchType === 2) {
        switch (roleType) {
          case 0:
            menu = superMenu;
            break;
          case 1:
            menu = normalMenu;
            break;
          case 2:
            menu = superUserMenu;
            break;
          case 4:
            menu = serviceMenu;
            break;
          case 5:
            hasTaxi = false;
            menu = factoryMenu;
            break;
          case 6:
            menu = financeMenu;
            break;
          case 7:
            hasTaxi = false;
            menu = statisticMenu;
            break;
          default:
            menu = userMenu;
            break;
        }
      } else {
        menu = roleType === 1 ? normalMenu : userMenu;
      }
      menu = menu.concat();
      if (hasTaxi) menu.splice(2, 0, ...taxiItem);
      // getAdAuthList(mchId, mchType).then((hasId) => {
      //   if (hasId) {
      //     menu = menu.concat(adMenu);
      //   }
      // });
      dispatch({
        type: types.fetchMenuList,
        payload: Promise.resolve(menu.concat()),
      });
    };
  },
  getImageToken(isPrivate) {
    return (dispatch, getState) => {
      const { uploadToken, privateUploadToken } = getState().global;
      const token = isPrivate ? privateUploadToken : uploadToken;
      const tokenExpireTime = token.tokenExpireTime;
      if (isExpired(tokenExpireTime)) {
        dispatch(fetchImageToken(false, isPrivate));
      }
    };
  },
  fetchImageToken,
  resetLoginErrInfo() {
    return {
      type: types.resetLoginErrorInfo,
    };
  },
  toggleMPModal,
  updatePassword,
  getImageCode,

  generateUuid,

  getAccountInfo() {
    let payload = cookie.get('accountInfo');
    payload = payload ? JSON.parse(payload) : null;

    return {
      type: types.getAccountFromCookie,
      payload,
    };
  },

  toggleFindPassword,
  findGetSmsCode,
  findCheckSmsCode,
  findResetPassword,
  findGetSmsCodeAgain,
  toggleErrorList,

  getAdAuthList,
  menuAddAdItem,
};

export const reducer = createReducer({
  globalLoading: false, // 该状态在promise middleware中使用
  menuData: {},
  loginData: {},
  loginErr: {},
  uploadToken: {
    result: {
      token: 'error token',
    },
    loading: false,
  },
  privateUploadToken: {
    result: {
      token: 'error token',
    },
    loading: false,
  },
  profile: { name: '未登录' },
  mpVisible: false,
  mpUpdate: {},
  codeData: {},
  accountInfo: {}, // 记住账号密码
  findPasswordVisible: false,
  findPasswordResult: {},
  findPasswordCode: {},
  getMessageCodeResult: {},
  authCode: '00000', //权限码 0可以，1不可以 权限位从左向右,0位:可读后代数据, 1:可读后代报表数据, 2:可改后代数据'
  getAdAuthListResult: {},
}, {

  [types.toggleMPModal](state, { visible, isFirst }) {
    return {
      ...state,
      mpVisible: visible,
      isFirst,
    };
  },
  [types.updatePassword](state, { payload }) {
    return mergeState(state, payload, 'mpUpdate');
  },
  [types.login](state, { payload }) {
    let loginErr = {};
    if (payload.error && payload.error.code > 0) {
      // 91 code, account 92, password 93
      let errType = loginErrCode[payload.error.code] || 'password';
      loginErr = {
        validateStatus: 'error',
        help: payload.error.msg,
        errType,
      };
    }
    return {
      ...state,
      loginData: { ...payload },
      loginErr,
    };
  },
  [types.resetLoginErrorInfo](state) {
    return {
      ...state,
      loginErr: {},
    };
  },
  [types.fetchMenuList](state, { payload }) {
    return {
      ...state,
      menuData: { ...payload },
    };
  },
  [types.getAdAuthList](state, { payload }) {
    return {
      ...state,
      getAdAuthListResult: {
        ...payload,
        result: payload.result && payload.result.cfgValue ? JSON.parse(payload.result.cfgValue || '{}') : [],
      },
    };
  },
  [types.fetchImageToken](state, { payload }) {
    const expireTime = payload.result
      && payload.result.tokenExpireSecond
      && getExpireTime(payload.result.tokenExpireSecond);
    if (expireTime) {
      payload.tokenExpireTime = expireTime;
    }
    return {
      ...state,
      uploadToken: {
        ...state.uploadToken,
        ...payload,
      },
    };
  },
  [types.fetchPrivateImageToken](state, { payload }) {
    const expireTime = payload.result && payload.result.tokenExpireSecond && getExpireTime(payload.result.tokenExpireSecond);
    if (expireTime) {
      payload.tokenExpireTime = expireTime;
    }
    return {
      ...state,
      privateUploadToken: {
        ...state.uploadToken,
        ...payload,
      },
    };
  },
  [types.getCurrentUser](state) {
    const userStr = window.localStorage.getItem(USER_INFO_KEY);
    if (!userStr) return { ...state };
    let profile = JSON.parse(userStr);
    return {
      ...state,
      profile,
      authCode: profile.authBit || '00000',
    };
  },
  [types.showGlobalLoading](state, { payload }) {
    return {
      ...state,
      ...payload,
    };
  },
  [types.getImageCode](state, { payload, key }) {
    return mergeState(state, payload, key);
  },
  [types.cleanLoginForm](state) {
    return {
      ...state,
      accountInfo: {
        ...state.accountInfo,
        password: '',
        code: '',
      },
    };
  },
  [types.getAccountFromCookie](state, { payload }) {
    return mergeState(state, payload, 'accountInfo');
  },
  [types.generateUuid](state, { uuid, key }) {
    return {
      ...state,
      [key]: {
        ...state[key],
        uuid,
      },
    };
  },
  [types.toggleFindPassword](state, { visible }) {
    return {
      ...state,
      findPasswordVisible: visible,
    };
  },
  [types.findGetSmsCode](state, { payload }) {
    return {
      ...state,
      findPasswordResult: payload,
    };
  },
  [types.findCheckSmsCode](state, { payload }) {
    return {
      ...state,
      findPasswordResult: payload,
    };
  },
  [types.findResetPassword](state, { payload }) {
    return {
      ...state,
      findPasswordResult: payload,
    };
  },
  [types.findGetSmsCodeAgain](state, { payload }) {
    return {
      ...state,
      findPasswordResult: payload,
    };
  },
  [types.toggleErrorList](state, { visible }) {
    return {
      ...state,
      errorListVisible: visible,
    };
  },
  [types.menuAddAdItem](state) {
    const menu = state.menuData.result.concat(adMenu);
    return {
      ...state,
      menuData: {
        ...state.menuData,
        result: menu,
      },
    };
  },
});
