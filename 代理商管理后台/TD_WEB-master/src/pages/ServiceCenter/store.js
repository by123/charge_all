
import * as types from '@/store/action-types';
import { api } from '@/store/api';
import { get, post } from '@/utils/request';
import isObject from 'lodash/isObject';
import { parse } from 'query-string';
import { message } from 'antd';
import {
  createReducer,
  mapRowKey,
  mergeState,
  formatEmptyListData,
  formatSelectMchId,
} from '../../utils';

function getComplainList(data) {
  if (isObject(data) && !data.pageSize) {
    data.pageSize = 15;
  }
  return {
    type: types.getComplainList,
    payload: get(api.getComplainList, data),
  };
}

function toggleComplainDetailModal(visible) {
  return {
    type: types.toggleComplainDetailModal,
    visible,
  };
}

function viewComplainDetails(data) {
  return {
    type: types.viewComplainDetails,
    payload: get(api.viewComplainDetails, data),
  };
}

function refreshList() {
  return (dispatch, getState) => {
    const { query } = getState().router.location;
    dispatch(getComplainList(query));
  };
}

function changeStateSuccess() {
  return (dispatch) => {
    dispatch(toggleComplainDetailModal(false));
    dispatch(refreshList());
  };
}

function changeComplainState(data) {
  return {
    type: types.changeComplainState,
    payload: post(api.changeComplainState, data),
    nextAction: changeStateSuccess(),
  };
}

function toggleRefundModal(visible, current) {
  return {
    type: types.toggleRefundModal,
    visible,
    current: current || {},
  };
}

function orderRefund(data) {
  return {
    type: types.orderRefund,
    payload: post(api.orderRefund, data),
    nextAction: (dispatch, getState) => {
      const { serviceCenter: { visible, current: { complaintId } } } = getState();
      message.success('退款成功');
      dispatch(toggleRefundModal(false));
      if (visible) { // 刷新详情
        dispatch(viewComplainDetails({ complaintId }));
      }
      // dispatch(fetchOrderList(search));
    },
  };
}

function toggleCustomerModal(visible) {
  return {
    type: types.toggleCustomerModal,
    visible,
  };
}

function addTelComplain(data, nextAction) {
  return {
    type: types.addTelComplain,
    payload: post(api.addTelComplain, data),
    nextAction,
  };
}

function delTelComplain(data, nextAction) {
  return {
    type: types.delTelComplain,
    payload: get(api.delTelComplain, data),
    nextAction,
  };
}

function getTelComplainDetail(data) {
  return {
    type: types.getTelComplainDetail,
    payload: get(api.getTelComplainDetail, data),
  };
}

function modTelComplain(data, nextAction) {
  return {
    type: types.modTelComplain,
    payload: post(api.modTelComplain, data),
    nextAction,
  };
}

function getTelComplainList(data) {
  data = parse(data);
  formatSelectMchId(data, 'mchId');
  if (data.mchId) {
    let mchId = data.mchId[0];
    if (mchId.charAt(0) === '$') {
      mchId = mchId.slice(1);
      delete data.mchId;
    }
    data.mchId = mchId;
  }
  return {
    type: types.getTelComplainList,
    payload: post(api.getTelComplainList, data),
  };
}

function refreshTelComplainList() {
  return (dispatch, getState) => {
    const { query } = getState().router.location;
    dispatch(getTelComplainList(query));
  };
}

function getProblemList() {
  return {
    type: types.getProblemList,
    payload: get(api.getConfig, { cfgKey0: 'complain_problem_type' }),
  };
}

function getAllCustomer() {
  return {
    type: types.getAllCustomer,
    payload: get(api.allUsers, { roleType: 4 }),
  };
}

function toggleDeleteModal(visible) {
  return {
    type: types.toggleDeleteComplainModal,
    visible,
  };
}

function togglePhoneResolveDetail(visible, complainId, editType) {
  return {
    type: types.togglePhoneResolveDetail,
    visible,
    editType,
    complainId,
  };
}

function getCompainTypeStats(data) {
  return {
    type: types.getCompainTypeStats,
    payload: api.getCompainTypeStats(data),
  };
}

function getDeviceProblemStats(data) {
  return {
    type: types.getDeviceProblemStats,
    payload: api.getDeviceProblemStats(data),
  };
}

function getComplainVersionStats(data) {
  return {
    type: types.getComplainVersionStats,
    payload: api.getComplainVersionStats(data),
  };
}

function getTelRecordStats(data) {
  return {
    type: types.getTelRecordStats,
    payload: api.getTelRecordStats(data),
  };
}

function getTelResolveStats(data) {
  return {
    type: types.getTelResolveStats,
    payload: api.getTelResolveStats(data),
  };
}

function getTelCustomerStats(data) {
  return {
    type: types.getTelCustomerStats,
    payload: api.getTelCustomerStats(data),
  };
}

function modTelRecordStats(data, nextAction) {
  return {
    type: types.modTelRecordStats,
    payload: api.modTelRecordStats(data),
    nextAction,
  };
}

function applyDownloadComplain(data, nextAction) {
  return {
    type: types.applyDownloadComplain,
    payload: api.applyDownloadComplain(data),
    nextAction,
  };
}

