import { message } from 'antd';
import * as types from '@/store/action-types';
import { api } from '@/store/api';
import { parse } from 'query-string';
import { get, post, requestByAuth } from '@/utils/request';
import { createReducer, mergeState, mapRowKey, formatSelectMchId, formatEmptyListData } from '@/utils';
import { ADD, EDIT } from '@/utils/constants';
import { action as PersonActions } from '../../Personnel/store';
import { action as taxiDeviceActions } from '../Device/store';

function removeAddedStore() {
  return {
    type: types.removeAddedStore,
  };
}

function toggleAddGroupModal(visible, editType) {
  return (dispatch) => {
    dispatch({
      type: types.toggleAddGroupModal,
      visible,
      editType,
    });
  };
}

function toggleAccountInfoModal(visible) {
  return {
    type: types.toggleAccountInfoModal,
    visible,
  };
}

function toggleAddProfitModal(visible) {
  return {
    type: types.toggleAddProfitModal,
    visible,
  };
}

function toggleErrorListModal(visible) {
  return {
    type: types.toggleErrorListModal,
    visible,
  };
}

function fetchGroupList(data) {
  data = parse(data);
  formatSelectMchId(data, 'lstMchId');
  if (data.lstMchId) {
    let parentMchId = data.lstMchId[0];
    if (parentMchId.charAt(0) === '$') {
      data.parentMchid = parentMchId.slice(1);
      delete data.lstMchId;
    }
  }
  return {
    type: types.fetchGroupList,
    payload: post(api.fetchGroupList, Object.assign({ pageSize: 15 }, data)),
  };
}

function fetchGroupDetail(id, nextAction) {
  return {
    type: types.fetchGroupDetail,
    payload: get(api.fetchGroupDetail(id)),
    nextAction,
  };
}

function removeAgentDetail() {
  return {
    type: types.removeAgentDetail,
  };
}

function selectedRow(selectedKeys, selectedAgents) {
  return {
    type: types.selectedAgentRow,
    selectedKeys,
    selectedAgents,
  };
}

function editSuccess() {
  return (dispatch, getState) => {
    const { router: { location } } = getState();
    dispatch(toggleAddGroupModal(false));
    dispatch(removeAgentDetail());
    message.success('保存成功');
    dispatch(fetchGroupList(location.search));
  };
}
function addSuccess() {
  return (dispatch) => {
    dispatch(toggleAccountInfoModal(true));
    dispatch(taxiDeviceActions.queryGroup());
  };
}

function updateProfitSuccess() {
  return (dispatch, getState) => {
    const { router: { location } } = getState();
    dispatch(toggleAddProfitModal(false));
    dispatch(selectedRow([], []));
    dispatch(fetchGroupList(location.search));
    message.success('批量修改分润比例成功');
  };
}

function fetchSelfInfo() {
  return (dispatch, getState) => {
    const { mchId } = getState().global.profile; // 代理商自己的
    dispatch({
      type: types.fetchSelfInfo,
      payload: get(api.agentDetail, { mchId }),
    });
  };
}
function editBizRule(data, nextAction) {
  return (dispatch) => {
    dispatch({
      type: types.editBizRule,
      payload: post(api.editBizRule, data),
      nextAction,
    });
  };
}

function getTaxiConfig(nextAction) {
  return (dispatch) => {
    dispatch({
      type: types.getTaxiConfig,
      payload: get(api.getConfig, { cfgKey0: 'taxi_device_config' }),
      nextAction,
    });
  };
}

function addChainBiz(data) {
  return {
    type: types.addChainBiz,
    payload: post(api.addChainBiz, data),
  };
}

function changeAgentType(agentType) {
  return {
    type: types.changeAgentType,
    agentType,
  };
}

function toggleNoGroupModal(visible) {
  return {
    type: types.toggleNoGroupModal,
    visible,
  };
}

