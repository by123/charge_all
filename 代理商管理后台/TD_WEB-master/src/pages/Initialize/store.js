import * as types from '@/store/action-types';
import { api } from '@/store/api';
import { get, post } from '@/utils/request';
import { message } from 'antd';
import { replace } from '../../store/router-helper';
import { createReducer, mapRowKey, mergeState, formatEmptyListData } from '../../utils';
import { STATISTIC_KEY, ADD } from '../../utils/constants';

function fetchDeviceInitList(data) {
  return {
    type: types.fetchDeviceInitList,
    payload: get(api.getDevicePublishTaskResult, data),
  };
}

function fetchDeviceInitDetail(data) {
  return {
    type: types.fetchDeviceInitDetail,
    payload: get(api.deviceInitDetail, data),
  };
}

function getFirstLevelMch(data) {
  return {
    type: types.getFirstLevelMch,
    payload: get(api.getFirstLevelMch, data),
  };
}

function toggleDeviceInitDetailModal(visible) {
  return {
    type: types.toggleDeviceInitDetailModal,
    visible,
  };
}

function initDevice(data, nextAction) {
  return {
    type: types.createDevicePublishTask,
    payload: post(api.createDevicePublishTask, data),
    nextAction,
  };
}

function queryFirstAgent(data) {
  return {
    type: types.queryFirstAgent,
    payload: get(api.getFirstLevelMch, data),
  };
}

function toggleDeviceDelete(visible) {
  return {
    type: types.toggleDeviceDelete,
    visible,
  };
}

function toggleDeleteDeviceFail(visible) {
  return {
    type: types.toggleDeleteDeviceFail,
    visible,
  };
}

function deleteDevice(data, nextAction) {
  return {
    type: types.deleteDevice,
    payload: post(api.deleteDevice, data),
    nextAction,
  };
}

function clearErrorList() {
  return {
    type: types.deleteDevice,
    payload: Promise.resolve([]),
  };
}

// 生产统计头部
function getStatisticsData(data) {
  return {
    type: types.getStatisticsData,
    payload: get(api.getStatisticsData, data),
  };
}

// 生产统计列表
function getStatisticsList(data) {
  return {
    type: types.getStatisticsList,
    payload: get(api.getStatisticsList, data),
  };
}

// 上报计划头部数据
function getPlanData(data) {
  return {
    type: types.getPlanData,
    payload: get(api.getPlanData, data),
  };
}

// 上报计划列表数据
function getPlanList(data) {
  return {
    type: types.getPlanList,
    payload: get(api.getPlanList, data),
  };
}

// 更新上报计划列表数据
function postPlanList(id, random, data, nextAction) {
  return {
    type: types.postPlanList,
    payload: post(api.postPlanList(id, random), data),
    nextAction,
  };
}

// 上报发货头部数据
function getDeliverData(data) {
  return {
    type: types.getDeliverData,
    payload: get(api.getDeliverData, data),
  };
}

// 上报发货列表数据
function getDeliverList(data) {
  return {
    type: types.getDeliverList,
    payload: get(api.getDeliverList, data),
  };
}

// 更新生产发货列表
function postDeliverList(id, random, data, nextAction) {
  return {
    type: types.postDeliverList,
    payload: post(api.postDeliverList(id, random), data),
    nextAction,
  };
}

function loginSuccess() {
  return (dispatch) => {
    dispatch(replace('/initialize/productionStatistic'));
  };
}

function productionAuth(data) {
  return {
    type: types.productionAuth,
    payload: get(api.productionAuth, data),
    nextAction: loginSuccess(),
  };
}

function getFactoryList(data, nextAction) {
  return {
    type: types.getFactoryList,
    payload: get(api.getFactoryList, data),
    nextAction,
  };
}

function fetchSnConfigList(data) {
  return {
    type: types.fetchSnConfigList,
    payload: get(api.fetchSnConfigList, data),
  };
}

function refreshSnConfigList() {
  return (dispatch, getState) => {
    const { search } = getState().router.location;
    dispatch(fetchSnConfigList(search));
  };
}

function deleteSnConfig(data, nextAction) {
  return {
    type: types.deleteSnConfig,
    payload: get(api.deleteSnConfig, data),
    nextAction,
  };
}

function toggleAddModal(visible, editType, record) {
  return {
    type: types.toggleAddSnConfigModal,
    visible,
    editType,
    selectedRowData: record,
  };
}

function addSnConfigSuccess(editType) {
  return (dispatch) => {
    message.success(`${editType === ADD ? '添加' : '编辑'}SN号成功`);
    dispatch(toggleAddModal(false));
    dispatch(refreshSnConfigList());
  };
}

function editSnConfig(data, editType) {
  return {
    type: types.addSnConfig,
    payload: get(api[editType === ADD ? 'addSnConfig' : 'editSnConfig'], data),
    nextAction: addSnConfigSuccess(editType),
  };
}

function getVersionList() {
  return {
    type: types.getVersionList,
    payload: get(api.getVersionList),
  };
}

function allocateDeviceBySn(data, nextAction) {
  return {
    type: types.allocateDeviceBySn,
    payload: post(api.allocateDeviceBySn, data),
    nextAction,
  };
}

function allocateDeviceBySection(data, nextAction) {
  return {
    type: types.allocateDeviceBySection,
    payload: post(api.allocateDeviceBySection, data),
    nextAction,
  };
}

function allocateDeviceByFile(data, nextAction, mchId) {
  return {
    type: types.allocateDeviceByFile,
    payload: post(api.allocateDeviceByFile(mchId), data),
    nextAction,
  };
}

