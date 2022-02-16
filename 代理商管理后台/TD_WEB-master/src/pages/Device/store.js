import * as types from '@/store/action-types';
import { api } from '@/store/api';
import { get, post } from '@/utils/request';
import { parse } from 'query-string';
import { createReducer, mergeState, mapRowKey, formatSelectMchId, formatEmptyListData, formatMoney } from '../../utils';

function fetchDeviceList(data) {
  data = parse(data);
  formatSelectMchId(data, 'mchUserId', false);
  return {
    type: types.fetchDeviceList,
    payload: get(api.deviceList, data),
  };
}

function fetchDeviceDetail(id) {
  return {
    type: types.fetchDeviceDetail,
    payload: get(api.deviceDetail, { sn: id }),
    currentSn: id,
  };
}

function queryDevice(data) {
  return {
    type: types.queryDevice,
    payload: get(api.queryDevice, data),
  };
}

function queryDeviceByMchId(data) {
  return {
    type: types.queryDeviceByMchId,
    payload: get(api.queryDeviceByMchId, data),
  };
}

function queryAgent(data, nextAction) {
  return {
    type: types.queryAgent,
    payload: get(api.queryAgent, data),
    nextAction,
  };
}
function filterDevice(ids = []) {
  return {
    type: types.queryDevice,
    payload: Promise.resolve(ids),
  };
}

function toggleAddDeviceModal(visible) {
  return {
    type: types.toggleAddDeviceModal,
    visible,
  };
}

function toggleDeviceResultModal(visible) {
  return {
    type: types.toggleDeviceResultModal,
    visible,
  };
}

function toggleAddResultModal(visible) {
  return {
    type: types.toggleAddResultModal,
    visible,
  };
}

function selectedRow(selectedKeys, selectedDevices) {
  return {
    type: types.selectedDeviceRow,
    selectedKeys,
    selectedDevices,
  };
}

function refreshList() {
  return (dispatch, getState) => {
    const { search } = getState().router.location;
    dispatch(fetchDeviceList(search));
    dispatch(selectedRow([], []));
  };
}

// 立即添加设备
function addDeviceByIds(data) {
  return {
    type: types.addDevice,
    payload: post(api.addDeviceByIds, data),
    nextAction: (dispatch, getState) => {
      dispatch(toggleAddResultModal(true)); // 显示添加设备结果
      if (getState().device.addDevice.result.success.length > 0) {
        // 提交成功，关闭窗口，刷新列表
        dispatch(toggleAddDeviceModal(false));
        dispatch(refreshList());
      }
    },
  };
}

function editDevice(data, nextAction) {
  return {
    type: types.editDevice,
    payload: post(api.editDevice, data),
    nextAction,
  };
}

// function addSuccess() {
//   return (dispatch) => {
//     dispatch(toggleAddDeviceModal(false));
//   };
// }

function toggleEditDeviceModal(visible, currentSn) {
  return {
    type: types.toggleEditDeviceModal,
    visible,
    currentSn,
  };
}

function toggleBindAgentModal(visible) {
  return {
    type: types.toggleBindAgentModal,
    visible,
  };
}

function toggleEditBillingModal(visible) {
  return {
    type: types.toggleEditBillingModal,
    visible,
  };
}

function removeQueryDevice() {
  return {
    type: types.queryDevice,
  };
}

function removeQueryDeviceByMchId() {
  return {
    type: types.queryDeviceByMchId,
  };
}

function removeQueryAgent() {
  return {
    type: types.queryAgent,
  };
}

function transferDeviceBySn(data, nextAction) {
  return {
    type: types.transferDeviceBySn,
    payload: post(api.transferDeviceBySn, data),
    nextAction,
  };
}

function transferDeviceByRange(data, nextAction) {
  return {
    type: types.transferDeviceByRange,
    payload: post(api.transferDeviceByRange, data),
    nextAction,
  };
}

function transferDeviceByBusiness(data, nextAction) {
  return {
    type: types.transferDeviceByBusiness,
    payload: get(api.transferDeviceByBusiness, data),
    nextAction,
  };
}

