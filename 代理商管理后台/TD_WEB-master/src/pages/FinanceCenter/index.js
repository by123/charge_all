import React, { Component } from 'react';
import { connect } from 'react-redux';
import { Drawer } from 'antd';
import PropTypes from 'prop-types';
import { PageFilter } from '../../containers/PageFilter';
import { PageList } from '../../containers/PageList';
import { OperationLink } from '../../components/OperationLink';
import ExamineDetails from './ExamineDetails';
import WarningHandle from './WarningHandle';
import { action as applyActions } from './store';
import { push } from '../../store/router-helper';
import { INDEX_WIDTH, ACTION_WIDTH } from '../../utils/constants';
import { datetimeFormat, formatDecimal, mapObjectToRadios } from '../../utils';
import { applyState, bankFilterType, checkState } from '../../utils/enum';
import './style.less';

class FinanceCenter extends Component {

  constructor(props) {
    super(props);
    this.withdrawState = 0;
    this.withDrawId = '';
  }

  componentDidMount = () => {
    const { location: { query }, dispatch } = this.props;
    if (query.checkState === undefined) {
      dispatch(push('/financeCenter?checkState=0'));
    } else {
      this.fetchExamineList();
    }
  }

  componentDidUpdate({ location }) {
    if (!Object.is(this.props.location, location)) {
      this.fetchExamineList();
    }
  }

  openWarnEditDetail = ({ withDrawId, withdrawState }) => {
    this.withdrawState = withdrawState;
    this.withDrawId = withDrawId;
    this.props.dispatch(applyActions.viewAuditdetails({ withDrawId }));
    this.props.dispatch(applyActions.toggleWarinEditModal(!this.props.toggleWarinEditModalVisible));
  }

  openDetail = (withDrawId) => {
    this.withDrawId = withDrawId;
    this.props.dispatch(applyActions.viewAuditdetails({ withDrawId }));
    this.props.dispatch(applyActions.toggleApplyDetailModal(!this.props.applyDetailVisible));
  }

  closeDetail = () => {
    this.props.dispatch(applyActions.toggleApplyDetailModal(!this.props.applyDetailVisible));
  }

  fetchExamineList = () => {
    const { location: { search } } = this.props;
    this.props.dispatch(applyActions.getApplyLists(search));
  }

  modWithdrawalState = (record, withdrawState) => {
    this.props.dispatch(applyActions.modWithdrawalState({
      withDrawId: record.withdrawId,
      withdrawState,
    }));
  }

