import * as types from '@/store/action-types';
import { api } from '@/store/api';
import { get, post } from '@/utils/request';
import { message } from 'antd';
import { parse } from 'query-string';
import { createReducer, mapRowKey, mergeState, formatEmptyListData } from '@/utils';

function fetchWechatList(data) {
  return {
    type: types.fetchWechatList,
    payload: get(api.fetchWechatList, data),
  };
}

function refreshList() {
  return (dispatch, getState) => {
    const { search } = getState().router.location;
    dispatch(fetchWechatList(search));
  };
}


function toggleUntieComfirm(visible) {
  return {
    type: types.toggleUntieComfirm,
    visible,
  };
}

function untieWechatSuccess() {
  return (dispatch) => {
    dispatch(toggleUntieComfirm(false));
    dispatch(refreshList());
    message.success('商户微信解绑成功！');
  };
}

function untieWechat(data) {
  return {
    type: types.untieWechat,
    payload: get(api.untieWechat, data),
    nextAction: untieWechatSuccess(),
  };
}

function fetchAdList(data) {
  data = parse(data);
  if (data.mchId) {
    let mchId = data.mchId.filter(item => {
      return !!item;
    });
    mchId = mchId[mchId.length - 1];
    data.mchId = mchId;
  }
  data.pageSize = data.pageSize || 15;
  return {
    type: types.fetchAdList,
    payload: api.fetchAdList(data),
  };
}

function refreshAdList() {
  return (dispatch, getState) => {
    const { search } = getState().router.location;
    dispatch(fetchAdList(search));
  };
}

function fetchAdDetail(id, nextAction) {
  return {
    type: types.fetchAdDetail,
    payload: get(api.fetchAdDetail, { adID: id }),
    nextAction,
  };
}

function addAdConfig(data, values, nextAction) {
  return {
    type: types.addAdConfig,
    payload: post(api.addAdConfig(values), data),
    nextAction,
  };
}

function delAdConfig(data, nextAction) {
  return {
    type: types.delAdConfig,
    payload: get(api.delAdConfig, data),
    nextAction,
  };
}

function modADConfig(data, nextAction) {
  return {
    type: types.modADConfig,
    payload: post(api.modADConfig(data)),
    nextAction,
  };
}

function examineAdConfig(data, nextAction) {
  return {
    type: types.examineAdConfig,
    payload: api.examineAdConfig(data),
    nextAction,
  };
}

function getAdStatistic(data) {
  return {
    type: types.getAdStatistic,
    payload: get(api.getAdStatistic, data),
  };
}

function toggleEditModal(visible, editType) {
  return {
    type: types.toggleEditAdModal,
    visible,
    editType,
  };
}

function toggleDetailModal(visible) {
  return {
    type: types.toggleAdDetail,
    visible,
  };
}

function getPostionList() {
  return {
    type: types.getPostionList,
    payload: get(api.getConfig, { cfgKey0: 'ad_position' }),
  };
}

function modADConfigPic(id, data) {
  return {
    type: types.modADConfigPic,
    payload: post(api.modADConfigPic(id), data),
  };
}

function uploadAdFile(data) {
  return {
    type: types.uploadAdFile,
    payload: api.uploadAdFile(data),
  };
}

function fetchNoticeList(data) {
  return {
    type: types.fetchNoticeList,
    payload: get(api.fetchNoticeList, data),
  };
}

function delNotice(data, nextAction) {
  return {
    type: types.delNotice,
    payload: get(api.delNotice, data),
    nextAction,
  };
}

function refreshNoticeList() {
  return (dispatch, getState) => {
    const { search } = getState().router.location;
    dispatch(fetchNoticeList(search));
  };
}

function modNotice(data, nextAction) {
  return {
    type: types.modNotice,
    payload: post(api.modNotice, data),
    nextAction,
  };
}

function addNotice(data, nextAction) {
  return {
    type: types.addNotice,
    payload: post(api.addNotice, data),
    nextAction,
  };
}

function queryNoticeDetail(data, nextAction) {
  return {
    type: types.queryNoticeDetail,
    payload: get(api.queryNoticeDetail, data),
    nextAction,
  };
}

function uploadPublicFile(data) {
  return {
    type: types.uploadPublicFile,
    payload: post(api.uploadPublicFile, data),
  };
}

function selectedRow(selectedKeys, selectedNotices) {
  return {
    type: types.selectedNoticeRow,
    selectedKeys,
    selectedNotices,
  };
}

function toggleDeleteModal(visible) {
  return {
    type: types.toggleNoticeDeleteModal,
    visible,
  };
}

