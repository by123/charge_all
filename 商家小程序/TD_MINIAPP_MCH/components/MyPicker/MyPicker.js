// components/MyPicker/MyPicker.js
Component({
  /**
   * 组件的属性列表
   */
  properties: {
    dataSource: {
      type: Array,
      value: [],
    },
    visible: {
      type: Boolean,
      value: false,
    },
    value: {
      type: Array,
      value: [-1],
      observer(newVal, oldVal, changedPath) {
        if (newVal[0] > -1) {
          this.setData({
            pickerIndex: newVal,
            selectedValue: this.generateSelectedText(this.data.dataSource, newVal)
          });
        }
      }
    },
  },

  /**
   * 组件的初始数据
   */
  data: {
    pickerIndex: [0, 0],
    selectedValue: '',
  },

  /**
   * 组件的方法列表
   */
  methods: {
    onPickerChange: function (e) {
      const { dataSource } = this.data;
      // console.log('asdasd', dataSource, e.detail.value);
      const pickerIndex = e.detail.value;
      this.setData({
        pickerIndex,
      });
      this.triggerEvent('pickerChange', pickerIndex);
    },

    closePicker: function () {
      this.setData({
        visible: false,
      });
    },

    confirmPicker: function () {
      let { pickerIndex, dataSource } = this.data;
     
      pickerIndex = pickerIndex.map(val => {
        return val < 0 ? 0 : val;
      });
      // console.log(pickerIndex, dataSource);
      this.setData({
        visible: false,
        value: pickerIndex,
        selectedValue: this.generateSelectedText(dataSource, pickerIndex)
      });
      // console.log('pickerIndex', pickerIndex);
      this.triggerEvent('pickerConfirm', pickerIndex);
    },

    generateSelectedText: function (dataSource, pickerIndex) {
      return dataSource.reduce((prev, cur, ind) => {
        return prev + (cur[pickerIndex[ind]].name || '');
      }, '');
    },

    // 阻止事件传递
    catchTap: function () {

    },
  }
})