  render() {
    //搜索状态栏
    const price = '23186';
    const {
      location: { search },
      applyDetailVisible,
      applyLists: {
        current = 1,
        total = 0,
        loading,
        pageSize = 15,
        dataSource,
        originalData: {
          withdrawTotalNumYuan = 0,
        } = {},
      },
    } = this.props;
    const filterProps = {
      search,
      columns: [
        { dataIndex: 'withDrawId', title: '提现申请编号' },
        { dataIndex: 'mchName', title: '搜索代理商' },
        { dataIndex: 'contactUser', title: '联系人姓名' },
        { dataIndex: 'checkState', title: '审核状态', type: 'select', list: mapObjectToRadios(checkState) },
        { dataIndex: 'date', title: '提现申请时间', type: 'dateArea', startKey: 'beginDate', endKey: 'endDate' },
        { dataIndex: 'channel', title: '提现方式', type: 'select', list: mapObjectToRadios(bankFilterType) },
      ],
    };
    //审核状态列表
    const listProps = {
      rowKey: 'id',
      loading,
      pagination: {
        current,
        total,
        pageSize,
      },
      dataSource,
      columns: [
        { dataIndex: 'id', title: '序号', fixed: 'left', width: INDEX_WIDTH },
        { dataIndex: 'withdrawId', title: '提现申请编号' },
        { dataIndex: 'mchId', title: '代理商/商户账号' },
        { dataIndex: 'mchName', title: '代理商/商户名称', width: 140 },
        { dataIndex: 'contactUser', title: '联系人姓名' },
        { dataIndex: 'withdrawMoneyTotalYuan', title: '申请提现金额（元）', width: 87, render: (text) => formatDecimal(text) },
        { dataIndex: 'auxiliaryExpensesYuan', title: '提现手续费（元）', width: 80, render: text => formatDecimal(text) },
        { dataIndex: 'payExpensesYuan', title: '支付手续费（元）', width: 80, render: text => formatDecimal(text) },
        { dataIndex: 'taxYuan', title: '代收税（元）', width: 80, render: text => formatDecimal(text) },
        { dataIndex: 'withDrawMoneyYuan', title: '实际到账金额（元）', width: 87, render: text => formatDecimal(text) },
        { dataIndex: 'createTime', title: '提现申请时间', render: text => datetimeFormat(text) },
        {
          dataIndex: 'bankPayDate',
          title: '提现完成时间',
          render: (text) => {
            const time = text === null || text === undefined ? '' : datetimeFormat(text);
            return time;
          },
        },
        { dataIndex: 'withdrawState', title: '当前状态', render: text => { return applyState[text] || ''; } },
        {
          dataIndex: 'b',
          title: '操作',
          fixed: 'right',
          width: ACTION_WIDTH + 20,
          render: (_, record) => {
            let options = [];
            if (String(record.withdrawState) === '4') {
              options = [
                { text: '财务审核', action: () => { this.openWarnEditDetail({ withDrawId: record.withdrawId, withdrawState: record.withdrawState }); } },
              ];
            } else {
              options = [
                { text: '查看', action: () => { this.openDetail(record.withdrawId); } },
              ];
            }
            if (record.withdrawState === 0) {
              options.push({ text: '挂起', action: () => { this.modWithdrawalState(record, -2); } });
            } else if (record.withdrawState === -2) {
              options.push({ text: '取消挂起', action: () => { this.modWithdrawalState(record, 0); } });
            }
            // if (record.applyStateWeb === 3) {
            //   options.push({ text: '退款', action: () => { this.openRefundModal(record); } });
            // }
            return <OperationLink options={options} />;
          },
        },
      ],
    };
    const drawerTitle = (<div>
      <span style={{ display: 'line-block', marginRight: '10%' }}>审核详情</span>
      <span>{`提现申请编号  ${this.withDrawId}`}</span>
    </div>);

    return (
      <div className="page-financeCenter">
        <div className="warn-message" style={{ display: 'none' }}>连连支付余额不足，请立即处理；建议充值额度：{`>${price}`} 元 </div>
        <div className="content-header">
          <h2>财务中心</h2>
        </div>
        <PageFilter {...filterProps} />
        <div className="list-desc">
          <p>共搜索到 {total} 条记录，申请提现金额共计 {withdrawTotalNumYuan} 元</p>
        </div>
        <PageList {...listProps} />
        <Drawer title={drawerTitle} width="80%" visible={applyDetailVisible} onClose={this.closeDetail}>
          <ExamineDetails />
        </Drawer>
        <WarningHandle withdrawState={this.withdrawState} withDrawId={this.withDrawId} fetchExamineList={this.fetchExamineList} />
      </div>
    );
  }
}

FinanceCenter.propTypes = {
  location: PropTypes.object.isRequired,
  toggleWarinEditModalVisible: PropTypes.bool.isRequired,
  dispatch: PropTypes.func.isRequired,
  applyDetailVisible: PropTypes.bool.isRequired,
  applyLists: PropTypes.object.isRequired,
};

export default connect(({ financeCenter: {
  applyLists,
  viewAuditdetailsStatus,
  applyDetailVisible,
  toggleWarinEditModalVisible,
} }) => ({
  applyLists,
  viewAuditdetailsStatus,
  applyDetailVisible,
  toggleWarinEditModalVisible,
}))(FinanceCenter);
