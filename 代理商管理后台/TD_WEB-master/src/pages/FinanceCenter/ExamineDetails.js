import React, { Component } from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import { Collapse, Spin, Table } from 'antd';
import { DetailList } from '../../components/DetailList';
import { applyState, applyCheckState } from '../../utils/enum';
import { FINANCE_WIDTH } from '../../utils/constants';
import { datetimeFormat, formatDecimal, formatBankCode } from '../../utils';

const { Panel } = Collapse;

class ExamineDetails extends Component {

  render() {
    const agentMsgColumns = [
      { key: 'mchId', label: '代理商编号', render: text => { return text === null ? '无' : text; } },
      { key: 'mchName', label: '代理商名称', render: text => { return text === null ? '无' : text; } },
      { key: 'contactUser', label: '联系人姓名', render: text => { return text === null ? '无' : text; } },
      { key: 'contactPhone', label: '联系人电话', render: text => { return text === null ? '无' : text; } },
      { key: 'latitude', label: '位置地域', render: text => { return text === null ? '无' : text; } },
      { key: 'createTime', label: '申请提现时间', render: (text) => datetimeFormat(text) },
      { key: 'accountName', label: '提现账号名称' },
      { key: 'bankId', label: '银行卡', render: text => formatBankCode(text) },
      { key: 'bankName', label: '银行名称' },
    ];
    const applyPriceColumns = [
      { key: 'withdrawMoneyTotalYuan', label: '申请提现金额（元）', render: text => formatDecimal(text) },
      { key: 'auxiliaryExpensesYuan', label: '提现手续费（元）', render: text => formatDecimal(text) },
      { key: 'payExpensesYuan', label: '支付手续费（元）', render: text => formatDecimal(text) },
      { key: 'taxYuan', label: '代扣税（元）', render: text => formatDecimal(text) },
      { key: 'withdrawMoneyYuan', label: '预计到账金额（元）', render: text => formatDecimal(text) },
    ];

    let currentStateColumns = [
      { key: 'withdrawState', label: '当前状态', render: text => applyState[text] },
    ];

    const recordColumns = [
      { key: 'checkTime', dataIndex: 'checkTime', title: '审核时间', width: FINANCE_WIDTH, render: text => datetimeFormat(text) },
      {
        dataIndex: 'b',
        key: 'b',
        title: '审核结果',
        width: FINANCE_WIDTH,
        render: (_, record) => {
          if (record && record.checkRecord !== '') {
            const msg = JSON.parse(record.checkRecord);
            return applyCheckState[msg.checkWithDrawRequestVo.withdrawState];
          }
        },
      },
      { key: 'userName', dataIndex: 'userName', width: FINANCE_WIDTH, title: '审核人' },
      {
        key: 's',
        dataIndex: 's',
        title: '审核意见',
        width: FINANCE_WIDTH,
        render: (_, record) => {
          if (record && record.checkRecord !== '') {
            const msg = JSON.parse(record.checkRecord);
            return msg.checkWithDrawRequestVo.alarmCheckMessage;
          }
        },
      },
    ];
    const {
      viewAuditdetailsStatus: {
        loading,
        result,
      },
    } = this.props;
    const { mchInfo, checkHistory, tblWithdraw, ...otherInfo } = result || {};
    const { createTime, ...otherAgentMsgInfo } = mchInfo || {};
    const agentMsgInfo = { ...otherAgentMsgInfo, ...otherInfo };//代理商信息
    const applyPriceInfo = { ...mchInfo, ...otherInfo } || {};//申请提现金额
    const currentStateInfo = { ...mchInfo, ...otherInfo, ...tblWithdraw } || {};//当前状态
    if (currentStateInfo.withdrawState && Math.abs(currentStateInfo.withdrawState) === 3) {
      currentStateColumns.push({ key: 'failedMsg', label: '提现失败原因' });
    }
    const recordInfo = checkHistory;//审核日志
    const tableProps = {
      loading,
      rowKey: 'checkTime',
      dataSource: recordInfo,
      columns: recordColumns,
      pagination: false,
    };
    return (
      <div className="page-examinedetails">
        <Collapse bordered={false} defaultActiveKey={['a', 'b', 'c', 'd']}>
          <Panel header={<h3>代理商信息</h3>} key="a">
            <Spin spinning={loading}>
              <DetailList columns={agentMsgColumns} dataSource={agentMsgInfo} />
            </Spin>
          </Panel>
          <Panel header={<h3>申请金额信息</h3>} key="b">
            <Spin spinning={loading}>
              <DetailList columns={applyPriceColumns} dataSource={applyPriceInfo} />
            </Spin>
          </Panel>
          <Panel header={<h3>当前状态</h3>} key="c">
            <Spin spinning={loading}>
              <DetailList columns={currentStateColumns} dataSource={currentStateInfo} />
            </Spin>
          </Panel>
          <Panel header={<h3>审核日志</h3>} key="d">
            <Spin spinning={loading}>
              <Table {...tableProps} />
            </Spin>
          </Panel>
        </Collapse>
      </div>
    );
  }
}

ExamineDetails.propTypes = {
  viewAuditdetailsStatus: PropTypes.object.isRequired,
};

const mapStateToProps = ({ financeCenter: { viewAuditdetailsStatus } }) => {
  return {
    viewAuditdetailsStatus,
  };
};
export default connect(mapStateToProps)(ExamineDetails);
