import React from 'react';
import PropTypes from 'prop-types';
import compact from 'lodash/compact';
import { BindAgent } from '../BindAgent/BindAgent';
import { BindBilling } from '../BindBilling/BindBilling';
import { DeviceInfo } from './DeviceInfo';
import { Card } from '../Card';

export class EditDevice extends React.PureComponent {
  render() {
    const { ids, current, form, queryAgent } = this.props;
    const agentData = {};
    const billingData = {};
    const disabled = current && current.deviceDetail && current.deviceDetail.deviceState === 2;
    if (current) {
      const childAgent = current.deviceMach[current.deviceMach.length - 1]; // 去掉一级代理商
      if (childAgent) {
        if (childAgent.mchType === 1) {
          // 商户
          agentData.agentType = 2;
          // agentData.biz = childAgent.superUser;
          agentData.biz = childAgent.mchName;
        } else {
          agentData.agentType = 1;
          // agentData.agent = childAgent.superUser;
          agentData.agent = childAgent.mchName;
        }
      }
      if (current.devicePriceCfg) {
        billingData.service = JSON.parse(current.devicePriceCfg.service) || [];
        billingData.serviceType = current.devicePriceCfg.serviceType;
        if (billingData.serviceType === 1 || billingData.serviceType === '1') {
          billingData.service = compact(billingData.service);
          billingData.service = billingData.service.map(rule => ({
            ...rule,
            price: rule.price / 100,
          }));
        }
        billingData.pledge = current.devicePriceCfg.pledge;
      }
    }
    return (<div>
      { current ?
        <DeviceInfo dataSource={current.deviceDetail} loading={false} colSpan={{ span: 8 }} />
        : <div>
          <p>已选择设备总数：{ids.length}个</p>
          <div className="g-selected-area">{ids.join(',')}</div>
        </div>}
      <Card title="绑定代理商／商户">
        <BindAgent form={form} disabled={disabled} queryAgent={queryAgent} formData={agentData} />
      </Card>
      <Card title="设置计费规则">
        <BindBilling form={form} formData={billingData} />
      </Card>
    </div>);
  }
}

EditDevice.propTypes = {
  form: PropTypes.object.isRequired,
  queryAgent: PropTypes.object.isRequired,
  ids: PropTypes.array,
  current: PropTypes.object,
};

EditDevice.defaultProps = {
  current: undefined,
  ids: [],
};
