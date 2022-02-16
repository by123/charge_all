// components/TipModal/TipModal.js
Component({
  /**
   * 组件的属性列表
   */
  properties: {
    title: {
      type: String,
      value: '提示',
    },
    okText: {
      type: String,
      value: '确定',
    },
    cancelText: {
      type: String,
      value: '',
    },
    visible: {
      type: Boolean,
      value: false,
    }
  },

  /**
   * 组件的初始数据
   */
  data: {

  },

  /**
   * 组件的方法列表
   */
  methods: {
    stopEvent: () => {

    },

    handleOk(e) {
      this.triggerEvent('onOk');
      console.log('onOk');
    },

    handleCancel() {
      this.triggerEvent('onCancel');
    },
  }
})
