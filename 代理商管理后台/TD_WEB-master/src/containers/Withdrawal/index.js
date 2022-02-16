import React from 'react';
import { Form, InputNumber, Icon, Modal, Select } from 'antd';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import { action as moneyActions } from '../../pages/Money/store';
import { formatBankCode, formatMoney, mapArrayToOptions } from '../../utils';
import { api as Api } from '../../store/api';

import '../../pages/Money/style.less';

const FormItem = Form.Item;

class WithdrawalPage extends React.PureComponent {
  state = {
    accountType: -1,
    min: 0,
    max: 0,
    rules: [],
  }

  componentDidMount() {
    this.fetchWithdrawalRule();
    this.getWithdrawalConfig();
  }

  onSubmit = () => {
    const { dispatch } = this.props;
    this.props.form.validateFieldsAndScroll((err, values) => {
      if (!err) {
        const { bankId } = this.getCurrentBank();
        dispatch(moneyActions.moneyWithdrawal({
          bankId,
          withdrawMoney: values.money,
        }));
      } else {
        console.log(err);
        // throw new Error(err);
      }
      this.props.form.resetFields();
    });
  }

  // // 获取银行卡信息
  // fetchBankInfo = () => {
  //   this.props.dispatch(accountActions.fetchBankInfo());
  // }

  fetchWithdrawalRule = () => {
    this.props.dispatch(moneyActions.fetchWithdrawalRule((_, getState) => {
      const { withdrawalRule: { result: withdrawalRule = [] } } = getState().money;
      this.setState({
        rules: this.formatWithdrawalRule(withdrawalRule),
      });
    }));
  }

  onChangeMoney = (money) => {
    const { dispatch } = this.props;
    dispatch(moneyActions.changeInput(money));
  }

  handleCancel = () => {
    const { dispatch } = this.props;
    dispatch(moneyActions.showWithdrawal(false));
    this.props.form.resetFields();
  }

  calculateActualMoney = (money, fee) => {
    money = isNaN(money) ? 0 : money;
    return formatMoney(Math.max((money || 0) - fee, 0));
  }

  formatBankList = (list) => {
    if (!list) return [];
    const typeObj = {
      0: '对私账户',
      1: '对公账户',
      2: '微信零钱',
    };
    list = list.map(val => {
      val.label = typeObj[val.isPublic];
      return val;
    });
    return list;
  }

  onTypeChange = (value) => {
    this.setState({
      accountType: Number(value),
    });
  }

  getCurrentBank = () => {
    const { bankInfo: { result: bankResult = {} } = {} } = this.props;
    const bankList = bankResult.banks || [];
    const accountType = this.getAccountType();
    let bankInfo = bankList.filter(val => {
      return val.isPublic === accountType;
    });
    return bankInfo.length ? bankInfo[0] : {};
  }

  getAccountType = () => {
    const { bankInfo: { result: bankResult = {} } = {} } = this.props;
    const bankList = bankResult.banks || [];
    let { accountType } = this.state;
    if (bankList && bankList.length) {
      accountType = accountType > -1 ? accountType : bankList[0].isPublic;
    }
    return accountType;
  }

  formatWithdrawalRule = (rules) => {
    return rules.sort((a, b) => {
      return a.withdrawStartNumYuan < b.withdrawStartNumYuan;
    });
  }

  getWithdrawalConfig = () => {
    Api.getConfigFn({
      cfgKey0: 'withdraw_start_num',
      cfgKey1: '0',
    }).then(res => {
      let { cfgValue } = res;
      const min = Number(cfgValue) / 100;
      this.setState({
        min,
      });
    });

    Api.getConfigFn({
      cfgKey0: 'wxpay_max_withdraw_money',
      cfgKey1: '0',
    }).then(res => {
      let { cfgValue } = res;
      const max = Number(cfgValue) / 100;
      this.setState({
        max,
      });
    });
  }

  queryWithdrawalTax = (money) => {
    const { dispatch } = this.props;
    dispatch(moneyActions.queryWithdrawalTax(money));
  };

  queryTaxDelay = () => {
    const { form: { getFieldValue, getFieldError } } = this.props;
    const { lastQueryValue } = this.state;

    const withdrawalValue = getFieldValue('money');

    if (!withdrawalValue || withdrawalValue === lastQueryValue) return;
    const err = getFieldError('money');
    if (err && err.length) return;
    this.setState({
      lastQueryValue: withdrawalValue,
    });
    this.queryWithdrawalTax(withdrawalValue);
  };

  // 点击输入框时开启定时器，查询费率
  handleFocus = () => {
    this.timer = setInterval(() => {
      this.queryTaxDelay();
    }, 300);
  };

  // 失去焦点时取消定时器
  handleBlur = () => {
    this.timer = null;
  };

