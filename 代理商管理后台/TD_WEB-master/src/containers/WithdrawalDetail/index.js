import React from 'react';
import { Form, Icon, Modal, Steps, Divider } from 'antd';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import { action as moneyActions } from '../../pages/Money/store';
import { formatWithdrawalState, datetimeFormat, formatBankCode, formatMoney } from '../../utils';

import '../../pages/Money/style.less';

const FormItem = Form.Item;
const { Step } = Steps;

class WithdrawalDetailPage extends React.PureComponent {

  handleCancel = () => {
    const { dispatch } = this.props;
    dispatch(moneyActions.toggleMoneyDetail(false));
  }

  getReason = (data) => {
    const { withdrawState, alarmCheckMessage, failedMsg } = data;
    let reason = '';
    if (withdrawState === -3) {
      reason = alarmCheckMessage || '';
    } else if (withdrawState === 3) {
      reason = failedMsg || '';
    }
    return reason;
  }

  formatBankId = (bankCode, isPublic) => {
    return isPublic === 2 ? '微信零钱' : formatBankCode(bankCode);
  }

  render() {
    const {
      moneyDetail: {
        result,
        loading,
      },
      moneyDetailVisible,
    } = this.props;
    const moneyDetail = result || {};
    const {
      bank_orderid,
      bankId,
      withdrawMoneyYuan = 0,
      auxiliaryExpensesYuan = 0,
      createTime,
      accountName,
      withdrawState,
      withdrawMoneyTotalYuan = 0,
      isPublic,
      payExpensesYuan,
      taxYuan,
    } = moneyDetail;
    const formattedWithdrawalState = formatWithdrawalState(withdrawState);
    let infoArr = [
      { name: '提现金额', value: `${formatMoney(withdrawMoneyTotalYuan)}元` },
      { name: '提现手续费', value: `${formatMoney(auxiliaryExpensesYuan)}元` },
      { name: '支付手续费', value: `${formatMoney(payExpensesYuan)}元` },
      { name: '代扣税', value: `${formatMoney(taxYuan)}元` },
      { name: '实际到账金额', value: `${formatMoney(withdrawMoneyYuan)}元` },
      { name: '提现账户名', value: accountName },
      { name: '提现卡号', value: this.formatBankId(bankId, isPublic) },
      { name: '提现状态', value: formattedWithdrawalState.value },
    ];
    bank_orderid && (infoArr.unshift({
      name: '流水号', value: bank_orderid || '',
    }));
    const formItemLayout = {
      labelCol: { span: 6 },
      wrapperCol: { span: 18 },
    };
    const formItemSpaceLayout = {
      wrapperCol: { span: 20, offset: 3 },
    };
    const current = formattedWithdrawalState.code;
    const steps = [{
      title: '提交提现申请',
      desc: datetimeFormat(createTime),
    }, {
      title: '提现处理中',
      desc: '',
    }, {
      title: `提现${current === 3 ? '失败' : '成功'}`,
      desc: '',
    }];
    const reason = this.getReason(moneyDetail);
    return (
      <Modal
        visible={moneyDetailVisible}
        footer={null}
        onCancel={this.handleCancel}
        okButtonProps={{ loading }}
        title="提现详情"
        width={600}
      >
        <div className="withdrawal-wrap">
          <Steps current={current === 3 ? 2 : current} status={current > 2 ? 'error' : 'process'}>
            {steps.map(step => <Step key={step.title} title={step.title} description={step.desc} />)}
          </Steps>
          <Divider />
          <Form onSubmit={this.onSubmit}>
            {infoArr.map((item) => (
              <FormItem {...formItemLayout} key={item.name} label={item.name}>
                <span>{item.value}</span>
              </FormItem>
            ))}
            {current === 3 && <FormItem {...formItemSpaceLayout}>
              <div className="withdrawal-tip">
                <Icon type="info-circle" theme="twoTone" />
                <span>{reason}</span>
              </div>
            </FormItem>
            }
          </Form>
        </div>
      </Modal>
    );
  }
}

WithdrawalDetailPage.propTypes = {
  moneyDetail: PropTypes.object,
  dispatch: PropTypes.func.isRequired,
  moneyDetailVisible: PropTypes.bool,
};

WithdrawalDetailPage.defaultProps = {
  moneyDetail: {},
  moneyDetailVisible: false,
};

const mapStateToProps = ({ money: {
  moneyDetail,
  moneyDetailVisible,
} }) => ({
  moneyDetail,
  moneyDetailVisible,
});

export default Form.create()(connect(mapStateToProps)(WithdrawalDetailPage));
