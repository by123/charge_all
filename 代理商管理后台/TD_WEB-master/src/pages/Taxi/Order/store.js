import { message } from 'antd';
import * as types from '@/store/action-types';
import { api } from '@/store/api';
import { get, post } from '@/utils/request';
import { parse } from 'query-string';
import { createReducer, mapRowKey, mergeState, formatSelectMchId, formatEmptyListData } from '@/utils';

function formatParams(data) {
  data = parse(data);
  if (data.payType) {
    data.payType = Number(data.payType);
  }
  formatSelectMchId(data, 'lstMchId');
  formatSelectMchId(data, 'lstGroupId');
  return data;
}

function fetchOrderList(data) {
  data = formatParams(data);
  return {
    type: types.fetchTaxiOrderList,
    payload: post(api.fetchTaxiOrderList, Object.assign({ pageSize: 15 }, data)),
  };
}

function fetchOrderDetail(data) {
  return {
    type: types.fetchOrderDetail,
    payload: get(api.orderDetail, data),
  };
}

function toggleRefundModal(visible, current) {
  return {
    type: types.toggleRefundModal,
    visible,
    current: current || {},
  };
}

function toggleDetailModal(visible) {
  return {
    type: types.toggleDetailModal,
    visible,
  };
}

function generateOrderDownloadLink(data, nextAction) {
  data = formatParams(data);
  return {
    type: types.generateOrderDownloadLink,
    payload: post(api.generateOrderDownLoadLink, data),
    nextAction,
  };
}

function cleanDownloadLink() {
  return {
    type: types.generateOrderDownloadLink,
    payload: {},
  };
}

function toggleDownloadReport(visible, nextAction) {
  return {
    type: types.toggleOrderDownloadModal,
    visible,
    nextAction,
  };
}

function getRefundReason() {
  return {
    type: types.getRefundReason,
    payload: get(api.getConfig, { cfgKey0: 'refund_reason', cfgKey1: 'web' }),
  };
}

function changePageId(name, value) {
  return {
    type: types.changePageId,
    name,
    value,
  };
}

function queryPwdList(data, actionType, nextAction) {
  return {
    type: types.queryPwdList,
    payload: get(api.queryPwdList, data),
    actionType,
    nextAction,
  };
}

function toggleQueryPwdModal(visible, disabled) {
  return {
    type: types.toggleQueryPwdModal,
    visible,
    disabled,
  };
}

function toggleQueryPwdResultModal(visible) {
  return {
    type: types.toggleQueryPwdResultModal,
    visible,
  };
}

function queryPwdListByAction(action, nextAction) {
  return (dispatch, getState) => {
    let { startPage, endPage, orderDetail: { result: { tblOrder: { orderId } } }, pwdList } = getState().order;
    let pageId = startPage;
    if (action === 'up') {
      pageId = --startPage;
    }
    if (action === 'down') {
      pageId = ++endPage;
    }
    dispatch(changePageId('pwdListResult', { loading: true, result: {} }));
    get(api.queryPwdList, { pageId, orderId }).then((res) => {
      const { page: { rows = [] } } = res;
      if (action === 'up') {
        pwdList.splice(1, 0, ...rows);
      } else if (action === 'down') {
        pwdList = pwdList.concat(rows);
      } else {
        pwdList = rows;
        // 设置当前密码位的标记
        pwdList[Math.floor((pwdList.length - 1) / 2) - 1].isCurrent = true;
        pwdList.unshift({ isUp: true });
      }
      dispatch(changePageId('pwdList', pwdList.concat()));
      dispatch(changePageId('endPage', endPage));
      dispatch(changePageId('startPage', startPage));
      dispatch(changePageId('pwdListResult', { loading: false, result: res }));
      nextAction && nextAction();
    }).catch(err => {
      console.log(err);
      dispatch(changePageId('startPage', action === 'up' ? startPage + 1 : startPage));
      dispatch(changePageId('endPage', action === 'down' ? endPage - 1 : endPage));
    });
    // dispatch(queryPwdList({ orderId, pageId }), action, nextAction);
  };
}

function changePwdSuccess() {
  return (dispatch) => {
    dispatch(toggleQueryPwdModal(false, false));
    dispatch(toggleQueryPwdResultModal(true));
  };
}

function changePwdLocation(data) {
  return {
    type: types.changePwdLocation,
    payload: post(api.changePwdLocation, data),
    nextAction: changePwdSuccess(),
  };
}

