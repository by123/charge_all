
import * as types from '@/store/action-types';
import { api } from '@/store/api';
import { get, post } from '@/utils/request';
import { createReducer, mapRowKey, mergeState, formatEmptyListData } from '../../utils';

// key 值为将数据保存在state的哪个属性下
function getChildrenDeviceUsingCondition(data, key = 'childrenDeviceUsingConditionList') {
  return {
    type: types.getChildrenDeviceUsingCondition,
    payload: get(api.getChildrenDeviceUsingCondition, data),
    key,
  };
}

function getDeviceUsingCondition(data, key = 'deviceUsingConditionList') {
  return {
    type: types.getDeviceUsingCondition,
    payload: get(api.getDeviceUsingCondition, data),
    key,
  };
}

function generateDownloadLink(data, nextAction) {
  return {
    type: types.generateDownloadLink,
    payload: get(api.generateDownloadLink, data),
    nextAction,
  };
}

function cleanDownloadLink() {
  return {
    type: types.generateDownloadLink,
    payload: {},
  };
}

function cleanCoditionData(key) {
  return {
    type: types.getDeviceUsingCondition,
    payload: {},
    key,
  };
}

function fetchDashboard(data) {
  return {
    type: types.fetchDashboard,
    payload: get(api.fetchDashboard, data),
  };
}

function fetchMchDetail(data, nextAction) {
  return {
    type: types.fetchAgentDetail,
    payload: get(api.agentDetail, data),
    nextAction,
  };
}

function getDeviceReportList(data) {
  return {
    type: types.getDeviceReportList,
    payload: get(api.getDeviceReportList, data),
  };
}

function getDeviceReportData(data) {
  return {
    type: types.getDeviceReportData,
    payload: get(api.getDeviceReportData, data),
  };
}

function getAllDeviceReportList(data) {
  return {
    type: types.getAllDeviceReportList,
    payload: get(api.getAllDeviceReportList, data),
  };
}

function getAllDeviceReportData(data) {
  return {
    type: types.getAllDeviceReportData,
    payload: get(api.getAllDeviceReportData, data),
  };
}


function formatListData(payload) {
  if (!payload.dataSource) return payload;
  payload.dataSource = payload.dataSource.map((item) => {
    const dataArray = item.lstNum || [];
    dataArray.reverse().forEach((val, ind) => {
      item[`lstNum${ind}`] = val;
    });
    return item;
  });
  return payload;
}

function generateDeviceReport(data, nextAction) {
  return {
    type: types.generateDeviceReport,
    payload: post(api.generateDeviceReport, data),
    nextAction,
  };
}

export const action = {
  getChildrenDeviceUsingCondition,
  getDeviceUsingCondition,
  generateDownloadLink,
  cleanDownloadLink,
  cleanCoditionData,
  fetchDashboard,
  fetchMchDetail,
  getDeviceReportList,
  getDeviceReportData,
  getAllDeviceReportList,
  getAllDeviceReportData,
  generateDeviceReport,
};

export const reducer = createReducer({
  childrenDeviceUsingConditionList: {},
  deviceUsingConditionList: {},
  downloadLink: {},
  coditionByDate: {},
  childConditionByDate: {},
  dashboardResult: {},
  agentDetailResult: {},
  getDeviceReportListResult: {},
  getDeviceReportDataResult: {},
  getAllDeviceReportListResult: {},
  getAllDeviceReportDataResult: {},
  generateDeviceReportResult: {},
}, {
  [types.getChildrenDeviceUsingCondition](state, { payload, key }) {
    mapRowKey(payload);
    payload = formatEmptyListData(payload);
    return mergeState(state, payload, key);
  },
  [types.getDeviceUsingCondition](state, { payload, key }) {
    return {
      ...state,
      [key]: payload,
    };
  },
  [types.generateDownloadLink](state, { payload }) {
    return {
      ...state,
      downloadLink: payload,
    };
  },
  [types.fetchDashboard](state, { payload }) {
    return {
      ...state,
      dashboardResult: payload,
    };
  },
  [types.fetchAgentDetail](state, { payload }) {
    return {
      ...state,
      agentDetailResult: payload,
    };
  },
  [types.getDeviceReportList](state, { payload }) {
    const newPayload = formatListData(payload);
    return mergeState(state, newPayload, 'getDeviceReportListResult');
  },
  [types.getDeviceReportData](state, { payload }) {
    return mergeState(state, payload, 'getDeviceReportDataResult');
  },
  [types.getAllDeviceReportList](state, { payload }) {
    return mergeState(state, payload, 'getDeviceReportListResult');
  },
  [types.getAllDeviceReportData](state, { payload }) {
    return mergeState(state, payload, 'getAllDeviceReportDataResult');
  },
  [types.generateDeviceReport](state, { payload }) {
    return mergeState(state, payload, 'generateDeviceReportResult');
  },
});