export const action = {
  fetchWechatList,
  toggleUntieComfirm,
  untieWechat,
  refreshList,

  fetchAdList,
  refreshAdList,
  fetchAdDetail,
  addAdConfig,
  delAdConfig,
  modADConfig,
  getAdStatistic,
  toggleEditModal,
  toggleDetailModal,
  getPostionList,
  modADConfigPic,
  uploadAdFile,

  fetchNoticeList,
  delNotice,
  addNotice,
  queryNoticeDetail,
  uploadPublicFile,
  modNotice,

  toggleDeleteModal,
  selectedRow,
  refreshNoticeList,
  examineAdConfig,
};

export const reducer = createReducer({
  wechatList: {},
  confirmVisible: false,
  untieWechatResult: {},

  fetchAdListResult: {},
  fetchAdDetailResult: {},
  editAdConfigResult: {},
  delAdConfigResult: {},
  getAdStatisticResult: {},
  listUpdateTime: 0,
  editAdModalVisible: false,
  adDetailVisible: false,
  getPositionListResult: {},
  modADConfigPicResult: {},
  uploadAdFileResult: {},

  fetchNoticeListResult: {},
  delNoticeResult: {},
  editNoticeResult: {},
  queryNoticeDetailResult: {},
  uploadPublicFileResult: {},
  selectedKeys: [],
  selectedNotices: [],
  deleteModalVisible: false,
}, {
  [types.fetchWechatList](state, { payload }) {
    mapRowKey(payload);
    payload = formatEmptyListData(payload);
    return mergeState(state, payload, 'wechatList');
  },
  [types.toggleUntieComfirm](state, { visible }) {
    return {
      ...state,
      confirmVisible: visible,
    };
  },
  [types.untieWechat](state, { payload }) {
    return mergeState(state, payload, 'untieWechatResult');
  },
  [types.fetchAdList](state, { payload }) {
    mapRowKey(payload);
    return {
      ...state,
      fetchAdListResult: payload,
      listUpdateTime: new Date().getTime(),
    };
  },
  [types.fetchAdDetail](state, { payload }) {
    return mergeState(state, payload, 'fetchAdDetailResult');
  },
  [types.modADConfig](state, { payload }) {
    return mergeState(state, payload, 'editAdConfigResult');
  },
  [types.addAdConfig](state, { payload }) {
    return mergeState(state, payload, 'editAdConfigResult');
  },
  [types.delAdConfig](state, { payload }) {
    return mergeState(state, payload, 'delAdConfigResult');
  },
  [types.examineAdConfig](state, { payload }) {
    return mergeState(state, payload, 'editAdConfigResult');
  },
  [types.getAdStatistic](state, { payload }) {
    mapRowKey(payload);
    return mergeState(state, payload, 'getAdStatisticResult');
  },
  [types.toggleEditAdModal](state, { visible, editType }) {
    return {
      ...state,
      editAdModalVisible: visible,
      editType,
    };
  },
  [types.toggleAdDetail](state, { visible }) {
    return {
      ...state,
      adDetailVisible: visible,
    };
  },
  [types.getPostionList](state, { payload }) {
    return {
      ...state,
      getPositionListResult: {
        ...payload,
        result: payload.result && payload.result.cfgValue ? JSON.parse(payload.result.cfgValue) : [],
      },
    };
  },
  [types.modADConfigPic](state, { payload }) {
    return mergeState(state, payload, 'modADConfigPicResult');
  },
  [types.uploadAdFile](state, { payload }) {
    return mergeState(state, payload, 'uploadAdFileResult');
  },
  [types.fetchNoticeList](state, { payload }) {
    mapRowKey(payload);
    return mergeState(state, payload, 'fetchNoticeListResult');
  },
  [types.delNotice](state, { payload }) {
    return mergeState(state, payload, 'delNoticeResult');
  },
  [types.addNotice](state, { payload }) {
    return mergeState(state, payload, 'editNoticeResult');
  },
  [types.modNotice](state, { payload }) {
    return mergeState(state, payload, 'editNoticeResult');
  },
  [types.queryNoticeDetail](state, { payload }) {
    return mergeState(state, payload, 'queryNoticeDetailResult');
  },
  [types.uploadPublicFile](state, { payload }) {
    return mergeState(state, payload, 'uploadPublicFileResult');
  },
  [types.selectedNoticeRow](state, { selectedKeys, selectedNotices }) {
    return {
      ...state,
      selectedKeys,
      selectedNotices,
    };
  },
  [types.toggleNoticeDeleteModal](state, { visible }) {
    return {
      ...state,
      deleteModalVisible: visible,
    };
  },
});