function recallDeviceByFile(data, nextAction) {
  return {
    type: types.recallDeviceByFile,
    payload: post(api.recallDeviceByFile, data),
    nextAction,
  };
}

export const action = {
  fetchDeviceInitList,
  getFirstLevelMch,
  toggleDeviceInitDetailModal,
  fetchDeviceInitDetail,
  initDevice,
  queryFirstAgent,
  toggleDeviceDelete,
  deleteDevice,
  toggleDeleteDeviceFail,
  clearErrorList,

  getStatisticsData,
  getStatisticsList,
  getPlanData,
  getPlanList,
  postPlanList,
  getDeliverData,
  getDeliverList,
  postDeliverList,
  productionAuth,
  getFactoryList,

  fetchSnConfigList,
  refreshSnConfigList,
  deleteSnConfig,
  editSnConfig,
  toggleAddModal,
  getVersionList,

  allocateDeviceBySn,
  allocateDeviceBySection,
  allocateDeviceByFile,

  recallDeviceByFile,
};

export const reducer = createReducer({
  deviceInitList: {},
  deviceInitDetail: {},
  firstLevelMch: [],
  DeviceInitdetailVisible: false,
  initDevice: false,
  queryFirstAgentList: {},
  deleteResult: {},
  deleteModalVisible: false,
  deleteFailVisible: false,

  statisticsData: {}, // 今日生产统计
  statisticsList: {},
  planData: {},
  planList: {},
  postPlanListResult: {},
  deliverData: {},
  deliverList: {},
  postDeliverListResult: {},
  productionLoginResult: {},
  factoryListResult: {}, // 工厂列表

  addSnConfigResult: {},
  editSnConfigResult: {},
  deleteSnConfigResult: {},
  snConfigListResult: {},
  addSnConfigVisible: false,
  editType: '',
  selectedRowData: {},
  versionListResult: {},

  allocateDeviceResult: {},
  recallDeviceResult: {},
}, {
  [types.fetchDeviceInitList](state, { payload }) {
    mapRowKey(payload);
    payload = formatEmptyListData(payload);
    return mergeState(state, payload, 'deviceInitList');
  },
  [types.getFirstLevelMch](state, { payload }) {
    mapRowKey(payload);
    payload = formatEmptyListData(payload);
    return mergeState(state, payload, 'firstLevelMch');
  },
  [types.fetchDeviceInitDetail](state, { payload }) {
    return mergeState(state, payload, 'deviceInitDetail');
  },
  [types.toggleDeviceInitDetailModal](state, { visible }) {
    return {
      ...state,
      DeviceInitdetailVisible: visible,
    };
  },
  [types.createDevicePublishTask](state, { payload }) {
    return {
      ...state,
      initDevice: payload.status === 'success',
    };
  },
  [types.queryFirstAgent](state, { payload = {} }) {
    return {
      ...state,
      queryFirstAgentList: payload,
    };
  },
  [types.toggleDeviceDelete](state, { visible }) {
    return {
      ...state,
      deleteModalVisible: visible,
    };
  },
  [types.deleteDevice](state, { payload }) {
    return mergeState(state, payload, 'deleteResult');
  },
  [types.toggleDeleteDeviceFail](state, { visible }) {
    return {
      ...state,
      deleteFailVisible: visible,
    };
  },
  [types.getStatisticsData](state, { payload }) {
    return mergeState(state, payload, 'statisticsData');
  },
  [types.getStatisticsList](state, { payload }) {
    return mergeState(state, payload, 'statisticsList');
  },
  [types.getPlanData](state, { payload }) {
    return mergeState(state, payload, 'planData');
  },
  [types.getPlanList](state, { payload }) {
    return mergeState(state, payload, 'planList');
  },
  [types.postPlanList](state, { payload }) {
    return mergeState(state, payload, 'postPlanListResult');
  },
  [types.getDeliverData](state, { payload }) {
    return mergeState(state, payload, 'deliverData');
  },
  [types.getDeliverList](state, { payload }) {
    return mergeState(state, payload, 'deliverList');
  },
  [types.postDeliverList](state, { payload }) {
    return mergeState(state, payload, 'postDeliverListResult');
  },
  [types.productionAuth](state, { payload }) {
    if (payload.result) {
      localStorage.setItem(STATISTIC_KEY, payload.result.random);
    }
    return mergeState(state, payload, 'productionLoginResult');
  },
  [types.getFactoryList](state, { payload }) {
    return mergeState(state, payload, 'factoryListResult');
  },
  [types.fetchSnConfigList](state, { payload }) {
    mapRowKey(payload);
    return mergeState(state, payload, 'snConfigListResult');
  },
  [types.addSnConfig](state, { payload }) {
    return mergeState(state, payload, 'addSnConfigResult');
  },
  [types.deleteSnConfig](state, { payload }) {
    return mergeState(state, payload, 'deleteSnConfigResult');
  },
  [types.toggleAddSnConfigModal](state, { visible, editType, selectedRowData }) {
    return {
      ...state,
      addSnConfigVisible: visible,
      editType,
      selectedRowData,
    };
  },
  [types.getVersionList](state, { payload }) {
    return mergeState(state, payload, 'versionListResult');
  },
  [types.allocateDeviceBySn](state, { payload }) {
    return mergeState(state, payload, 'allocateDeviceResult');
  },
  [types.allocateDeviceBySection](state, { payload }) {
    return mergeState(state, payload, 'allocateDeviceResult');
  },
  [types.allocateDeviceByFile](state, { payload }) {
    return mergeState(state, payload, 'allocateDeviceResult');
  },
  [types.recallDeviceByFile](state, { payload }) {
    return mergeState(state, payload, 'recallDeviceResult');
  },
});
