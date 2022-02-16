import { message } from 'antd';
import * as types from '@/store/action-types';
import { api } from '@/store/api';
import { parse } from 'query-string';
import { get, post, requestByAuth } from '@/utils/request';
import { createReducer, mergeState, mapRowKey, formatSelectMchId, formatEmptyListData } from '../../utils';
import { action as PersonActions } from '../Personnel/store';
import { ADD, EDIT, AGENT, BIZ, CHAIN, STORE } from '../../utils/constants';

function removeParentAgentData() {
  return {
    type: types.queryParentProfit,
    payload: Promise.resolve({}),
  };
}

function removeAddedStore() {
  return {
    type: types.removeAddedStore,
  };
}

function toggleEditAgentModal(visible, agentType, editType) {
  return (dispatch) => {
    dispatch({
      type: types.toggleEditAgentModal,
      visible,
      agentType,
      editType,
    });
    // 关闭弹窗时清除父级连锁门店信息
    if (!visible) {
      dispatch(removeParentAgentData());
    }
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

function fetchAgentList(data) {
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
    type: types.fetchAgentList,
    payload: post(api.agentListPost, Object.assign({ pageSize: 15 }, data)),
  };
}

function fetchAgentDetail(id, nextAction) {
  return {
    type: types.fetchAgentDetail,
    payload: get(api.agentDetail, { mchId: id }),
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
    dispatch(toggleEditAgentModal(false));
    dispatch(removeAgentDetail());
    message.success('保存成功');
    dispatch(fetchAgentList(location.search));
  };
}
function addSuccess() {
  return toggleAccountInfoModal(true);
}

function updateProfitSuccess() {
  return (dispatch, getState) => {
    const { router: { location } } = getState();
    dispatch(toggleAddProfitModal(false));
    dispatch(selectedRow([], []));
    dispatch(fetchAgentList(location.search));
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

function queryParentProfit(mchId) {
  return {
    type: types.queryParentProfit,
    payload: get(api.agentDetail, { mchId }),
  };
}

function queryIndustyPrice() {
  return {
    type: types.queryIndustyPrice,
    payload: get(api.getConfig, { cfgKey0: 'industry_default_price_cfg' }),
  };
}

function showAddAgent(type) {
  return (dispatch) => {
    // dispatch(fetchSelfInfo());
    dispatch(PersonActions.fetchAllUsers());
    dispatch(removeAgentDetail());
    dispatch(toggleEditAgentModal(true, type, ADD));
  };
}

function closeModalAndRefresh() {
  return (dispatch, getState) => {
    const { router: { location } } = getState();
    dispatch(toggleAccountInfoModal(false));
    dispatch(toggleEditAgentModal(false));
    dispatch(removeAgentDetail());
    dispatch(removeAddedStore());
    dispatch(fetchAgentList(location.search));
  };
}

function showEditAgent(type, id, level) {
  return (dispatch) => {
    dispatch(fetchSelfInfo());
    dispatch(PersonActions.fetchAllUsers());
    dispatch(fetchAgentDetail(id, (_, getState) => {
      const { agent: { detailData }, global: { profile } } = getState();
      if (profile.mchId !== detailData.result.parentAgencyId) {
        dispatch(queryParentProfit(detailData.result.parentAgencyId));
      }
    }));
    if (type === 1) { // 商户: 1 , 代理商: 0
      if (level === 1) {
        dispatch(toggleEditAgentModal(true, STORE, EDIT));
      } else {
        dispatch(toggleEditAgentModal(true, BIZ, EDIT));
      }
    } else if (type === 0) {
      if (level === 4) {
        dispatch(toggleEditAgentModal(true, CHAIN, EDIT));
      } else {
        dispatch(toggleEditAgentModal(true, AGENT, EDIT));
      }
    }
  };
}

function saveAgentInfo(data, rule, keepData, nextAction) {
  return (dispatch, getState) => {
    const { editType, agentType } = getState().agent;
    const apiList = {
      [AGENT]: 'addAgent',
      [BIZ]: 'addBiz',
      [CHAIN]: 'addChain',
      [STORE]: 'addStore',
    };
    if (editType === ADD) {
      dispatch({
        type: types.addAgentInfo,
        payload: post(api[apiList[agentType]], data),
        keepData,
        nextAction: nextAction || addSuccess(),
      });
    } else {
      const isAgentLike = agentType === AGENT || agentType === CHAIN;
      dispatch({
        type: types.updateAgentInfo,
        payload: post(isAgentLike ? api.updateAgent : api.updateBiz, data),
        nextAction: isAgentLike ? editSuccess() : editBizRule(rule, editSuccess()),
      });
    }
  };
}

function deleteAgent(data, nextAction) {
  return {
    type: types.deleteAgent,
    payload: post(api.deleteAgent, data),
    nextAction,
  };
}

function showAddProfitModal() {
  return (dispatch) => {
    dispatch(fetchSelfInfo());
    dispatch(toggleAddProfitModal(true));
  };
}

function updateAgentProfit(data, nextAction) {
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
}

function updateAgentInfo(data) {
  return {
    type: types.updateAgentInfo,
    payload: post(api.updateAgent, data),
  };
}

function toggleTransferAgentModal(visible) {
  return {
    type: types.toggleTransferAgentModal,
    visible,
  };
}

function transferAgent(data, nextAction) {
  return {
    type: types.transferAgent,
    payload: get(api.transferAgent, data),
    nextAction,
  };
}

function queryTransferAgentInfo(data) {
  return {
    type: types.queryTransferAgentInfo,
    payload: get(api.queryTransferAgentInfo, data),
  };
}

function queryProfitMore(data, nextAction) {
  return {
    type: types.queryProfitMore,
    payload: get(api.transferAgent, data),
    nextAction,
  };
}

function searchMchByInfo(data, nextAction) {
  return {
    type: types.searchMchByInfo,
    payload: get(api.searchMchByInfo, data),
    nextAction,
  };
}

function cleanInfoSearchResult() {
  return {
    type: types.searchMchByInfo,
    payload: {},
  };
}

function queryParentsByMchId(data, nextAction) {
  return {
    type: types.queryParentsByMchId,
    payload: get(api.queryParentsByMchId, data),
    nextAction,
  };
}

export const action = {
  fetchAgentList,
  fetchAgentDetail,
  selectedRow,
  fetchSelfInfo,
  editBizRule,
  addChainBiz,
  changeAgentType,
  queryParentProfit,
  removeParentAgentData,
  queryIndustyPrice,
  deleteAgent,
  showAddAgent,
  showEditAgent,
  showAddProfitModal,
  closeModalAndRefresh,
  toggleAccountInfoModal,
  toggleEditAgentModal,
  toggleAddProfitModal,
  toggleErrorListModal,
  removeAddedStore,
  updateAgentInfo,
  saveAgentInfo,
  updateAgentProfit,
  updateProfitSuccess,
  transferAgent,
  toggleTransferAgentModal,
  queryTransferAgentInfo,
  queryProfitMore,
  searchMchByInfo,
  cleanInfoSearchResult,
  queryParentsByMchId,
};

export const reducer = createReducer({
  agentData: {},
  detailData: {},
  agentType: null,
  editType: null,
  editModalVisible: false,
  addProfitVisible: false,
  accountVisible: false,
  addAgent: {},
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
  industyPriceResult: {}, // 行业默认价格

  transferAgentModalVisible: false,
  transferAgentResult: {},
  queryTransferAgentInfoResult: {},
  queryProfitMoreResult: {},

  searchMchByInfoResult: {},
  queryParentsByMchIdResult: {},
}, {
  [types.fetchAgentList](state, { payload }) {
    mapRowKey(payload);
    payload = formatEmptyListData(payload);
    return mergeState(state, payload, 'agentData');
  },
  [types.fetchAgentDetail](state, { payload }) {
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
  [types.toggleEditAgentModal](state, { visible, agentType, editType }) {
    return {
      ...state,
      editModalVisible: visible,
      agentType: agentType || state.agentType, // 关闭弹窗时，没有设置agentType，editType
      editType: editType || state.editType, // 所以，这里设置一个默认值
    };
  },
  [types.addAgentInfo](state, { payload, keepData }) {
    let { addedStoresList } = state;
    if (keepData && payload.result && payload.result.detail) {
      addedStoresList.push(payload.result.detail);
    }
    return {
      ...state,
      addAgent: {
        ...state.addAgent,
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
  [types.queryIndustyPrice](state, { payload }) {
    return mergeState(state, payload, 'industyPriceResult');
  },
  [types.deleteAgent](state, { payload }) {
    return mergeState(state, payload, 'deleteResult');
  },
  [types.toggleTransferAgentModal](state, { visible }) {
    return {
      ...state,
      transferAgentModalVisible: visible,
    };
  },
  [types.transferAgent](state, { payload }) {
    return mergeState(state, payload, 'transferAgentResult');
  },
  [types.queryProfitMore](state, { payload }) {
    return mergeState(state, payload, 'queryProfitMoreResult');
  },
  [types.queryTransferAgentInfo](state, { payload }) {
    return mergeState(state, payload, 'queryTransferAgentInfoResult');
  },
  [types.searchMchByInfo](state, { payload }) {
    return mergeState(state, payload, 'searchMchByInfoResult');
  },
  [types.queryParentsByMchId](state, { payload }) {
    return mergeState(state, payload, 'queryParentsByMchIdResult');
  },
});
