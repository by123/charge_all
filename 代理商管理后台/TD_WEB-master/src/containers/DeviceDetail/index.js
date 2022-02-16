import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Collapse, Spin, Form, Row, Col } from 'antd';
import { DetailList } from '../../components/DetailList';
import { DeviceInfo } from '../../components/Device/DeviceInfo';
import { allAgentLevelTypes } from '../../utils/enum';

const { Panel } = Collapse;

const FormItem = Form.Item;
const billingProps = {
  labelCol: { span: 6 },
  wrapperCol: { span: 16 },
  style: {
    marginBottom: 5,
  },
};

class DeviceDetail extends React.Component {
  render() {
    const {
      detailData: {
        loading,
        result,
      },
    } = this.props;

    const { deviceMach, deviceDetail, devicePriceCfg } = result || {};
    const agentInfo = {
      agent1: '-',
      agent2: '-',
      agent3: '-',
      agent4: '-',
      bizName: '-',
      industry: '-',
    };
    if (deviceMach) {
      deviceMach.forEach(item => {
        if (item.mchType === 1) {
          agentInfo.bizName = item.mchName;
          agentInfo.industry = item.industry;
        } else {
          agentInfo[`agent${item.level}`] = item.mchName;
        }
      });
    }
    const agentColumns = [
      { key: 'agent1', label: allAgentLevelTypes[1] },
      { key: 'agent2', label: allAgentLevelTypes[2] },
      { key: 'agent3', label: allAgentLevelTypes[3] },
      { key: 'agent4', label: allAgentLevelTypes[4] },
      { key: 'bizName', label: '商户名称' },
      { key: 'industry', label: '商户行业', render: text => text || '-' },
    ];
    let billingText = '';
    if (devicePriceCfg) {
      const service = JSON.parse(devicePriceCfg.service);
      if (service) {
        const serviceType = devicePriceCfg.serviceType;
        const ruleText = (serviceType === '1' || serviceType === 1) ? service.map(item => `/${item.price / 100}元${item.time / 60}小时`).join(' ') : `前${service.minMinutes / 60}小时扣费${service.minMoney / 100}元，超过${service.minMinutes / 60}小时，每${service.stepMinutes / 60}小时收费${service.price / 100}元/预付金${service.prepaid / 100}元/封顶${service.maxMoney / 100}元`;
        billingText = `${devicePriceCfg.pledge}元押金 ${ruleText}`;
      }
    }
    return (<div>
      <Collapse bordered={false} onChange={this.handleCollapseChange} defaultActiveKey={['a', 'b', 'c']}>
        <Panel header={<h3>设备信息</h3>} key="a">
          <DeviceInfo dataSource={deviceDetail} loading={loading} />
        </Panel>
        <Panel header={<h3>所属代理商信息</h3>} key="b">
          <Spin spinning={loading}>
            <DetailList columns={agentColumns} dataSource={agentInfo} />
          </Spin>
        </Panel>
        <Panel header={<h3>计费信息</h3>} key="c">
          <Spin spinning={loading}>
            <Row>
              <Col span={12}>
                <FormItem label="计费规则" {...billingProps}>{billingText}</FormItem>
              </Col>
            </Row>
          </Spin>
        </Panel>
      </Collapse>
    </div>);
  }
}
DeviceDetail.propTypes = {
  dispatch: PropTypes.func.isRequired,
  detailData: PropTypes.object.isRequired,
};

const Container = connect(({ device: { deviceDetail } }) => ({
  detailData: deviceDetail,
}))(DeviceDetail);

export { Container as DeviceDetail };
