import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Collapse, Spin, Table, Input, Modal, Button, message } from 'antd';
import { DetailList } from '../../components/DetailList';
import { FINANCE_WIDTH } from '../../utils/constants';
import { applyState, applyCheckState } from '../../utils/enum';
import { datetimeFormat, formatDecimal } from '../../utils';
import { action as applyActions } from './store';

const { Panel } = Collapse;
const { TextArea } = Input;

class WarningHandle extends Component {
  constructor(props) {
    super(props);
    //this.alarmCheckMessage = '';
    this.state = {
      alarmCheckMessage: '',
    };
    this.withdrawState = 0;//0 审核通过  -3 审核不通过;
  }
  handleCancel = () => {
    this.props.dispatch(applyActions.toggleWarinEditModal(!this.props.toggleWarinEditModalVisible));
    this.setState({ alarmCheckMessage: '' });
  }

  submitHandle = (key) => {
    const params = {
      alarmCheckMessage: this.state.alarmCheckMessage,
      withDrawId: this.props.withDrawId,
      withdrawState: key,
    };
    if (this.state.alarmCheckMessage === '') {
      message.error('财务审核意见不能为空');
      return false;
    }
    this.props.dispatch(applyActions.checkWithDrawRequestAfterLianLianWarned(params));
    this.props.dispatch(applyActions.toggleWarinEditModal(!this.props.toggleWarinEditModalVisible));
    this.setState({ alarmCheckMessage: '' });
    this.props.fetchExamineList();
  }

  render() {
    const agentMsgColumns = [
      { key: 'mchId', label: '代理商编号', render: text => { return text === null ? '无' : text; } },
      { key: 'mchName', label: '代理商名称', render: text => { return text === null ? '无' : text; } },
      { key: 'contactUser', label: '联系人姓名', render: text => { return text === null ? '无' : text; } },
      { key: 'contactPhone', label: '联系人电话', render: text => { return text === null ? '无' : text; } },
      { key: 'latitude', label: '位置地域', render: text => { return text === null ? '无' : text; } },
      { key: 'createTime', label: '申请提现时间', render: (text) => datetimeFormat(text) },
    ];

    const applyPriceColumns = [
      { key: 'withdrawMoneyTotalYuan', label: '申请提现金额（元）', render: text => formatDecimal(text) },
      { key: 'auxiliaryExpensesYuan', label: '手续费（元）', render: text => formatDecimal(text) },
      { key: 'withdrawMoneyYuan', label: '预计到账金额（元）', render: text => formatDecimal(text) },
    ];

    const currentStateColumns = [
      { key: 'withdrawState', label: '当前状态', render: text => applyState[text] },
    ];

    const recordColumns = [
      // { dataIndex: 'examineTime', title: '审核时间', render: text => { return text ? datetimeFormat(text) : null; } },
      // { dataIndex: 'examineResult', title: '审核结果' },
      // { dataIndex: 'userName', title: '审核人' },
      // { dataIndex: 'alarmCheckMessage', title: '审核意见' },
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
      toggleWarinEditModalVisible,
    } = this.props;
    const { mchInfo, checkHistory, ...otherInfo } = result || {};
    const agentMsgInfo = mchInfo;//代理商信息
    const applyPriceInfo = { ...mchInfo, ...otherInfo } || {};//申请提现金额
    const currentStateInfo = { ...mchInfo, ...otherInfo } || {};//当前状态
    const recordInfo = checkHistory;//审核日志
    const tableProps = {
      loading,
      rowKey: 'index',
      dataSource: recordInfo,
      columns: recordColumns,
      pagination: false,
    };
    const textAreaConfig = {
      rows: 4,
      placeholder: '请输入备注',
    };
    const modalOptions = {
      visible: toggleWarinEditModalVisible,
      width: 900,
      title: (<div>
        <span style={{ display: 'line-block', marginRight: '10%' }}>银行预警待处理</span>
        <span>{`提现申请编号  ${this.props.withDrawId}`}</span>
      </div>),
      onCancel: this.handleCancel,
      destroyOnClose: true,
      maskClosable: false,
      onOk: this.submitHandle,
      footer: null,
    };
    return (
      <div className="page-warninghandle">
        <Modal {...modalOptions} className="page-warninghandle-modal">
          <Collapse bordered={false} defaultActiveKey={['a', 'b', 'c', 'd', 'e']}>
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
            <Panel header={<h3>财务审核意见</h3>} key="e">
              <TextArea {...textAreaConfig} onChange={(e) => { this.setState({ alarmCheckMessage: e.target.value }); }} />
            </Panel>
          </Collapse>
          <div className="footer">
            <Button type="primary" onClick={this.submitHandle.bind(this, 0)}>银行风险审核通过</Button>
            <Button type="danger" onClick={this.submitHandle.bind(this, '-3')}>银行风险审核不通过</Button>
          </div>
        </Modal>
      </div>
    );
  }
}
WarningHandle.propTypes = {
  withDrawId: PropTypes.string,
  fetchExamineList: PropTypes.func.isRequired,
  dispatch: PropTypes.func.isRequired,
  toggleWarinEditModalVisible: PropTypes.bool.isRequired,
  viewAuditdetailsStatus: PropTypes.object.isRequired,
};

WarningHandle.defaultProps = {
  withDrawId: '',
};

const mapStateToProps = ({ financeCenter: { viewAuditdetailsStatus, toggleWarinEditModalVisible } }) => {
  return {
    viewAuditdetailsStatus,
    toggleWarinEditModalVisible,
  };
};
export default connect(mapStateToProps)(WarningHandle);
