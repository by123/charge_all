import axios from 'axios';
import { parse } from 'query-string';
import { message } from 'antd';
import { AUTH_TOKEN_KEY, USER_INFO_KEY, STATISTIC_KEY } from '../utils/constants';
import { errorHelp } from './enum';

const baseInstance = axios.create();
const authInstance = axios.create();

const getToken = () => {
  return window.localStorage.getItem(AUTH_TOKEN_KEY);
};

const setAuthorization = (token) => {
  authInstance.defaults.headers.common.Authorization = `${token}`;
};

function req(options, byAuth) {
  let instance = baseInstance;
  if (byAuth) {
    setAuthorization(getToken());
    instance = authInstance;
  }
  return instance.request(options).then((res) => {
    if (res.data) {
      /**
       * 转换请求成功的数据结构
       * status @string => code @number
       * @type {{code: number}}
       */
      const result = {
        ...res.data,
        code: +res.data.status,
      };
      return result;
    }
    return Promise.reject({ code: 601, msg: '请求结果异常' }); // 601 请求结果异常，返回的data数据为空
  }, (err) => {
    if (err.response) {
      switch (err.response.status) {
        case 500:
          return Promise.reject({ code: 500, msg: '网络出现异常，请检查您的网络连接是否正常' });
        case 504:
          return Promise.reject({ code: 504, msg: '服务端异常' });
        case 404:
          return Promise.reject({ code: 404, msg: '请求的资源没有找到' });
        default:
          return Promise.reject({ code: 666, msg: '未知错误，请联系管理员' });
      }
    } else {
      return Promise.reject({ code: 600, msg: '网络出现异常，请检查您的网络连接是否正常' });
    }

    // response 为空，网络连接异常 转化成600
    // 500 网络异常或未知原因，检查网络是否正常，否则可能是前端API代理的问题
    // 504 服务端异常，找后端同学解决
    // 404 请求url异常, 没有到后端， 可能是代理问题
  });
}

let lastErrCode = null;
function showError(err) {
  if (err.code && err.code !== lastErrCode && err.msg) {
    lastErrCode = err.code;
    message.error(err.msg || '未知错误', () => {
      lastErrCode = null;
    });
  }
}

// 非授权接口
function request(options, byAuth = false) {
  let { url } = options;
  if (url && !/^http[s]?/.test(url)) {
    options.url = `/api${url}`;
  }
  if (typeof options.data === 'string' && options.data.startsWith('?')) {
    options.data = parse(options.data); // queryString to object
  }
  process.env.PUBLISH_ENV !== 'production' && console.log('request options:', options);
  return req(options, byAuth).then((res) => {
    const { data, code } = res;
    let result = data || {};
    const keys = Object.keys(data || {}) || [];
    let err = res;
    if (code === 0) {
      if (data && keys.includes('rows')) {
        result = {
          dataSource: data.rows || [],
          total: data.totalCount,
          pageSize: data.pageSize,
          current: data.pageId,
          originalData: data,
        };
      }
      process.env.PUBLISH_ENV !== 'production' && console.log('request success:', result);
      return result;
      // 登录过期，重新登录，删除token
    } else if (code === 90) {
      window.localStorage.removeItem(AUTH_TOKEN_KEY);
      window.localStorage.removeItem(USER_INFO_KEY);
    } else if (code === 115) {
      window.localStorage.removeItem(STATISTIC_KEY);
    }
    // 剩下的就是服务端异常的情况了
    return Promise.reject(err); // { msg: 'xxx', code: 10010 }
  }).catch((err) => { // 未知的异常
    process.env.PUBLISH_ENV !== 'production' && console.log('request Error', err);
    !options.hideError && showError(err);
    errorHelp[err.code] && console.warn(errorHelp[err.code]);
    return Promise.reject(err);
  });
}

// 授权接口
function requestByAuth(options) {
  return request(options, true);
}

function get(url, data) {
  if (typeof data === 'string') {
    data = parse(data);
  }
  return requestByAuth({
    url,
    params: data,
  });
}

function post(url, data) {
  if (!data || data === '') {
    data = {};
  }
  return requestByAuth({
    url,
    data,
    method: 'post',
  });
}

const upload = (options) => {
  const instance = axios.create();
  instance.defaults.withCredentials = false;
  const formData = new FormData();
  formData.append('token', options.data.token);
  formData.append('file', options.data.file);
  return instance.post(options.url, formData, {

    // withCredentials: false,
    headers: {
      'Content-Type': 'multiple/form-data',
    },
  }).then((response) => response.data);
};

export {
  request,
  requestByAuth,
  get,
  post,
  upload,
};
