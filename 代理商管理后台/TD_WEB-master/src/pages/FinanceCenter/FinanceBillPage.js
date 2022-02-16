import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Tabs, Button, message } from 'antd';
import moment from 'moment';
import { push } from '../../store/router-helper';
import { action } from './store';
import { PageList } from '../../containers/PageList';
import { dateFormat, formatMoney, momentToFormatDate, formatDateToMoment } from '../../utils/index';
import { DatePicker } from '../../components/pop';

import './style.less';

const TabPane = Tabs.TabPane;
const { MonthPicker } = DatePicker;
const moneyToYuan = (money) => {
  money = money || 0;
  money /= 100;
  return formatMoney(money);
};

class FinanceBillPage extends React.Component {

  componentDidMount() {
    if (!this.addInitTime(this.props.location.query)) return;
    this.fetchList();
  }

  componentDidUpdate({ location }) {
    if (!this.addInitTime(this.props.location.query)) return;
    if (!Object.is(this.props.location, location)) {
      this.fetchList();
    }
  }

  addInitTime = (query) => {
    if (!query.year || !query.month) {
      const [year, month] = momentToFormatDate(moment(), false, 'YYYY-MM').split('-');
      this.props.dispatch(push({ query: { ...query, year, month } }));
      return false;
    }
    return true;
  }

  changeTab = (e) => {
    const { dispatch, location: { query } } = this.props;
    dispatch(push({ query: { ...query, category: e } }));
  }

  fetchList = () => {
    const { dispatch, location: { query } } = this.props;
    const { category = 'income' } = query;
    if (category === 'income') {
      dispatch(action.getIncomeList(query));
    } else if (category === 'expend') {
      dispatch(action.getExpendList(query));
    }
  }

  downloadFinanceData = () => {
    const { dispatch, location: { query } } = this.props;
    const { year, month } = query;
    dispatch(action.downloadFinanceData({ year, month }, (_, getState) => {
      const { downloadFinanceDataResult: { result: downloadLink } = {} } = getState().financeCenter;
      if (!downloadLink) {
        message.error('下载链接错误，请联系平台');
        return;
      }
      window.open(downloadLink, '_blank');
    }));
  }

  onDateChange = (value) => {
    const { location: { query } } = this.props;
    let year;
    let month;
    if (value) {
      const date = momentToFormatDate(value, false, 'YYYY-MM');
      [year, month] = date.split('-');
    }
    this.props.dispatch(push({ query: { ...query, year, month } }));
  }

  getPickerDate = () => {
    let pickerDate;
    const { year, month } = this.props.location.query;
    if (year && month) {
      pickerDate = formatDateToMoment(`${year}-${month}`);
    }
    return pickerDate;
  }

