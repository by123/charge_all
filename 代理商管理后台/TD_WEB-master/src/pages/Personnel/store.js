import * as types from '@/store/action-types';
import { get, post } from '@/utils/request';
import { api } from '@/store/api';
import { message } from 'antd';
import { createReducer, mergeState, formatEmptyListData } from '../../utils';

function fetchPersonnelList(data) {
  return {
    type: types.fetchPersonnelList,
    payload: get(api.personnelList, data),
  };
}

function toggleAddModal(visible, editType) {
  return {
    type: types.setModalVisiable,
    visible,
    editType,
  };
}

function refreshList() {
  return (dispatch, getState) => {
    const { query } = getState().router.location;
    dispatch(fetchPersonnelList(query));
  };
}

function editSuccess() {
  return (dispatch) => {
    message.success('编辑业务员资料成功');
    dispatch(toggleAddModal(false));
    dispatch(refreshList());
  };
}

function deletePersonnel(data, nextAction) {
  return {
    type: types.deletePersonnel,
    payload: post(api.personnelDelete, data),
    nextAction,
  };
}

function toggleDeleteModal(visible) {
  return {
    type: types.toggleDeleteModal,
    visible,
  };
}

export const action = {
  fetchPersonnelList,
  refreshList,
  deletePersonnel,
  toggleDeleteModal,
  fetchAllUsers(data) {
    return {
      type: types.fetchAllUsers,
      payload: get(api.allUsers, data),
    };
  },
  addPersonnel(data) {
    return {
      type: types.addPersonnel,
      payload: post(api.personnelAdd, data),
      nextAction: refreshList(),
    };
  },
  editPersonnel(data) {
    return {
      type: types.editPersonnel,
      payload: post(api.personnelEdit, data),
      nextAction: editSuccess(),
    };
  },
  toggleAddModal,
  closeSuccessModal() {
    return {
      type: types.closeModalVisiable,
      payload: true,
    };
  },
  saveSelectedRowData(data) {
    return {
      type: types.saveSelectedRowData,
      payload: data,
    };
  },
};

export const reducer = createReducer({
  personnelData: {},
  accountInfo: {},
  addModalShow: false,
  addModalSuccessShow: false,
  allUsers: {},
  editType: '',
  selectedRowData: {},
  deleteResult: {},
  deleteModalVisible: false,
}, {
  [types.fetchPersonnelList](state, { payload }) {
    payload = formatEmptyListData(payload);
    return mergeState(state, payload, 'personnelData');
  },
  [types.addPersonnel](state, { payload }) {
    return {
      ...state,
      accountInfo: payload,
      addModalSuccessShow: true,
      addModalShow: false,
    };
  },
  [types.setModalVisiable](state, { visible, editType }) {
    const newState = {
      ...state,
      addModalShow: visible,
      editType,
    };
    !visible && (newState.selectedRowData = {});
    return newState;
  },
  [types.closeModalVisiable](state) {
    return {
      ...state,
      addModalSuccessShow: false,
    };
  },
  [types.fetchAllUsers](state, { payload }) {
    return mergeState(state, payload, 'allUsers');
  },
  [types.saveSelectedRowData](state, { payload }) {
    return mergeState(state, payload, 'selectedRowData');
  },
  [types.editPersonnel](state, { payload }) {
    return mergeState(state, payload, 'editPersonnelResult');
  },
  [types.deletePersonnel](state, { payload }) {
    return mergeState(state, payload, 'deleteResult');
  },
  [types.toggleDeleteModal](state, { visible }) {
    return {
      ...state,
      deleteModalVisible: visible,
    };
  },
});