function untieDeviceBySn(data, nextAction) {
  return {
    type: types.untieDeviceBySn,
    payload: post(api.untieDeviceBySn, data),
    nextAction,
  };
}

function untieDeviceByRange(data, nextAction) {
  return {
    type: types.untieDeviceByRange,
    payload: post(api.untieDeviceByRange, data),
    nextAction,
  };
}

function untieDeviceByBusiness(data, nextAction) {
  return {
    type: types.untieDeviceByBusiness,
    payload: get(api.untieDeviceByBusiness, data),
    nextAction,
  };
}

function toggleUntieDeviceModal(visible) {
  return {
    type: types.toggleUntieDeviceModal,
    visible,
  };
}

function toggleTransferDeviceModal(visible) {
  return {
    type: types.toggleTransferDeviceModal,
    visible,
  };
}

function confirmUntieDevice(isConfirm, nextAction) {
  return {
    type: types.confirmUntieDevice,
    payload: Promise.resolve(isConfirm),
    nextAction,
  };
}

function confirmTransferDevice(isConfirm, nextAction) {
  return {
    type: types.confirmTransferDevice,
    payload: Promise.resolve(isConfirm),
    nextAction,
  };
}

function toggleUntieConfirmModal(visible) {
  return {
    type: types.toggleUntieConfirmModal,
    visible,
  };
}

function toggleTransferConfirmModal(visible) {
  return {
    type: types.toggleTransferConfirmModal,
    visible,
  };
}

function fetchIndustryList() {
  return {
    type: types.fetchIndustryList,
    payload: get(api.getConfig, { cfgKey0: 'industry_default_price_cfg' }),
  };
}

function getMinPrice() {
  return {
    type: types.getMinPrice,
    payload: get(api.getConfig, { cfgKey0: 'min_pay' }),
  };
}

export const action = {
  fetchDeviceList,
  fetchDeviceDetail,
  toggleAddDeviceModal,
  addDeviceByIds,
  toggleEditDeviceModal,
  toggleBindAgentModal,
  toggleEditBillingModal,
  toggleDeviceResultModal,
  toggleAddResultModal,
  selectedRow,
  editDevice,
  refreshList,
  queryDevice,
  queryAgent,
  filterDevice,
  removeQueryDevice,
  removeQueryAgent,
  transferDeviceBySn,
  transferDeviceByRange,
  transferDeviceByBusiness,
  untieDeviceByBusiness,
  untieDeviceByRange,
  untieDeviceBySn,
  queryDeviceByMchId,
  removeQueryDeviceByMchId,
  toggleUntieDeviceModal,
  toggleTransferDeviceModal,
  toggleUntieConfirmModal,
  toggleTransferConfirmModal,
  confirmUntieDevice,
  confirmTransferDevice,
  fetchIndustryList,
  getMinPrice,
};

