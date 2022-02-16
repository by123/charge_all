// components/Card/Card.js
/**
 * 基本卡片组件，可以再包装
 * 
 * 基本数据解构 = {
 *  name: '',
 *  value: '',
 *  customStyle: '',
 * }
 * 
 * 接受dataSource参数
 * dataSource : {
 *  title: '',  非必填
 *  content: [, 二维数组，
 *    [
 *      基本数据结构
 *    ],
 *  ]
 * }
 */

function formatData(context, dataSource) {
  const {
    title,
    content
  } = dataSource;

  let cardList = [];
  if (title) {
    let headerData = {
      name: title,
      value: '',
      customStyle: {
        name: 'font-weight: 600; color: #353648;',
      }
    };
    cardList.push([headerData]);
  }
  if (content && content.length) {
    content.map((item) => {
      cardList.push(item);
    });
  }

  cardList.length && (context.setData({
    cardList,
  }));
}

Component({
  /**
   * 组件的属性列表
   */
  properties: {
    dataSource: {
      type: Object,
      value: {
        title: '',
        content: null,
      },
      observer: function (newVal, oldVal) {
        if (newVal === oldVal) return;
        formatData(this, newVal);
      }
    },
    isSolid: {
      type: Boolean,
      value: true,
    },
    lastHasBorder: {
      type: Boolean,
      value: false,
    },
    lightShadow: {
      type: Boolean,
      value: false,
    }
  },

  attached: function() {
    formatData(this, this.data.dataSource);
  },

  /**
   * 组件的初始数据
   */
  data: {
    cardList: null,
  },

  /**
   * 组件的方法列表
   */
  methods: {
    onTap: function() {
      this.triggerEvent('tabCard');
    }
  }
})