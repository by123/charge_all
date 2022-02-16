// components/TipBar/TipBar.js
Component({
  /**
   * 组件的属性列表
   */
  properties: {
    content: {
      type: String,
      value: '',
    },
    icon: {
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
    left: 0,
    timer: null,
  },

  /**
   * 组件的方法列表
   */
  methods: {
    closeNotice() {
      this.triggerEvent('closeNotice');
    },
  }
})
