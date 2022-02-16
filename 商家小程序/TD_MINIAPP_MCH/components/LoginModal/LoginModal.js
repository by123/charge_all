// components/LoginModal/LoginModal.js
import CustomEvent from '../../utils/event.js';
import { getCurrentPagePath } from '../../utils/util.js';
import {
  getCode,
  deleteCode,
  userLogin,
  addLoginModal,
  removeLoginModal,
  wxLogin,
  login,
  saveUserInfo,
} from '../../utils/user.js';

Component({
  /**
   * 组件的属性列表
   */
  properties: {
  },

  /**
   * 组件的初始数据
   */
  data: {
    visible: false,
  },

  attached: function() {
    addLoginModal(getCurrentPagePath(), this);
  },

  detached: function() {
    removeLoginModal(getCurrentPagePath());
  },

  /**
   * 组件的方法列表
   */
  methods: {
    handleGetUserInfo: function(e) {
      // console.log('asdad', e);
      // 保存用户信息
      saveUserInfo(e.detail);
      
      userLogin(e.detail);
    },

    catchEvent: function() {},

    hideModal: function() {
      this.setData({
        visible: false,
      });
    },
  }
})