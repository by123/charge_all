import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Tooltip, Button, Icon, Tabs, Spin, message, Modal } from 'antd';
import { action as moneyActions } from './store';
import { action as accountActions } from '../Account/store';
import { OperationLink } from '../../components/OperationLink';
import { PageList } from '../../containers/PageList';
import {
  formatToThousands,
  dateFormat,
  datetimeFormat,
  formatWithdrawalState,
  formatMoney,
  formatBankId,
} from '../../utils/index';
import { DateFilter } from '../../containers/DateFilter';
import Withdrawal from '../../containers/Withdrawal';
import WithdrawalDetail from '../../containers/WithdrawalDetail';
import { AddBankModal } from '../../containers/AccountAddBank/AddBankModal';

import './style.less';

const TabPane = Tabs.TabPane;

class MoneyPage extends React.Component {

  componentDidMount() {
    this.fetchList();
    this.fetchInfo();
  }

  componentDidUpdate({ location }) {
    if (!Object.is(this.props.location, location)) {
      this.fetchList();
    }
  }

  openDetail = (withDrawId) => {
    const { dispatch } = this.props;
    dispatch(moneyActions.fetchMoneyDetail(withDrawId));
    dispatch(moneyActions.toggleMoneyDetail(true));
  }

  changeTab = (e) => {
    const { dispatch } = this.props;
    dispatch(moneyActions.changeTab(e));
  }

  fetchInfo = () => {
    const { dispatch } = this.props;
    dispatch(moneyActions.fetchInfo());
  }

  fetchList = () => {
    const { dispatch, location: { query }, category } = this.props;
    if (category === 'balance') {
      dispatch(moneyActions.fetchMoneyList(query));
    } else {
      dispatch(moneyActions.fetchMoneyWithdrawalList(query));
    }
  }

  openWithdrawal = () => {
    const { dispatch } = this.props;
    const { moneyInfo: { result }, bankInfo: { result: bankResult } } = this.props;
    const bankInfo = bankResult ? bankResult.banks : null;
    const { canWithdrawNum } = result || {};
    if (canWithdrawNum && canWithdrawNum > 0) {
      if (bankInfo && bankInfo.length) {
        dispatch(moneyActions.showWithdrawal(true));
      } else if (bankInfo && !bankInfo.length) {
        // 已获取银行卡信息，但未添加银行卡
        dispatch(moneyActions.toggleEmptyBank(true));
      } else {
        // 未获取到银行卡信息
        dispatch(accountActions.fetchBankInfo((_, getState) => {
          const { bankInfo: bankData } = getState().account;
          if (!bankData.result.banks || !bankData.result.banks.length) {
            dispatch(moneyActions.toggleEmptyBank(true));
          } else {
            dispatch(moneyActions.showWithdrawal(true));
          }
        }));
      }
    } else {
      message.warn('可提现金额不足');
    }
  }

  fetchBankInfo = () => {
    this.props.dispatch(accountActions.fetchBankInfo());
  }

  showAddBank = () => {
    const { dispatch } = this.props;
    dispatch(moneyActions.toggleEmptyBank(false));
    dispatch(accountActions.fetchBankCodeList());
    dispatch(accountActions.fetchCityCodeList());
    dispatch(accountActions.toggleAddBankModal(true));
  }

  closeEmptyBankModal = () => {
    this.props.dispatch(moneyActions.toggleEmptyBank(false));
  }

