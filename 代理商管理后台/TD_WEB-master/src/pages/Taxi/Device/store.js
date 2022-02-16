import * as types from '@/store/action-types';
import { api } from '@/store/api';
import { get, post } from '@/utils/request';
import { createReducer, mergeState, mapRowKey, formatEmptyListData } from '@/utils';
import { message } from 'antd';

function fetchTaxiDeviceList(data) {
  // data = parse(data);
  // formatSelectMchId(data, 'mchUserId', false);
  return {
    type: types.fetchTaxiDeviceList,
    payload: get(api.fetchTaxiDeviceList, data),
  };
}

function fetchDeviceDetail(id) {
  return {
    type: types.fetchDeviceDetail,
    payload: get(api.queryTaxiDeviceDetail, { sn: id }),
    currentSn: id,
  };
}

function queryTaxiDeviceList(data) {
  return {
    type: types.queryTaxiDeviceList,
    payload: get(api.queryTaxiDeviceList, data),
  };
}

function queryDeviceByMchId(data) {
  return {
    type: types.queryDeviceByMchId,
    payload: get(api.queryDeviceByMchId, data),
  };
}

function queryGroup(data, nextAction) {
  return {
    type: types.queryGroup,
    payload: post(api.fetchGroupListAll, data),
    nextAction,
  };
}

function filterDevice(ids = []) {
  return {
    type: types.queryTaxiDeviceList,
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
    dispatch(fetchTaxiDeviceList(search));
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

function addTaxiDeviceBySn(data, nextAction) {
  return {
    type: types.addTaxiDeviceBySn,
    payload: post(api.addToGroupBySnList, data),
    nextAction,
  };
}

function addTaxiDeviceByRange(data, nextAction) {
  return {
    type: types.addTaxiDeviceByRange,
    payload: post(api.addToGroupByRange, data),
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
    type: types.queryTaxiDeviceList,
  };
}

function removeQueryDeviceByMchId() {
  return {
    type: types.queryDeviceByMchId,
  };
}

function removeQueryAgent() {
  return {
    type: types.queryGroup,
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
function transferDeviceByGroup(data, nextAction) {
  return {
    type: types.transferDeviceByGroup,
    payload: post(api.transferDeviceByGroup, data),
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

function queryAgent(data, nextAction) {
  return {
    type: types.queryAgent,
    payload: get(api.queryAgent, data),
    nextAction,
  };
}

function cleanErrorList() {
  return {
    type: types.cleanErrorList,
  };
}

function editSuccess() {
  return (dispatch) => {
    message.success('设备编辑成功');
    dispatch(toggleEditDeviceModal(false));
    dispatch(refreshList());
  };
}

function editDevice(data) {
  return {
    type: types.editTaxiDevice,
    payload: post(api.updateTaxiDeviceInfo, data),
    nextAction: editSuccess(),
  };
}

export const action = {
  fetchTaxiDeviceList,
  fetchDeviceDetail,
  toggleAddDeviceModal,
  addDeviceByIds,
  queryAgent,
  cleanErrorList,
  editDevice,

  toggleEditDeviceModal,
  toggleBindAgentModal,
  toggleEditBillingModal,
  toggleDeviceResultModal,
  toggleAddResultModal,
  selectedRow,
  addTaxiDeviceBySn,
  addTaxiDeviceByRange,
  refreshList,
  queryTaxiDeviceList,
  queryGroup,
  filterDevice,
  removeQueryDevice,
  removeQueryAgent,
  transferDeviceBySn,
  transferDeviceByRange,
  transferDeviceByGroup,
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
  addToGroupResult: {},
  selectedKeys: [],
  selectedDevices: [],
  queryDeviceResult: {},
  queryDeviceByMchId: {},
  groupList: {}, // 所有分组列表
  currentSn: null,
  editDeviceResult: {}, // 新增接口与其他接口返回数据结构不一致，新增变量保存
  untieDeviceVisible: false,
  transferDeviceVisible: false,
  transferConfirmVisible: false,
  untieConfirmVisible: false,
  isUntieConfirm: false,
  isTransferConfirm: false,

  queryAgent: {},
  isHasGroupChecked: false,
  hasGroup: false,
}, {
  [types.fetchTaxiDeviceList](state, { payload }) {
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
  [types.addTaxiDeviceBySn](state, { payload = {} }) {
    return mergeState(state, payload, 'editDeviceResult');
  },
  [types.addTaxiDeviceByRange](state, { payload = {} }) {
    return mergeState(state, payload, 'editDeviceResult');
  },
  [types.queryTaxiDeviceList](state, { payload = {} }) {
    return {
      ...state,
      queryDeviceResult: payload,
    };
  },
  [types.queryGroup](state, { payload = {} }) {
    return {
      ...state,
      groupList: payload,
      isHasGroupChecked: true,
      hasGroup: payload.result && !!payload.result.length,
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
  [types.transferDeviceByGroup](state, { payload = {} }) {
    return {
      ...state,
      editDeviceResult: payload,
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
  [types.queryAgent](state, { payload = {} }) {
    return {
      ...state,
      queryAgent: payload,
    };
  },
  [types.cleanErrorList](state) {
    return {
      ...state,
      editDeviceResult: {},
    };
  },
});
