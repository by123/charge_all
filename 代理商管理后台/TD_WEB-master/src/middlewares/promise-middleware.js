import { push } from '@/store/router-helper';
import * as types from '../store/action-types';

const SUCCESS = 'success';
const FAILURE = 'failure';
const PENDING = 'pending';
function isPromise(obj) {
  return obj && typeof obj.then === 'function';
}

function isAction(obj) {
  return !!(obj && obj.type) || typeof obj === 'function';
}


let requestCount = 0;
function requestPending(count) {
  requestCount += count;
  return {
    type: types.showGlobalLoading,
    payload: {
      globalLoading: requestCount > 0,
    },
  };
}

export default function promiseMiddleware({ dispatch }) {
  return (next) => (action) => {
    const { payload, nextAction, ...otherAttr } = action;
    if (!isPromise(payload)) { // 如果不是promise直接交给下一个中间件处理
      return next(action);
    }

    dispatch({ ...action, payload: { loading: true, status: PENDING } });
    process.env.NODE_ENV === 'production' && dispatch(requestPending(1));
    action.payload.then((result) => {
      let ret = {
        loading: false,
        status: SUCCESS,
        result,
      };
      if (result && result.dataSource && result.pageSize) {
        ret = {
          loading: false,
          status: SUCCESS,
          ...result,
        };
      }
      dispatch({
        ...otherAttr,
        payload: ret,
      });
      if (isAction(nextAction)) {
        dispatch(nextAction);
      }
    }, (error) => {
      dispatch({
        ...otherAttr,
        payload: {
          loading: false,
          status: FAILURE,
          error,
        },
      });
      if (error.code === 90) {
        dispatch(push('/login'));
      }
      if (error.code === 115) {
        dispatch(push('/initialize/productionLogin'));
      }
    }).finally(() => {
      process.env.NODE_ENV === 'production' && dispatch(requestPending(-1));
    });
  };
}
