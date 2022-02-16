// components/MyButton/MyButton.js
Component({
  /**
   * 组件的属性列表
   */
  properties: {
    size: {
      type: String,
      value: 'normal', // mini small normal large big
    },
    disable: {
      type: Boolean,
      value: false, // true false
      observer: function(newVal) {
        this.calculateClass();
      },
    },
    customStyle: {
      type: String,
      value: '', // 自定义样式
    },
    full: {
      type: Boolean,
      value: false, // true false
    },
    loading: {
      type: Boolean,
      value: false,
    },
    hollow: {
      type: Boolean,
      value: false,
    },
  },

  attached: function() {
    this.calculateClass();
  },

  /**
   * 组件的初始数据
   */
  data: {
    btnClass: '',
    hoverClass: '',
  },


  /**
   * 组件的方法列表
   */
  methods: {
    onTap: function(e) {
      if (!this.data.loading && !this.data.disable) {
        this.triggerEvent('btnTap', e);
      }
    },

    calculateClass: function() {
      const {
        size,
        disable,
        customStyle,
        full,
        hollow,
      } = this.data;

      const btnClass = `size-${size} ${disable ? "disable" : ""} ${full ? "btn-full" : ""} ${hollow ? 'btn-hollow' : ''}`;

      const hoverClass = disable ? '' : 'hover-class';

      this.setData({
        btnClass,
        hoverClass,
      });
    }
  }
})