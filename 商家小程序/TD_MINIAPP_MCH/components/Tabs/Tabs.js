// components/Tabs/tabs.js
Component({
  /**
   * 组件的属性列表
   */
  properties: {
    active: {
      type: String,
      value: '',
    },
    tabsArray: {
      type: Array,
      value: [],
      observer: function(newVal, oldVal) {
        if (newVal && newVal.length) {
          this.setWidth();
        }
      }
    },
    tabWidth: {
      type: Number,
      value: 160,
    },
    title: {
      type: String,
      value: "",
    }
  },

  /**
   * 组件的初始数据
   */
  data: {
    wrapperWidth: 0,
  },

  attached: function () {
    this.setWidth();
  },

  /**
   * 组件的方法列表
   */
  methods: {
    changeTab: function (e) {
      const { category } = e.currentTarget.dataset;
      this.triggerEvent('changeTab', category );
    },

    setWidth() {
      const { tabWidth, tabsArray } = this.data;
      this.setData({
        wrapperWidth: tabWidth * tabsArray.length + 30
      });
    },
  },
})
