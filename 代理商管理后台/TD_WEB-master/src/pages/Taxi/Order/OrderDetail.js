import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Collapse, Spin, Button } from 'antd';
import { DetailList } from '@/components/DetailList';
import { orderStatus, payTypes, endTypes, allAgentLevelTypes } from '@/utils/enum';
import {
  checkIsSuperAdmin,
  concatLabel,
  datetimeFormat,
  formatDecimal,
  formatMinLength,
  addAgentList,
} from '@/utils';
import { SaveBtn } from '@/components/SaveBtn';
import { action as orderActions } from '@/pages/Order/store';

const { Panel } = Collapse;

class OrderDetail extends React.Component {
  handleRefund = () => {
    let detail = this.props.detailData.result;
    detail.orderId = detail.tblOrder.orderId;
    this.props.dispatch(orderActions.toggleRefundModal(true, detail));
  }

  toggleQueryPwdModal = (disabled) => {
    this.props.dispatch(orderActions.queryPwdListByAction('', () => {
      this.props.dispatch(orderActions.toggleQueryPwdModal(true, disabled));
    }));
  }

  render() {
    const {
      dispatch,
      detailData: {
        loading,
        result,
      },
      isSuperAdmin,
    } = this.props;

    const { tblOrder, tblOrderUsermobile = {}, passwordCatchRecord, ...otherInfo } = result || {};
    const incomeInfo = { ...tblOrder, ...otherInfo, ...tblOrderUsermobile } || {}; // 订单收入信息
    const profitInfo = otherInfo; // 分润比例
    const deviceInfo = addAgentList({ ...otherInfo, ...tblOrder }); // 设备信息
    const refundInfo = otherInfo; // 退款信息
    const customerInfo = passwordCatchRecord ? { ...passwordCatchRecord, ...passwordCatchRecord.passwordInfo.data } : null;
    const queryPwdBtn = <Button type="primary" onClick={() => this.toggleQueryPwdModal(!!customerInfo)}>查询密码</Button>;
    let incomeColumns = [
      { key: 'orderId', label: '订单号' },
      { key: 'prepayId', label: '支付流水号' },
      { key: 'orderStateWeb', label: '支付状态', render: (text) => orderStatus[text] },
      { key: 'orderPriceYuan', label: '订单金额', render: text => formatDecimal(text) },
      { key: 'payType', label: '支付方式', render: text => payTypes[text] },
      { key: 'platformPayTime', label: '支付时间', render: (text) => datetimeFormat(text) },
      { key: 'startTime', label: '开始使用时间', render: (text) => datetimeFormat(text) },
      { key: 'actualEndTime', label: '使用结束时间', render: (text) => datetimeFormat(text) },
      { key: 'actualUseSecond', label: '使用时长', render: (text) => formatMinLength(text) },
      { key: 'orderName', label: '商品名' },
      { key: 'location', label: '使用位置' },
      { key: 'userName', label: '支付用户ID' },
      { key: 'endMode', label: '结束方式', render: text => endTypes[text] },
      { key: 'platform', label: '操作系统' },
      { key: 'system', label: '操作系统版本' },
      { key: 'version', label: '小程序版本号' },
      { key: 'brand', label: '手机品牌' },
      { key: 'model', label: '手机型号' },
    ];
    isSuperAdmin && (incomeColumns.push({
      key: 'deviceCode',
      label: '充电密码',
      render: text => { return <div>{text} {queryPwdBtn}</div>; },
    }));
    const profitColumns = [
      { key: 'servicePriceYuan', label: '消费金额' },
      { key: 'myProfilt', label: '我的收益' },
      { key: 'descendantsTotalProfit', label: '我的下级收益' },
    ];
    const deviceColumns = [
      { key: 'myAgentLevel1', label: allAgentLevelTypes[1] },
      { key: 'myAgentLevel2', label: allAgentLevelTypes[2] },
      { key: 'myAgentLevel3', label: allAgentLevelTypes[3] },
      { key: 'myAgentLevel4', label: allAgentLevelTypes[4] },
      { key: 'groupName', label: '分组' },
      { key: 'deviceName', label: '设备名称' },
      { key: 'deviceSn', label: '设备编号' },
      { key: 'deviceLocation', label: '所属区域' },
      { key: 'mchId', label: '司机账户' },
      { key: 'taxiDriverName', label: '司机姓名' },
      { key: 'taxiDriverPhone', label: '司机手机号' },
      { key: 'name1', label: '副班司机姓名' },
      { key: 'phone1', label: '副班司机手机号' },
      {
        key: 'priceRule',
        label: '计费规则',
        render: (rule) => {
          if (!rule) return;
          const pledge = `${rule.pledge / 100}元押金 `;
          const service = JSON.parse(rule.service);
          const serviceType = rule.serviceType;
          return (serviceType === '1' || serviceType === 1) ? pledge + service.map(s => `/${s.price / 100}元${s.time / 60}小时`).join(' ') : `前${service.minMinutes / 60}小时扣费${service.minMoney / 100}元，超过${service.minMinutes / 60}小时，每${service.stepMinutes / 60}小时收费${service.price / 100}元/预付金${service.prepaid / 100}元/封顶${service.maxMoney / 100}元`;
        },
      },
      { key: 'profitToTaxi', label: '分润比例', render: text => `${text || 0}%` },
    ];
    const refundColumns = [
      { key: 'depositPriceYuan', label: '押金金额', render: text => formatDecimal(text) },
      { key: 'refundDepositId', label: '退押金流水号' },
      { key: 'refundDepositTime', label: '退押金时间', render: (text) => datetimeFormat(text) },
      { key: 'refundMoneyYuan', label: '退款金额', render: text => formatDecimal(text) },
      { key: 'refundId', label: '退款金流水号' },
      { key: 'refundTime', label: '退款时间', render: (text) => datetimeFormat(text) },
      { key: 'refundOperatorName', label: '退款账号', render: (text, item) => concatLabel(text, ' ', item.refundOperatorId) },
      { key: 'refundReason', label: '退款原因' },
    ];
    const customerColumns = [
      { key: 'createTime', label: '客服处理时间', render: (text) => datetimeFormat(text) },
      { key: 'pwdCount', label: '更改密码位至', render: (text, record) => `${record.password} 第${text}位` },
      { key: 'opName', label: '客服账号' },
    ];

    const operationProps = {
      onOk: this.handleRefund,
      onCancel: () => dispatch(orderActions.toggleDetailModal(false)),
      cancelText: '返回',
      okText: '退款',
    };

    const canRefund = (incomeInfo.orderStateWeb === 2 || incomeInfo.orderStateWeb === 3) && (isSuperAdmin || otherInfo.canRefund);
    return (<div>
      <Collapse bordered={false} onChange={this.handleCollapseChange} defaultActiveKey={['a', 'b', 'c', 'd', 'e']}>
        <Panel header={<h3>订单收入信息</h3>} key="a">
          <Spin spinning={loading}>
            <DetailList columns={incomeColumns} dataSource={incomeInfo} />
          </Spin>
        </Panel>
        <Panel header={<h3>分润比例</h3>} key="b">
          <Spin spinning={loading}>
            <DetailList columns={profitColumns} dataSource={profitInfo} />
          </Spin>
        </Panel>
        <Panel header={<h3>设备信息</h3>} key="c">
          <Spin spinning={loading}>
            <DetailList columns={deviceColumns} dataSource={deviceInfo} />
          </Spin>
        </Panel>
        {incomeInfo.orderStateWeb !== 1 && incomeInfo.orderStateWeb !== 4 &&
          <Panel header={<h3>退款信息</h3>} key="d">
            <Spin spinning={loading}>
              <DetailList columns={refundColumns} dataSource={refundInfo} />
            </Spin>
          </Panel>}
        {isSuperAdmin && customerInfo &&
          <Panel header={<h3>客服处理信息</h3>} key="e">
            <Spin spinning={loading}>
              <DetailList columns={customerColumns} dataSource={customerInfo} />
            </Spin>
          </Panel>
        }
      </Collapse>
      {canRefund && <SaveBtn {...operationProps} />}
    </div>);
  }
}
OrderDetail.propTypes = {
  dispatch: PropTypes.func.isRequired,
  detailData: PropTypes.object.isRequired,
  isSuperAdmin: PropTypes.bool.isRequired,
};

const Container = connect(({ taxiOrder: { orderDetail }, global: { profile } }) => ({
  detailData: orderDetail,
  isSuperAdmin: checkIsSuperAdmin(profile, 4),
}))(OrderDetail);

export { Container as OrderDetail };
