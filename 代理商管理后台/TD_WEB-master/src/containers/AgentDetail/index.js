import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Collapse, Spin } from 'antd';
import { DetailList } from '../../components/DetailList';
import { dateFormat, datetimeFormat, concatLabel, formatAgentType } from '../../utils';

import { AGENT, BIZ } from '../../utils/constants';

const { Panel } = Collapse;

class AgentDetail extends React.Component {
  render() {
    const {
      detailData: {
        loading,
        result,
      },
    } = this.props;

    const agentDetail = result || {};
    const agentType = agentDetail.mchType === 1 ? BIZ : AGENT;
    const labelPrefix1 = agentType === AGENT ? '代理商' : '商户';
    // const labelPrefix2 = agentType === AGENT ? '子代理商' : '商户';
    const labelPrefix3 = agentType === AGENT ? '代理人' : '联系人';

    let agentColumns = [
      { key: 'mchType', label: '代理商类型', render: (mchType, record) => formatAgentType(mchType, record.level) },
      { key: 'mchId', label: '代理商编号' },
      { key: 'superUser', label: `${labelPrefix1}账号` },
      { key: 'mchName', label: `${labelPrefix1}名称` }, // 商户名称
      { key: 'contactUser', label: `${labelPrefix3}姓名` }, // 商户姓名
      { key: 'contactPhone', label: `${labelPrefix3}电话` }, // 商户电话
      { key: 'settementPeriod', label: '结算周期', render: text => `T+${text}` }, // 商户电话
      { key: 'blockedAmountYuan', label: '冻结金额' },
    ];
    if (agentType === AGENT) {
      agentColumns = agentColumns.concat({ key: 'contractTime', label: '合同结束期', render: text => dateFormat(text) });
    }
    agentColumns = agentColumns.concat([
      { key: 'salesName', label: '关联业务员' },
      { key: 'createTime', label: '账号创建日期', render: text => datetimeFormat(text) },
      {
        key: 'detailAddr',
        label: '位置地域',
        render: (text, record) => {
          const area = record.area ? `${record.province} ${record.city} ${record.area}` : '';
          return text ? area + text : area;
        },
      }]);
    if (agentType === BIZ) {
      agentColumns = agentColumns.concat({ key: 'industry', label: '商户行业' });
    }
    agentColumns = agentColumns.concat([
      { key: 'provinceAgentMchName', label: '省代' },
      { key: 'cityAgentMchName', label: '市代' },
      { key: 'countryAgentMchName', label: '区/县代' },
      { key: 'listAgentMchName', label: '连锁门店' },
    ]);
    const deviceColumns = [
      { key: 'deviceTotal', label: '设备总数' },
      { key: 'deviceActiveTotal', label: '设备激活数' },
      { key: 'transTotal', label: '订单总数' },
      { key: 'moneyTotalYun', label: '订单总金额' },
    ];
    const childAgentColumns = [
      { key: 'agentLevel2Total', label: '二级代理商总数' },
      { key: 'agentLevel3Total', label: '三级代理商总数' },
      { key: 'tenantTotal', label: '终端商户总数' },
    ];

    const profitColumns = [
      { key: 'totalPercent', label: '分润比例', render: (text) => concatLabel(text, '%') },
    ];

    let { mchPriceRule = [{}] } = agentDetail;
    mchPriceRule = mchPriceRule || [{}];
    const priceRuleColumns = [
      { key: 'pledgeYuan', label: '押金', render: text => `${text} 元` },
      { key: 'service',
        label: '计费',
        render: (rule) => {
          if (!rule) return;
          const service = JSON.parse(rule);
          const serviceType = rule.serviceType;
          return (serviceType === '1' || serviceType === 1) ? service.map(s => `/${s.price / 100}元${s.time / 60}小时`).join(' ') : `前${service.minMinutes / 60}小时扣费${service.minMoney / 100}元，超过${service.minMinutes / 60}小时，每${service.stepMinutes / 60}小时收费${service.price / 100}元/预付金${service.prepaid / 100}元/封顶${service.maxMoney / 100}元`;
        },
      },
    ];
    return (<div>
      <Collapse bordered={false} onChange={this.handleCollapseChange} defaultActiveKey={['a', 'b', 'c', 'd', 'e']}>
        <Panel header={<h3>{labelPrefix1}详情</h3>} key="a">
          <Spin spinning={loading}>
            <DetailList columns={agentColumns} dataSource={agentDetail} />
          </Spin>
        </Panel>
        <Panel header={<h3>设备信息</h3>} key="b">
          <Spin spinning={loading}>
            <DetailList columns={deviceColumns} dataSource={agentDetail} />
          </Spin>
        </Panel>
        {agentDetail.mchType === 0 &&
        <Panel header={<h3>子级代理商信息</h3>} key="c">
          <Spin spinning={loading}>
            <DetailList columns={childAgentColumns} dataSource={agentDetail} />
          </Spin>
        </Panel>}
        <Panel header={<h3>分润比例</h3>} key="d">
          <Spin spinning={loading}>
            <DetailList columns={profitColumns} dataSource={agentDetail} />
          </Spin>
        </Panel>
        {agentDetail.mchType === 1 &&
        <Panel header={<h3>商户默认计费规则</h3>} key="e">
          <Spin spinning={loading}>
            <DetailList columns={priceRuleColumns} dataSource={mchPriceRule[0]} />
          </Spin>
        </Panel>
        }
      </Collapse>
    </div>);
  }
}
AgentDetail.propTypes = {
  detailData: PropTypes.object.isRequired,
};

const Container = connect(({ agent: { detailData } }) => ({
  detailData,
}))(AgentDetail);

export { Container as AgentDetail };
