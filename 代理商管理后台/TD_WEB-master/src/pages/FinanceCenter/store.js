import * as types from '@/store/action-types';
import { api } from '@/store/api';
import { get, post } from '@/utils/request';
import { message } from 'antd';
import { parse } from 'query-string';
import { createReducer, mapRowKey, mergeState, formatSelectMchId, formatEmptyListData } from '../../utils';

function formatData(data) {
  if (data && (data.dataSource)) {
    let dataSource = data.dataSource.map(val => {
      return { ...val.tblMch, ...val.tblBank };
    });
    data.dataSource = dataSource;
  }
  return data;
}

function getApplyLists(data) {
  return {
    type: types.getApplyLists,
    payload: get(api.getApplyLists, data),
  };
}

function viewAuditdetails(data) {
  return {
    type: types.viewAuditdetails,
    payload: get(api.viewAuditdetails, data),
  };
}

function checkWithDrawRequestAfterLianLianWarned(data) {
  return {
    type: types.checkWithDrawRequestAfterLianLianWarned,
    payload: post(api.checkWithDrawRequestAfterLianLianWarned, data),
  };
}

function toggleApplyDetailModal(visible) {
  return {
    type: types.toggleApplyDetailModal,
    visible,
  };
}

function toggleWarinEditModal(visible) {
  return {
    type: types.toggleWarinEditModal,
    visible,
  };
}

function getWithdrawalManageList(data) {
  data = parse(data);
  if (!data.mchId) {
    formatSelectMchId(data, 'mchId1', false);
    data.mchId = data.mchId1;
  }
  delete data.mchId1;
  return {
    type: types.getWithdrawalManageList,
    payload: get(api.getWithdrawalManageList, data),
  };
}

function toggleEditBankInfoModal(visible) {
  return {
    type: types.toggleEditBankInfoModal,
    visible,
  };
}

function editBankInfo(data) {
  return {
    type: types.editBankInfo,
    payload: post(api.editBankInfo, data),
  };
}

function refreshList() {
  return (dispatch, getState) => {
    const { search } = getState().router.location;
    dispatch(getWithdrawalManageList(search));
  };
}

function refreshWithdrawalList() {
  return (dispatch, getState) => {
    const { search } = getState().router.location;
    dispatch(getApplyLists(search));
  };
}

function modStateSuccess(withdrawState) {
  const msgObj = {
    '-2': '提现挂起成功',
    0: '提现取消挂起成功',
  };
  return (dispatch) => {
    let msg = msgObj[withdrawState] || '';
    message.success(msg);
    dispatch(refreshWithdrawalList());
  };
}

function modWithdrawalState(data) {
  return {
    type: types.modWithdrawalState,
    payload: post(api.modWithdrawalState, data),
    nextAction: modStateSuccess(String(data.withdrawState)),
  };
}

function toggleDeleteModal(visible) {
  return {
    type: types.toggleDeleteWechatModal,
    visible,
  };
}

function deleteWechatWithdrawal(data, nextAction) {
  return {
    type: types.deleteWechatWithdrawal,
    payload: get(api.deleteBankCardById, data),
    nextAction,
  };
}

function getExpendList(data) {
  return {
    type: types.getExpendList,
    payload: api.getExpendList(data),
  };
}

function getIncomeList(data) {
  return {
    type: types.getIncomeList,
    payload: api.getIncomeList(data),
  };
}

function downloadFinanceData(data, nextAction) {
  return {
    type: types.downloadFinanceData,
    payload: api.downloadFinanceData(data),
    nextAction,
  };
}

export const action = {
  getApplyLists,
  viewAuditdetails,
  toggleApplyDetailModal,
  toggleWarinEditModal,
  checkWithDrawRequestAfterLianLianWarned,
  getWithdrawalManageList,
  toggleEditBankInfoModal,
  editBankInfo,
  refreshList,
  modWithdrawalState,
  toggleDeleteModal,
  deleteWechatWithdrawal,
  getExpendList,
  getIncomeList,
  downloadFinanceData,
};

export const reducer = createReducer({
  applyLists: {},
  viewAuditdetailsStatus: {},
  applyDetailVisible: false,
  toggleWarinEditModalVisible: false,
  checkWithDrawRequestAfterLianLianWarned: {},
  editBankInfoResult: {},
  editBankInfoVisible: false,
  withdrawalManageList: {},
  deleteModalVisible: false,
  deleteWechatWithdrawalResult: {},
  getExpendListResult: {},
  getIncomeListResult: {},
  downloadFinanceDataResult: {},
}, {
  [types.getApplyLists](state, { payload }) {
    mapRowKey(payload);
    payload = formatEmptyListData(payload);
    return mergeState(state, payload, 'applyLists');
  },
  [types.viewAuditdetails](state, { payload }) {
    return {
      ...state,
      viewAuditdetailsStatus: payload,
    };
  },
  [types.toggleApplyDetailModal](state, { visible }) {
    return {
      ...state,
      applyDetailVisible: visible,
    };
  },
  [types.toggleWarinEditModal](state, { visible }) {
    return {
      ...state,
      toggleWarinEditModalVisible: visible,
    };
  },
  [types.checkWithDrawRequestAfterLianLianWarned](state, { payload }) {
    return {
      ...state,
      checkWithDrawRequestAfterLianLianWarned: payload,
    };
  },
  [types.editBankInfo](state, { payload }) {
    return {
      ...state,
      editBankInfoResult: payload,
    };
  },
  [types.toggleEditBankInfoModal](state, { visible }) {
    return {
      ...state,
      editBankInfoVisible: visible,
    };
  },
  [types.getWithdrawalManageList](state, { payload }) {
    mapRowKey(formatData(payload));
    payload = formatEmptyListData(payload);
    return {
      ...state,
      withdrawalManageList: payload,
    };
  },
  [types.toggleDeleteWechatModal](state, { visible }) {
    return {
      ...state,
      deleteModalVisible: visible,
    };
  },
  [types.deleteWechatWithdrawal](state, { payload }) {
    return mergeState(state, payload, 'deleteWechatWithdrawalResult');
  },
  [types.getExpendList](state, { payload }) {
    let { result: { financialExpendPage } = {} } = payload;
    if (financialExpendPage) {
      payload.result.financialExpendPage = mapRowKey(financialExpendPage, 'rows', 'pageId');
    }
    return mergeState(state, payload, 'getExpendListResult');
  },
  [types.getIncomeList](state, { payload }) {
    let { result: { financialIncomePage } = {} } = payload;
    if (financialIncomePage) {
      payload.result.financialIncomePage = mapRowKey(financialIncomePage, 'rows', 'pageId');
    }
    return mergeState(state, payload, 'getIncomeListResult');
  },
  [types.downloadFinanceData](state, { payload }) {
    return mergeState(state, payload, 'downloadFinanceDataResult');
  },
});
