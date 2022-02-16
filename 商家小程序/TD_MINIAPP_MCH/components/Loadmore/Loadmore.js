// component/load-more/load-more.js
Component({
  /**
   * 组件的属性列表
   */
  properties: {
    hasMore: {
      type: Boolean,
      value: false,
    },
    hasData: {
      type: Boolean,
      value: false,
    },
    init: {
      type: Boolean,
      value: false
    },
    emptyText: {
      type: String,
      value: '暂无数据',
    },
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

  }
})