export const reducer = createReducer({
  deviceList: {},
  deviceDetail: {},
  addModalVisible: false,
  editVisible: false,
  bindAgentVisible: false,
  editBillingVisible: false,
  addDevice: {},
  deviceResultVisible: false,
  addResultVisible: false,
  editDevice: {},
  selectedKeys: [],
  selectedDevices: [],
  queryDevice: {},
  queryDeviceByMchId: {},
  queryAgent: {},
  currentSn: null,
  editDeviceResult: {}, // 新增接口与其他接口返回数据结构不一致，新增变量保存
  untieDeviceVisible: false,
  transferDeviceVisible: false,
  transferConfirmVisible: false,
  untieConfirmVisible: false,
  isUntieConfirm: false,
  isTransferConfirm: false,
  industryList: {},
  getMinPriceResult: {},
}, {
  [types.fetchDeviceList](state, { payload }) {
    mapRowKey(payload);
    payload = formatEmptyListData(payload);
    return mergeState(state, payload, 'deviceList');
  },
  [types.fetchDeviceDetail](state, { payload }) {
    return mergeState(state, payload, 'deviceDetail');
  },
  [types.toggleAddDeviceModal](state, { visible }) {
    return {
      ...state,
      addModalVisible: visible,
    };
  },
  [types.addDevice](state, { payload }) {
    return mergeState(state, payload, 'addDevice');
  },
  [types.toggleEditDeviceModal](state, { visible, currentSn }) {
    return {
      ...state,
      editVisible: visible,
      currentSn,
    };
  },
  [types.toggleDeviceResultModal](state, { visible }) {
    return {
      ...state,
      deviceResultVisible: visible,
    };
  },
  [types.toggleAddResultModal](state, { visible }) {
    return {
      ...state,
      addResultVisible: visible,
    };
  },
  [types.toggleBindAgentModal](state, { visible }) {
    return {
      ...state,
      bindAgentVisible: visible,
    };
  },
  [types.toggleEditBillingModal](state, { visible }) {
    return {
      ...state,
      editBillingVisible: visible,
    };
  },
  [types.selectedDeviceRow](state, { selectedKeys, selectedDevices }) {
    return {
      ...state,
      selectedKeys,
      selectedDevices,
    };
  },
  [types.editDevice](state, { payload = {} }) {
    return mergeState(state, payload, 'editDevice');
  },
  [types.queryDevice](state, { payload = {} }) {
    return {
      ...state,
      queryDevice: payload,
    };
  },
  [types.queryAgent](state, { payload = {} }) {
    return {
      ...state,
      queryAgent: payload,
    };
  },
  [types.transferDeviceBySn](state, { payload = {} }) {
    return {
      ...state,
      editDeviceResult: payload,
    };
  },
  [types.transferDeviceByRange](state, { payload = {} }) {
    return {
      ...state,
      editDeviceResult: payload,
    };
  },
  [types.transferDeviceByBusiness](state, { payload = {} }) {
    return {
      ...state,
      editDeviceResult: {
        ...payload,
        result: [],
        count: payload.result || 0,
      },
    };
  },
  [types.untieDeviceBySn](state, { payload = {} }) {
    return {
      ...state,
      editDeviceResult: payload,
    };
  },
  [types.untieDeviceByRange](state, { payload = {} }) {
    return {
      ...state,
      editDeviceResult: payload,
    };
  },
  [types.untieDeviceByBusiness](state, { payload = {} }) {
    return {
      ...state,
      editDeviceResult: {
        ...payload,
        result: [],
        count: payload.result || 0,
      },
    };
  },
  [types.queryDeviceByMchId](state, { payload = {} }) {
    return {
      ...state,
      queryDeviceByMchId: payload,
    };
  },
  [types.toggleUntieDeviceModal](state, { visible = false }) {
    return {
      ...state,
      untieDeviceVisible: visible,
    };
  },
  [types.toggleTransferDeviceModal](state, { visible }) {
    return {
      ...state,
      transferDeviceVisible: visible,
    };
  },
  [types.toggleUntieConfirmModal](state, { visible }) {
    return {
      ...state,
      untieConfirmVisible: visible,
    };
  },
  [types.toggleTransferConfirmModal](state, { visible }) {
    return {
      ...state,
      transferConfirmVisible: visible,
    };
  },
  [types.confirmTransferDevice](state, { payload }) {
    return {
      ...state,
      isTransferConfirm: payload.result,
    };
  },
  [types.confirmUntieDevice](state, { payload }) {
    return {
      ...state,
      isUntieConfirm: payload.result,
    };
  },
  [types.fetchIndustryList](state, { payload }) {
    const newState = {
      ...state,
      industryList: {
        ...payload,
        result: payload.result && payload.result.cfgValue ? JSON.parse(payload.result.cfgValue) : [],
      },
    };
    return newState;
  },
  [types.getMinPrice](state, { payload }) {
    const minPrice = payload.result && payload.result.cfgValue ? JSON.parse(payload.result.cfgValue) : {};
    if (minPrice.money) {
      minPrice.money = formatMoney(minPrice.money / 100);
    }
    const newState = {
      ...state,
      getMinPriceResult: {
        ...payload,
        result: minPrice.money,
      },
    };
    return newState;
  },
});