export const action = {
  fetchGroupList,
  fetchGroupDetail,
  selectedRow,
  fetchSelfInfo,
  editBizRule,
  addChainBiz,
  changeAgentType,
  getTaxiConfig,
  toggleNoGroupModal,
  showAddGroup() {
    return (dispatch) => {
      dispatch(fetchSelfInfo());
      dispatch(PersonActions.fetchAllUsers());
      dispatch(removeAgentDetail());
      dispatch(toggleAddGroupModal(true, ADD));
    };
  },
  showEditAgent(id) {
    return (dispatch) => {
      dispatch(fetchGroupDetail(id));
      dispatch(fetchSelfInfo());
      dispatch(PersonActions.fetchAllUsers());
      dispatch(toggleAddGroupModal(true, EDIT));
    };
  },
  showAddProfitModal() {
    return (dispatch) => {
      dispatch(fetchSelfInfo());
      dispatch(toggleAddProfitModal(true));
    };
  },
  closeModalAndRefresh() {
    return (dispatch, getState) => {
      const { router: { location } } = getState();
      dispatch(toggleAccountInfoModal(false));
      dispatch(toggleAddGroupModal(false));
      dispatch(removeAgentDetail());
      dispatch(removeAddedStore());
      dispatch(fetchGroupList(location.search));
    };
  },
  toggleAccountInfoModal,
  toggleAddGroupModal,
  toggleAddProfitModal,
  toggleErrorListModal,
  removeAddedStore,
  updateAgentInfo(data) {
    return {
      type: types.updateAgentInfo,
      payload: post(api.updateAgent, data),
    };
  },
  saveGroupInfo(data, editType) {
    return (dispatch) => {
      // const { editType } = getState().agent;
      if (editType === ADD) {
        dispatch({
          type: types.addGroup,
          payload: post(api.addGroup, data),
          nextAction: addSuccess(),
        });
        dispatch(toggleNoGroupModal(false));
        dispatch();
      } else {
        dispatch({
          type: types.editGroup,
          payload: post(api.updateGroupDetail, data),
          nextAction: editSuccess(),
        });
      }
    };
  },
  updateAgentProfit(data, nextAction) {
    return {
      type: types.updateAgentProfit,
      payload: requestByAuth({
        url: api.updateAgentProfit,
        data,
        hideError: true,
        method: 'post',
      }),
      nextAction,
    };
  },
  updateProfitSuccess,
};

export const reducer = createReducer({
  groupData: {},
  detailData: {},
  agentType: null,
  editType: null,
  editModalVisible: false,
  addProfitVisible: false,
  accountVisible: false,
  addGroup: {},
  updateAgent: {},
  selectedKeys: [],
  selectedAgents: [],
  updateProfit: {},
  selfInfo: {},
  errorListVisible: false,
  editBizRuleResult: {},
  addChainStores: {}, // 添加连锁门店结果
  addedStoresList: [], // 已添加的门店分店
  parentChainData: null, // 创建完连锁门店后继续创建分店时暂存数据
  parentAgentData: null, // 父级分润比例，用于编辑时

  taxiConfig: {},
  addGroupSuccessVisible: false,
  noGroupModalVisible: false,
}, {
  [types.fetchGroupList](state, { payload }) {
    mapRowKey(payload);
    payload = formatEmptyListData(payload);
    return {
      ...state,
      groupData: payload,
    };
  },
  [types.fetchGroupDetail](state, { payload }) {
    return mergeState(state, payload, 'detailData');
  },
  [types.selectedAgentRow](state, { selectedKeys, selectedAgents }) {
    return {
      ...state,
      selectedKeys,
      selectedAgents,
    };
  },
  [types.toggleAccountInfoModal](state, { visible }) {
    return {
      ...state,
      accountVisible: visible,
    };
  },
  [types.toggleAddProfitModal](state, { visible }) {
    return {
      ...state,
      addProfitVisible: visible,
    };
  },
  [types.toggleAddGroupModal](state, { visible, agentType, editType }) {
    return {
      ...state,
      editModalVisible: visible,
      agentType: agentType || state.agentType, // 关闭弹窗时，没有设置agentType，editType
      editType: editType || state.editType, // 所以，这里设置一个默认值
    };
  },
  [types.addGroup](state, { payload, keepData }) {
    let { addedStoresList } = state;
    if (keepData && payload.result && payload.result.detail) {
      addedStoresList.push(payload.result.detail);
    }
    return {
      ...state,
      addGroup: {
        ...state.addGroup,
        ...payload,
      },
      addedStoresList: addedStoresList.concat(),
    };
  },
  [types.removeAddedStore](state) {
    return {
      ...state,
      addedStoresList: [],
    };
  },
  [types.updateAgentInfo](state, { payload }) {
    return mergeState(state, payload, 'updateAgent');
  },
  [types.removeAgentDetail](state) {
    return {
      ...state,
      detailData: {},
    };
  },
  [types.updateAgentProfit](state, { payload }) {
    return {
      ...state,
      updateProfit: payload,
    };
  },
  [types.fetchSelfInfo](state, { payload }) {
    return {
      ...state,
      selfInfo: payload.result || {}, // 这里先不考虑loading状态
    };
  },
  [types.toggleErrorListModal](state, { visible }) {
    return {
      ...state,
      errorListVisible: visible,
    };
  },
  [types.editBizRule](state, { payload }) {
    return {
      ...state,
      editBizRuleResult: payload,
    };
  },
  [types.changeAgentType](state, { agentType }) {
    return {
      ...state,
      agentType,
    };
  },
  [types.queryParentProfit](state, { payload }) {
    return {
      ...state,
      parentAgentData: payload.result || {},
    };
  },
  [types.getTaxiConfig](state, { payload }) {
    const { cfgValue = '{}' } = payload.result || {};
    return {
      ...state,
      taxiConfig: JSON.parse(cfgValue),
    };
  },
  [types.toggleNoGroupModal](state, { visible }) {
    return {
      ...state,
      noGroupModalVisible: visible,
    };
  },
});