function formatListData(payload) {
  if (!payload || !payload.dataSource || !payload.dataSource.length) return;
  const rows = payload.dataSource;
  payload.dataSource = rows.map(item => {
    const data = JSON.parse(item.content || '{}');
    return {
      ...item,
      ...data,
    };
  });
}

export const action = {
  getComplainList,
  toggleComplainDetailModal,
  viewComplainDetails,
  changeComplainState,
  refreshList,
  orderRefund,
  toggleRefundModal,

  toggleCustomerModal,
  addTelComplain,
  delTelComplain,
  getTelComplainDetail,
  modTelComplain,
  getTelComplainList,
  getProblemList,
  getAllCustomer,
  toggleDeleteModal,
  togglePhoneResolveDetail,

  getCompainTypeStats,
  getDeviceProblemStats,
  getComplainVersionStats,
  getTelRecordStats,
  getTelResolveStats,
  getTelCustomerStats,
  modTelRecordStats,
  applyDownloadComplain,
  refreshTelComplainList,
};

export const reducer = createReducer({
  complainList: {},
  visible: false,
  viewComplainDetails: {},
  changeStateRusult: {},
  refundVisible: false,
  refundData: {},
  current: {},

  customerModalVisible: false,
  getTelComplainListResult: {},
  editTelComplainResult: {},
  getTelComplainDetailResult: {},
  getProblemListResult: {},
  getAllCustomerResult: {},
  deleteModalVisible: false,
  phoneResolveDetailVisible: false,
  editType: '',

  getCompainTypeStatsResult: {},
  getDeviceProblemStatsResult: {},
  getComplainVersionStatsResult: {},
  getTelRecordStatsResult: {},
  getTelResolveStatsResult: {},
  getTelCustomerStatsResult: {},
  modTelRecordStatsResult: {},
  applyDownloadComplainResult: {},
}, {
  [types.getComplainList](state, { payload }) {
    mapRowKey(payload);
    payload = formatEmptyListData(payload);
    return mergeState(state, payload, 'complainList');
  },
  [types.toggleComplainDetailModal](state, { visible }) {
    return {
      ...state,
      visible,
    };
  },
  [types.viewComplainDetails](state, { payload }) {
    return {
      ...state,
      viewComplainDetails: payload,
    };
  },
  [types.changeComplainState](state, { payload }) {
    return {
      ...state,
      changeStateRusult: payload,
    };
  },
  [types.toggleRefundModal](state, { visible, current }) {
    return {
      ...state,
      refundVisible: visible,
      current,
    };
  },
  [types.orderRefund](state, { payload }) {
    return {
      ...state,
      refundData: payload,
    };
  },
  [types.toggleCustomerModal](state, { visible }) {
    return {
      ...state,
      customerModalVisible: visible,
    };
  },
  [types.addTelComplain](state, { payload }) {
    return mergeState(state, payload, 'editTelComplainResult');
  },
  [types.modTelComplain](state, { payload }) {
    return mergeState(state, payload, 'editTelComplainResult');
  },
  [types.delTelComplain](state, { payload }) {
    return mergeState(state, payload, 'editTelComplainResult');
  },
  [types.getTelComplainDetail](state, { payload }) {
    return mergeState(state, payload, 'getTelComplainDetailResult');
  },
  [types.getTelComplainList](state, { payload }) {
    mapRowKey(payload);
    return mergeState(state, payload, 'getTelComplainListResult');
  },
  [types.getProblemList](state, { payload }) {
    return {
      ...state,
      getProblemListResult: {
        ...payload,
        result: payload.result && payload.result.cfgValue ? JSON.parse(payload.result.cfgValue) : {},
      },
    };
  },
  [types.getAllCustomer](state, { payload }) {
    return mergeState(state, payload, 'getAllCustomerResult');
  },
  [types.toggleDeleteComplainModal](state, { visible }) {
    return {
      ...state,
      deleteModalVisible: visible,
    };
  },
  [types.togglePhoneResolveDetail](state, { visible, editType, complainId }) {
    return {
      ...state,
      phoneResolveDetailVisible: visible,
      editType,
      complainId,
    };
  },
  [types.getCompainTypeStats](state, { payload }) {
    formatListData(payload);
    console.log('payload ', payload);
    return mergeState(state, payload, 'getCompainTypeStatsResult');
  },
  [types.getDeviceProblemStats](state, { payload }) {
    formatListData(payload);
    return mergeState(state, payload, 'getDeviceProblemStatsResult');
  },
  [types.getComplainVersionStats](state, { payload }) {
    formatListData(payload);
    return mergeState(state, payload, 'getComplainVersionStatsResult');
  },
  [types.getTelRecordStats](state, { payload }) {
    formatListData(payload);
    return mergeState(state, payload, 'getTelRecordStatsResult');
  },
  [types.getTelResolveStats](state, { payload }) {
    formatListData(payload);
    return mergeState(state, payload, 'getTelResolveStatsResult');
  },
  [types.getTelCustomerStats](state, { payload }) {
    formatListData(payload);
    return mergeState(state, payload, 'getTelCustomerStatsResult');
  },
  [types.modTelRecordStats](state, { payload }) {
    return mergeState(state, payload, 'modTelRecordStatsResult');
  },
  [types.applyDownloadComplain](state, { payload }) {
    return mergeState(state, payload, 'applyDownloadComplainResult');
  },
});