  render() {
    const {
      accountInfo: {
        loading,
      },
      showWithdrawal,
      bankInfo: {
        result: bankInfo = {},
      },
      moneyInfo: {
        result: moneyInfo = {},
      },
      queryWithdrawalTaxResult: {
        result: withdrawalTax,
      },
    } = this.props;
    const { getFieldDecorator, getFieldsValue } = this.props.form;
    const { min, max } = this.state;

    console.log(withdrawalTax);
    const { tipsInfo, auxiliaryExpensesYuan } = withdrawalTax || {};

    const withdrawInput = getFieldsValue().money;
    let withdrawStartNumYuan = formatMoney(min);

    let { frozenMoney } = moneyInfo;
    // 可提现金额，微信最大值为5000
    const isWechat = this.getAccountType() === 2;
    let canWithdrawNum = isWechat ? Math.min(max, moneyInfo.canWithdrawNum) : moneyInfo.canWithdrawNum;
    canWithdrawNum -= frozenMoney;

    const formItemLayout = {
      labelCol: { span: 6 },
      wrapperCol: { span: 18 },
    };
    const formItemSpaceLayout = {
      wrapperCol: { span: 20, offset: 3 },
    };
    const placeholder = withdrawStartNumYuan && withdrawStartNumYuan > 0
      ? `请输入大于${withdrawStartNumYuan}的数字`
      : '请输入提现金额';

    const isEmpty = withdrawInput === '' || withdrawInput === undefined || !withdrawalTax;
    const bankList = this.formatBankList(bankInfo.banks);
    const curBank = this.getCurrentBank();
    const { bankId, bankName, accountName, isPublic } = curBank;
    const infoArr = [
      { name: '提现账户号', value: accountName },
      { name: '提现银行', value: bankName },
    ];
    isPublic !== 2 && (infoArr.splice(1, 0, {
      name: '提现卡号', value: formatBankCode(bankId || ''),
    }));
    return (
      <Modal
        visible={showWithdrawal}
        okText="提现"
        onCancel={this.handleCancel}
        onOk={this.onSubmit}
        okButtonProps={{ loading }}
        title="资金提现"
      >
        <div className="withdrawal-wrap">
          <Form onSubmit={this.onSubmit}>
            <FormItem className="withdrawal-money" label="账户类型" {...formItemLayout}>
              <Select
                style={{ width: 200 }}
                onChange={this.onTypeChange}
                defaultValue={bankList[0] ? bankList[0].label : ''}
              >
                {mapArrayToOptions(bankList, 'isPublic', 'label')}
              </Select>
            </FormItem>
            {infoArr.map((item) => (
              <FormItem {...formItemLayout} key={item.name} label={item.name}>
                <span>{item.value}</span>
              </FormItem>
            ))}
            <FormItem className="withdrawal-money" label="提现金额" {...formItemLayout}>
              {getFieldDecorator('money', {
                rules: [
                  {
                    required: true,
                    validator: (rule, value, callback) => {
                      if (!value || isNaN(value)) {
                        callback('请输入提现金额');
                      } else if (value < auxiliaryExpensesYuan) {
                        callback('提现金额不能小于手续费');
                      } else if (value < withdrawStartNumYuan) {
                        callback(`请输入大于${withdrawStartNumYuan}的数字`);
                      } else if (value > canWithdrawNum) {
                        callback('超出可提现金额');
                      } else {
                        callback();
                      }
                    },
                  },
                ],
              })(<InputNumber
                precision={2}
                placeholder={placeholder}
                onFocus={this.handleFocus}
                onBlur={this.handleBlur}
              />)}
              元
            </FormItem>
            <FormItem {...formItemLayout} label="可用提现金额">
              <span>{moneyInfo.canWithdrawNum}元</span>
            </FormItem>
            {!!frozenMoney && <FormItem {...formItemLayout} label="冻结金额">
              <span>{frozenMoney}元</span>
            </FormItem>}
            {!isEmpty && tipsInfo ? <FormItem {...formItemSpaceLayout}>
              <div className="withdrawal-tip">
                <Icon type="info-circle" theme="twoTone" />
                <span>提现手续费为{tipsInfo}</span>
              </div>
            </FormItem> : null
            }
          </Form>
          <div className="withdrawal-info">
            <p>到账时间说明：</p>
            <p>预计3个工作日内，具体以银行到账时间为准。</p>
          </div>
        </div>
      </Modal>
    );
  }
}

WithdrawalPage.propTypes = {
  accountInfo: PropTypes.object,
  showWithdrawal: PropTypes.bool,
  withdrawalRule: PropTypes.object,
  bankInfo: PropTypes.object,
  moneyInfo: PropTypes.object.isRequired,
  dispatch: PropTypes.func.isRequired,
  form: PropTypes.object.isRequired,
  queryWithdrawalTaxResult: PropTypes.object.isRequired,
};

WithdrawalPage.defaultProps = {
  accountInfo: {},
  showWithdrawal: false,
  withdrawalRule: {},
  bankInfo: {},
};

const mapStateToProps = ({ money: {
  accountInfo,
  showWithdrawal,
  withdrawalRule,
  moneyInfo,
  queryWithdrawalTaxResult,
}, account: { bankInfo } }) => ({
  accountInfo,
  showWithdrawal,
  withdrawalRule,
  bankInfo,
  moneyInfo,
  queryWithdrawalTaxResult,
});

export default Form.create()(connect(mapStateToProps)(WithdrawalPage));