function changePwdSelected(index) {
  return {
    type: types.changePwdSelected,
    index,
  };
}

function resetPwdData() {
  return {
    type: types.resetPwdData,
  };
}

export const action = {
  fetchOrderList,
  fetchOrderDetail,
  toggleRefundModal,
  toggleDetailModal,
  generateOrderDownloadLink,
  cleanDownloadLink,
  toggleDownloadReport,
  getRefundReason,
  toggleQueryPwdModal,
  toggleQueryPwdResultModal,
  queryPwdList,
  changePwdLocation,
  queryPwdListByAction,
  changePwdSelected,
  resetPwdData,
  orderRefund(data) {
    const { orderId } = data;
    return {
      type: types.orderRefund,
      payload: post(api.orderRefund, data),
      nextAction: (dispatch, getState) => {
        const { router, order: { detailVisible } } = getState();
        const { search } = router.location;
        message.success('退款成功');
        dispatch(toggleRefundModal(false));
        if (detailVisible) { // 刷新详情
          dispatch(fetchOrderDetail({ orderId }));
        }
        dispatch(fetchOrderList(search));
      },
    };
  },
};

export const reducer = createReducer({
  orderList: {},
  orderDetail: {},
  refundVisible: false,
  refundData: {},
  current: {},
  detailVisible: false,
  downloadLink: {},
  downloadVisible: false,
  refundReason: {},
  queryPwdVisible: false,
  queryPwdResultVisible: false,
  changePwdResult: {},
  pwdListResult: {},
  startPage: 1,
  endPage: 1,
  pwdList: [],
  queryPwdDisabled: false,
}, {
  [types.fetchTaxiOrderList](state, { payload }) {
    mapRowKey(payload);
    payload = formatEmptyListData(payload);
    return mergeState(state, payload, 'orderList');
  },
  [types.fetchOrderDetail](state, { payload }) {
    return mergeState(state, payload, 'orderDetail');
  },
  [types.toggleRefundModal](state, { visible, current }) {
    return {
      ...state,
      refundVisible: visible,
      current,
    };
  },
  [types.toggleDetailModal](state, { visible }) {
    return {
      ...state,
      detailVisible: visible,
    };
  },
  [types.orderRefund](state, { payload }) {
    return mergeState(state, payload, 'refundData');
  },
  [types.generateOrderDownloadLink](state, { payload }) {
    return {
      ...state,
      downloadLink: payload,
    };
  },
  [types.toggleOrderDownloadModal](state, { visible }) {
    return {
      ...state,
      downloadVisible: visible,
    };
  },
  [types.getRefundReason](state, { payload }) {
    return {
      ...state,
      refundReason: payload,
    };
  },
  [types.toggleQueryPwdModal](state, { visible, disabled }) {
    return {
      ...state,
      queryPwdVisible: visible,
      queryPwdDisabled: disabled,
    };
  },
  [types.toggleQueryPwdResultModal](state, { visible }) {
    return {
      ...state,
      queryPwdResultVisible: visible,
    };
  },
  [types.queryPwdList](state, { payload, actionType }) {
    const { page: { rows = [] } } = payload.result;
    let { pwdList } = state;
    if (actionType === 'up') {
      pwdList.splice(1, 0, ...rows);
    } else if (actionType === 'down') {
      pwdList = pwdList.concat(rows);
    } else {
      pwdList = rows;
      // 设置当前密码位的标记
      pwdList[Math.floor((pwdList.length - 1) / 2) - 1].isCurrent = true;
      pwdList.unshift({ isUp: true });
    }
    return {
      ...state,
      pwdList: pwdList.concat(),
      pwdListResult: payload,
    };
  },
  [types.changePwdLocation](state, { payload }) {
    return {
      ...state,
      changePwdResult: payload,
    };
  },
  [types.changePageId](state, { name, value }) {
    return {
      ...state,
      [name]: value,
    };
  },
  [types.changePwdSelected](state, { index }) {
    let { pwdList } = state;
    pwdList.forEach((val) => {
      val.checked && (val.checked = false);
    });
    pwdList[index].checked = true;
    return {
      ...state,
      pwdList: pwdList.concat(),
    };
  },
  [types.resetPwdData](state) {
    return {
      ...state,
      startPage: 1,
      endPage: 1,
      pwdList: [],
    };
  },
});