  render() {
    const {
      location: { query },
      getIncomeListResult: {
        result: {
          financialIncomePage: {
            rows: dataSource = [],
            totalCount: total = 0,
            pageSize = 15,
            pageId: current = 1,
          } = {},
          totalMoney = 0,
          totalRefund = 0,
          totalServiceCharge = 0,
        } = {},
        loading = false,
      },
      getExpendListResult,
      downloadFinanceDataResult = {},
    } = this.props;

    const incomeProps = {
      loading,
      rowKey: 'id',
      pagination: {
        current,
        total,
        pageSize,
      },
      columns: [
        { dataIndex: 'id', title: '序号' },
        { dataIndex: 'allotDate', title: '时间', width: 100, render: text => dateFormat(text) },
        { dataIndex: 'orderCount', title: '订单总数' },
        { dataIndex: 'totalMoney', title: '订单总金额', render: text => moneyToYuan(text) },
        { dataIndex: 'totalRefund', title: '退款总金额', render: text => moneyToYuan(text) },
        { dataIndex: 'wechatOrderCount', title: '微信订单' },
        { dataIndex: 'wechatTotalMoney', title: '微信订单金额', render: text => moneyToYuan(text) },
        { dataIndex: 'alipayOrderCount', title: '支付宝订单' },
        { dataIndex: 'alipayTotalMoney', title: '支付宝订单金额', render: text => moneyToYuan(text) },
        { dataIndex: 'platformProfit', title: '平台收益', render: text => moneyToYuan(text) },
        { dataIndex: 'agentProfit', title: '代理商收益', render: text => moneyToYuan(text) },
        { dataIndex: 'tenantProfit', title: '商户收益', render: text => moneyToYuan(text) },
        { dataIndex: 'serviceCharge', title: '提现手续费', render: text => moneyToYuan(text) },
        { dataIndex: 'payExpenses', title: '支付手续费', render: text => moneyToYuan(text) },
        { dataIndex: 'tax', title: '代扣税', render: text => moneyToYuan(text) },
      ],
      dataSource,
    };
    const {
      result: {
        financialExpendPage: expendList = {},
      } = {},
      result: expendListResult = {},
      loading: expendListLoading = false,
    } = getExpendListResult || {};
    const withdrawalProps = {
      loading: expendListLoading,
      rowKey: 'id',
      pagination: {
        current: expendList.pageId || 1,
        total: expendList.totalCount || 0,
        pageSize: expendList.pageSize || 15,
      },
      columns: [
        { dataIndex: 'id', title: '序号' },
        { dataIndex: 'allotDate', title: '时间', render: text => dateFormat(text) },
        { dataIndex: 'withdrawalCount', title: '提现总笔数' },
        { dataIndex: 'withdrawalMoney', title: '提现总金额', render: (text) => moneyToYuan(text) },
        { dataIndex: 'cardWithdrawalCount', title: '银行卡提现数' },
        { dataIndex: 'cardWithdrawalMoney', title: '银行卡提现金额', render: text => moneyToYuan(text) },
        { dataIndex: 'wechatWithdrawalCount', title: '微信提现数' },
        { dataIndex: 'wechatWithdrawalMoney', title: '微信提现金额', render: text => moneyToYuan(text) },
        { dataIndex: 'lianlianFee', title: '连连手续费支出', render: text => moneyToYuan(text) },
      ],
      dataSource: expendList.rows,
    };

    const { category = 'income' } = query;
    const pickerDate = this.getPickerDate();

    return (<div className="finance-bill-wrapper">
      <div className="content-header">
        <h2>财务对账</h2>
      </div>
      <div>
        <span>时间：</span>
        <MonthPicker allowClear={false} value={pickerDate} onChange={this.onDateChange} />
        <Button
          className="download-btn"
          type="primary"
          onClick={this.downloadFinanceData}
          loading={downloadFinanceDataResult.loading}
        >下载月度对账单</Button>
      </div>
      <div className="finance-bill-content">
        <div className="table-tabs">
          <Tabs onChange={this.changeTab} activeKey={category} type="card">
            <TabPane tab="收入明细" key="income">
              <div className="table-total">
                <span>订单总金额：{moneyToYuan(totalMoney)}元</span>
                <span>退款总金额：{moneyToYuan(totalRefund)}元</span>
                <span>手续费总收入 ：{moneyToYuan(totalServiceCharge)}元</span>
              </div>
              <PageList {...incomeProps} />
            </TabPane>
            <TabPane tab="支出明细" key="expend">
              <div className="table-total">
                <span>提现总笔数：{expendListResult.totalCount}笔</span>
                <span>提现总金额：{moneyToYuan(expendListResult.totalMoney)}元</span>
                <span>提现手续费总支出 ：{moneyToYuan(expendListResult.totalLianlianFee)}元</span>
              </div>
              <PageList {...withdrawalProps} />
            </TabPane>
          </Tabs>
        </div>
      </div>
    </div>);
  }
}

FinanceBillPage.propTypes = {
  getIncomeListResult: PropTypes.object,
  getExpendListResult: PropTypes.object,
  location: PropTypes.object.isRequired,
  dispatch: PropTypes.func.isRequired,
};

FinanceBillPage.defaultProps = {
  getIncomeListResult: {},
  getExpendListResult: {},
};

export default connect(({
  financeCenter: {
    getIncomeListResult,
    getExpendListResult,
  },
}) => ({
  getIncomeListResult,
  getExpendListResult,
}))(FinanceBillPage);
