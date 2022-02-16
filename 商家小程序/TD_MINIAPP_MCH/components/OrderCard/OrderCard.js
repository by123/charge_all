// components/OrderCard/OrderCard.js

/**
 * 订单信息卡片
 * orderData 数据结构同Card
 * 新增
 */

import { orderBtnType } from '../../utils/enum.js';

Component({
  /**
   * 组件的属性列表
   */
  properties: {
    orderData: {
      type: Object,
      value: {
      },
    },
    profit: {
      type: String,
      value: '',
    },
    hasRefund: {
      type: Boolean,
      value: false,
    },
  },

  /**
   * 组件的初始数据
   */
  data: {
    orderBtnType: orderBtnType,
  },

  /**
   * 组件的方法列表
   */
  methods: {
    handleTap() {
      const { btnType, orderData } = this.data;

      this.triggerEvent('btnTap', {
        btnType,
        orderId: orderData.orderId,
      });
    },
    catchTap() {},
  }
})
