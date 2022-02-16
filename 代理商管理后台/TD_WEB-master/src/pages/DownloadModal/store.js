import * as types from '@/store/action-types';
import { api } from '@/store/api';
import { get } from '@/utils/request';
import { createReducer, mergeState } from '@/utils';
import { downloadTaskType } from '@/utils/enum';
import { ORDER_DOWNLOAD } from '@/utils/constants';

function fetchDownloadList(taskType) {
  const data = {
    taskType: downloadTaskType[taskType],
    pageSize: 99999,
  };
  return {
    type: types.fetchDownloadList,
    payload: get(api.fetchDownloadList, data),
  };
}

function toggleDownloadModal(visible, taskType = ORDER_DOWNLOAD) {
  return (dispatch) => {
    if (visible) {
      dispatch(fetchDownloadList(taskType));
    }
    dispatch({
      type: types.toggleDownloadModal,
      taskType,
      visible,
    });
  };
}

function deleteDownloadItem(data, nextAction) {
  return {
    type: types.deleteDownloadItem,
    payload: get(api.deleteDownloadItem, data),
    nextAction,
  };
}

export const action = {
  fetchDownloadList,
  toggleDownloadModal,
  deleteDownloadItem,
};

export const reducer = createReducer({
  downloadList: {},
  downloadModalVisible: false,
  deleteDownloadItemResult: {},
  taskType: '',
}, {
  [types.fetchDownloadList](state, { payload }) {
    return mergeState(state, payload, 'downloadList');
  },
  [types.toggleDownloadModal](state, { visible, taskType }) {
    const newState = {
      ...state,
      downloadModalVisible: visible,
    };
    visible && (newState.taskType = taskType);
    return newState;
  },
  [types.deleteDownloadItem](state, { payload }) {
    return mergeState(state, payload, 'deleteDownloadItemResult');
  },
});