  render() {
    const {
      location: { search },
      moneyData: {
        result: {
          pages: {
            rows: dataSource = [],
            totalCount: total = 0,
            pageSize = 10,
            pageId: current = 1,
          } = {},
        } = {},
        loading = false,
      },
      withdrawalList,
      moneyInfo: {
        result,
        loading: moneyLoading,
      },
      category = 'balance',
      emptyBankModalVisible,
    } = this.props;
    const moneyInfo = result || {};
    const calProfit = (text, item) => {
      let { profitOrderYuan, profitRefundYuan } = item;
      return (Number(profitOrderYuan) - Number(profitRefundYuan)).toFixed(2);
    };
    const formatCanWithdrawal = (text, item) => {
      let canWithDrawDate = item.canWithDrawDate || 0;
      let canWithdal = (new Date().getTime() - canWithDrawDate) > 0;
      return canWithdal ? '可提现' : '不可提现';
    };
    let {
      canWithdrawNum,
      freezeNum,
      balanceAmount,
      frozenMoney,
      total: moneyTotal,
    } = moneyInfo;
    const balanceProps = {
      loading,
      rowKey: 'profitDate',
      pagination: {
        current,
        total,
        pageSize,
      },
      columns: [
        { dataIndex: 'profitDate', title: '收益时间', render: text => dateFormat(text) },
        { dataIndex: 'totalYuan', key: 'money', title: '收益金额', render: (text, item) => calProfit(text, item) },
        { dataIndex: 'profitOrderYuan', title: '订单分润收入（元）', render: text => formatMoney(text) },
        { dataIndex: 'profitRefundYuan', title: '退款订单分润扣款', render: text => formatMoney(text) },
        { dataIndex: 'withdrawTime', title: '状态', render: formatCanWithdrawal },
        { dataIndex: 'canWithDrawDate', title: '预计收益计提时间', render: text => dateFormat(text) },
      ],
      dataSource,
    };
    const withdrawalData = withdrawalList || {};
    const isProfit = category === 'profit';
    const withdrawalTotal = withdrawalData.total || 0;
    const withdrawalProps = {
      loading: withdrawalData.loading = false,
      rowKey: 'withdrawId',
      pagination: {
        current: withdrawalData.current || 1,
        total: withdrawalData.total || 0,
        pageSize: withdrawalData.pageSize || 15,
      },
      columns: [
        { dataIndex: 'createTime', title: '提现时间', render: text => datetimeFormat(text) },
        { dataIndex: 'accountName', title: '提现账户名' },
        { dataIndex: 'bankId', title: '提现卡号', render: (text, record) => formatBankId(text, record) },
        { dataIndex: 'withdrawMoneyTotalYuan', title: '提现金额', render: text => formatMoney(text) },
        { dataIndex: 'auxiliaryExpensesYuan', title: '手续费', render: text => formatMoney(text) },
        { dataIndex: 'payExpensesYuan', title: '支付手续费', render: text => formatMoney(text) },
        { dataIndex: 'taxYuan', title: '代扣税', render: text => formatMoney(text) },
        { dataIndex: 'withdrawMoneyYuan', title: '实际到账金额', render: text => formatMoney(text) },
        { dataIndex: 'withdrawState', title: '状态', render: (text) => formatWithdrawalState(text).value },
        {
          dataIndex: 'p',
          title: '操作',
          render: (_, record) => {
            const options = [
              { text: '查看', action: () => { this.openDetail(record.withdrawId); } },
            ];
            return <OperationLink options={options} />;
          },
        },
      ],
      dataSource: withdrawalData.dataSource,
    };
    const filterProps = {
      search,
      columns: [
        { dataIndex: 'date', title: '收益时间', type: 'dateArea', startKey: 'startDate', endKey: 'endDate', isTime: isProfit },
      ],
    };
    const operations = <DateFilter {...filterProps} />;
    // const operations = <PageFilter {...filterProps} />;
    return (<div className="money-wrapper">
      <div className="content-header">
        <h2>资金信息</h2>
      </div>
      {/* 头部信息 */}
      <Spin spinning={moneyLoading}>
        <div className="money-info">

          <div className="money-info-item info-balance">
            {/* <div className="balance-icon">
            <Icon type="exclamation-circle" theme="filled" />
          </div> */}
            <div className="info-item-content balance-content">
              <div className="content-name">账户余额（元）</div>
              <div className="content-value">￥{formatToThousands(balanceAmount)}</div>
            </div>
            {!!freezeNum && (<div className="balance-tip">
              <Tooltip title={`${formatToThousands(freezeNum)}元提现中`}>
                <div className="tip-icon">
                  <Icon type="exclamation-circle" theme="filled" />
                </div>
              </Tooltip>
            </div>)
            }
          </div>
          <div className="money-info-item info-withdrawal">
            <div className="info-item-content withdrawal-content">
              <div className="content-name">可提现金额（元）</div>
              <div className="content-value">￥{formatToThousands(canWithdrawNum)}</div>
              {!!frozenMoney && <Tooltip title="如有疑问请联系平台或上级代理商">
                <div className="">
                  <span>冻结金额：{formatToThousands(frozenMoney)}元</span>
                  <Icon className="question-icon" type="question-circle" theme="filled" />
                </div>
              </Tooltip>}
            </div>
            <div className="withdrawal-btn">
              <Button type="primary" disabled={!canWithdrawNum} onClick={this.openWithdrawal}>提现</Button>
            </div>
          </div>
          <div className="money-info-item info-total">
            <div className="info-item-content">
              <div className="content-name">历史总收益（元）</div>
              <div className="content-value">￥{formatToThousands(moneyTotal)}</div>
            </div>
          </div>
        </div>
      </Spin>
      {/* table */}
      <div className="money-table-wrap">
        <div className="table-tabs">
          <Tabs onChange={this.changeTab} activeKey={category} type="card" tabBarExtraContent={operations}>
            <TabPane tab="收入明细" key="balance">
              <div className="table-total">共{total}条数据</div>
              <PageList {...balanceProps} />
              <div>
                <div>注意：</div>
                <div>1，收益可提现时间: T+N。(可在“账户管理-账户详情”中查看结算周期)</div>
                <div>2，如之前已经计提的用户订单发生退款，已经分给商户的利润在退款完成当日的收益中进行扣除。</div>
                <div>3，今日收益将在次日10点前统计汇总。</div>
              </div>
            </TabPane>
            <TabPane tab="提现明细" key="withdrawal">
              <div className="table-total">共{withdrawalTotal}条数据</div>
              <PageList {...withdrawalProps} />
            </TabPane>
          </Tabs>
        </div>
      </div>
      <Modal
        visible={emptyBankModalVisible}
        footer={null}
        onCancel={this.closeEmptyBankModal}
        className="empty-bank-modal"
        width={400}
      >
        <div className="empty-bank-main">
          <div className="empty-text">您还未添加银行卡</div>
          <Button onClick={this.showAddBank} type="primary">添加银行卡</Button>
        </div>
      </Modal>
      <Withdrawal />
      <WithdrawalDetail />
      <AddBankModal />
    </div>);
  }
}

MoneyPage.propTypes = {
  moneyData: PropTypes.object,
  moneyInfo: PropTypes.object,
  category: PropTypes.string,
  moneyDetail: PropTypes.object,
  moneyDetailVisible: PropTypes.bool.isRequired,
  emptyBankModalVisible: PropTypes.bool.isRequired,
  bankInfo: PropTypes.object.isRequired,
  withdrawalList: PropTypes.object,
  location: PropTypes.object.isRequired,
  dispatch: PropTypes.func.isRequired,
};

MoneyPage.defaultProps = {
  moneyData: {},
  moneyInfo: {},
  category: 'balance',
  moneyDetail: {},
  withdrawalList: {},
};

export default connect(({
  money: {
    moneyData,
    moneyInfo,
    category,
    moneyDetail,
    moneyDetailVisible,
    emptyBankModalVisible,
    withdrawalList,
  },
  account: { bankInfo },
}) => ({
  moneyData,
  moneyInfo,
  category,
  moneyDetail,
  moneyDetailVisible,
  emptyBankModalVisible,
  bankInfo,
  withdrawalList,
}))(MoneyPage);
