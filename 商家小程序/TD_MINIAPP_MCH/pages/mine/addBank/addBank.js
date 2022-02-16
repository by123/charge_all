// pages/mine/addBank/addBank.js
import {
  formatBankData,
  showMessage,
  formatCityData,
} from '../../../utils/util.js';
import { Api } from '../../../utils/api.js';

Page({

  /**
   * 页面的初始数据
   */
  data: {
    category: 'private', // public private
    loading: false,
    disable: true,
    bankList: [],
    bankVisible: false,
    bankIndex: [-1],
    bankPickerIndex: [-1],
    isConfirm: false,

    cityVisible: false,
    cityIndex: [-1, -1],
    cityPickerIndex: [-1, -1],
    cityList: [],
    baseCityData: [],

    confirmList: [], // 确认信息列表
    tmpValue: {},
    formData: {},
    isChecked: false, // 输入的卡号是否校验过，只校验一次
    isBankCodeOk: false, // 卡号校验是否通过
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function(options) {
    const {
      category
    } = options;
    this.setData({
      category: category || 'private',
    });

    this.getBankCodeList();
    this.getCityCodeList();
  },

  handleSubmit: function(e) {
    const { formData } = this.data;
    const {
      isConfirm,
    } = this.data;

    // 未确认，校验后保存
    if (!isConfirm) {
      if (this.validateForm(formData)) {
        this.setData({
          isConfirm: true,
          confirmList: this.generateConfirmList(formData),
          tmpValue: formData,
        });
      }
    } else {
      this.submit(this.generateParam(formData));
    }
  },

  handleInput: function (e) {
    const { name } = e.currentTarget.dataset;
    let { formData } = this.data;
    formData[name] = e.detail.value;
    this.setData({
      formData,
    });
  },

  validateForm: function(value) {
    let {
      category,
      bankIndex,
      cityIndex,
    } = this.data;
    const {
      bankId,
      bankBranch,
      accountName,

    } = value;
    bankIndex = bankIndex[0];
    cityIndex = cityIndex[cityIndex.length - 1];

    let msg = '';

    if (category === 'public') {
      if (!accountName) {
        msg = '请输入账户名称';
      } else if (!bankId) {
        msg = '请输入银行对公账户';
      } else if (bankIndex !== 0 && (!bankIndex || bankIndex < 0)) {
        msg = '请选择开户银行';
      } else if (!bankBranch) {
        msg = '请输入支行名称';
      } else if (cityIndex !== 0 && (!cityIndex || cityIndex < 0)) {
        msg = '请选择开户行所在地';
      }

    } else {
      if (!accountName) {
        msg = '请输入开户人姓名';
      } else if (!bankId) {
        msg = '请输入银行卡号';
      } else if (bankIndex !== 0 && (!bankIndex || bankIndex < 0)) {
        msg = '请选择开户银行';
      }
    }

    msg && this.showError(msg);
    return !msg;
  },

  showError: function(msg) {
    wx.showModal({
      title: '错误提示',
      content: msg,
      showCancel: false,
    });
    return false;
  },

  showBankPicker: function () {
    const {
      bankIndex
    } = this.data;
    this.setData({
      bankPickerIndex: bankIndex,
      bankVisible: true,
    });
  },

  checkBankCode() {
    const { isChecked, formData: { bankId }, category } = this.data;
    if (isChecked || !bankId || category === 'public') {
      this.showBankPicker();
    } else {
      this.queryBank(bankId);
    }
  },

  queryBank(bankId) {
    wx.showLoading();

    Api.queryBankByCode({
      cardNo: bankId
    }).then((res) => {
      console.log(res);
      wx.hideLoading();
      const { bank_code } = res.data;
      let bankIndex = [this.getBankIndex(bank_code)];
      this.setData({
        bankPickerIndex: bankIndex,
        bankIndex: bankIndex,
        isBankCodeOk: true,
        isChecked: true,
      });
    }).catch(err => {
      console.log(err);
      this.setData({
        isBankCodeOk: false,
        isChecked: false,
      });
      wx.hideLoading();
      wx.showModal({
        title: '提示',
        content: err.msg || '卡号校验不通过'
      })
    });
  },

  getBankIndex(bankCode) {
    let { bankList } = this.data;
    bankList = bankList[0];
    let bankIndex = -1;
    for (let i = 0, len = bankList.length; i < len; i++) {
      if (bankList[i].bank_code === bankCode) {
        bankIndex = i;
        break;
      }
    }
    bankIndex = bankIndex !== undefined ? bankIndex : -1;
    return bankIndex;
  },

  generateParam: function(value) {
    const {
      bankId,
      accountName,
      bankBranch,
    } = value;
    const {
      bankList,
      category,
      bankIndex,
    } = this.data;
    const bankInfo = bankList[0][bankIndex[0]];
    const cityInfo = this.getCityCode(category);
    return {
      bankBranch,
      bankId,
      accountName,
      bankName: bankInfo.bank_name,
      bankCode: bankInfo.bank_code,
      cityCode: cityInfo.code,
      cityName: cityInfo.name,
      isPublic: category === 'public' ? 1 : 0,
    };
  },

  generateConfirmList: function(value) {
    const {
      bankId,
      accountName,
      bankBranch,
    } = value;
    const {
      bankList,
      category,
      bankIndex,
    } = this.data;
    try {
      const bankInfo = bankList[0][bankIndex[0]];
      const isPublic = category === 'public';
      var list = [{
        name: '账户类型：',
        value: `对${isPublic ? '公' : '私'}银行账户`
      }, ];

      if (isPublic) {
        list = list.concat([{
          name: '账户名称：',
          value: accountName,
        }, {
          name: '银行对公账户：',
          value: bankId,
        }, {
          name: '开户银行：',
          value: bankInfo.bank_name,
        }, {
          name: '支行名称：',
          value: bankBranch,
        }, {
          name: '开户行所在地：',
          value: this.getCityCode(category).name,
        }, ]);
      } else {
        list = list.concat([{
          name: '开卡人姓名：',
          value: accountName,
        }, {
          name: '银行卡号：',
          value: bankId,
        }, {
          name: '开户银行：',
          value: bankInfo.bank_name,
        }, ]);
      }
    } catch (e) {
      console.log(e);
    }
    return list;
  },

  getCityCode: function(category) {
    if (category === 'private') return '';
    const {
      baseCityData,
      cityIndex
    } = this.data;
    // let cityCode = '';
    let tmp = baseCityData;
    let name = '';
    cityIndex.map((val, ind) => {
      name += tmp[val].name;
      tmp = tmp[val].children ? tmp[val].children : tmp[val].value;
    });
    return {
      code: tmp.split('&')[0],
      name,
    };
  },

  submit: function(value) {
    // console.log('submit', value);
    if (this.data.loading) return;
    this.setData({
      loading: true,
    });
    Api.addBank(value).then((res) => {
      showMessage('添加成功');

      setTimeout(() => {
        wx.navigateBack({
          delta: 2,
        })
      }, 1500);

    }).catch(e => {
      this.setData({
        loading: false,
      });
      console.log(e);
    });
  },

  handleBankChange: function(e) {
    this.setData({
      bankIndex: e.detail,
    });
  },

  showCityPicker: function() {
    const {
      cityIndex
    } = this.data;
    this.setData({
      cityPickerIndex: cityIndex,
      cityVisible: true,
    });
  },

  catchTap: function() {

  },

  handleCloseBank: function() {
    this.setData({
      bankVisible: false,
    });
  },

  handleCityChange: function(e) {
    // console.log('cityChange', e.detail);
    const cityPickerIndex = e.detail;
    const {
      cityPickerIndex: oldPickerIndex
    } = this.data;

    if (oldPickerIndex[0] !== cityPickerIndex[0]) {
      cityPickerIndex[1] = 0;
    }

    this.setData({
      cityPickerIndex,
    });
    this.changeCityDataSource();
  },

  handleCityConfirm: function(e) {
    this.setData({
      cityIndex: e.detail,
    });
  },

  handleCloseCity: function() {
    this.setData({
      cityVisible: false,
    });
  },

  getBankCodeList: function() {
    Api.getBankCodeList().then(res => {
      console.log(res);
    }).catch(res => {
      const {
        data
      } = res;
      if (data && data.length) {
        this.setData({
          bankList: [formatBankData(data)],
        });
      }
    });
  },

  getCityCodeList: function() {
    Api.getCityCodeList().then(res => {

    }).catch(res => {
      const {
        data
      } = res;
      if (data && data.length) {
        const _cityData = formatCityData(data);
        this.setData({
          baseCityData: _cityData,
        });
        this.changeCityDataSource();
      }
    });
  },

  changeCityDataSource: function() {
    const {
      cityPickerIndex,
      baseCityData,
    } = this.data;
    let first = baseCityData;
    let second = baseCityData[cityPickerIndex[0] > 0 ? cityPickerIndex[0] : 0].children || [];

    this.setData({
      cityList: [first, second],
    });
  },

  handleCancel: function() {
    this.setData({
      isConfirm: false,
    });
  },

  handleConfirm: function() {

  },
})