import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Collapse, Spin, Form, Row, Col } from 'antd';
import { DetailList } from '@/components/DetailList';
import { DeviceInfo } from '@/components/Device/DeviceInfo';
import { allAgentLevelTypes } from '@/utils/enum';

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

    const { deviceMach, deviceDetail, devicePriceCfg, driverInfo, profitToTaxi } = result || {};
    const agentInfo = {
      agent1: '-',
      agent2: '-',
      agent3: '-',
      groupName: deviceDetail ? deviceDetail.groupName : '',
    };
    if (deviceMach) {
      deviceMach.forEach(item => {
        item.mchType === 0 && (agentInfo[`agent${item.level}`] = item.mchName);
      });
    }
    const agentColumns = [
      { key: 'agent1', label: allAgentLevelTypes[1] },
      { key: 'agent2', label: allAgentLevelTypes[2] },
      { key: 'agent3', label: allAgentLevelTypes[3] },
      { key: 'groupName', label: '分组' },
    ];
    const driverColumns = [
      { key: 'carNumber', label: '车牌号' },
      { key: 'taxiMchId', label: '司机账号' },
      { key: 'driverName', label: '司机姓名' },
      { key: 'driverPhone', label: '司机手机号' },
    ];
    let billingText = '';
    // todo lstAssiantDriver
    if (devicePriceCfg && devicePriceCfg.service) {
      let service = JSON.parse(devicePriceCfg.service)[0] || {};
      if (service) {
        billingText = `${(service.service || service.price) / 100}元${service.time / 60}小时`;
      }
    }
    let driverDetail = driverInfo || {};
    if (driverDetail.lstAssiantDriver && driverDetail.lstAssiantDriver.length) {
      const mutiple = driverDetail.lstAssiantDriver.length > 1;
      driverDetail.lstAssiantDriver.map((val, index) => {
        driverDetail[`name${index}`] = val.name;
        driverDetail[`mobile${index}`] = val.mobile;
        driverDetail[`userId${index}`] = val.userId;
        driverColumns.push({ key: `userId${index}`, label: `副班司机账户${mutiple ? index + 1 : ''}` });
        driverColumns.push({ key: `name${index}`, label: `副班司机名称${mutiple ? index + 1 : ''}` });
        driverColumns.push({ key: `mobile${index}`, label: `副班司机手机号${mutiple ? index + 1 : ''}` });
        return val;
      });
    }
    return (<div>
      <Collapse bordered={false} onChange={this.handleCollapseChange} defaultActiveKey={['a', 'b', 'c', 'd', 'e']}>
        <Panel header={<h3>设备信息</h3>} key="a">
          <DeviceInfo dataSource={deviceDetail} loading={loading} />
        </Panel>
        <Panel header={<h3>所属代理商信息</h3>} key="b">
          <Spin spinning={loading}>
            <DetailList columns={agentColumns} dataSource={agentInfo} />
          </Spin>
        </Panel>
        <Panel header={<h3>司机信息</h3>} key="c">
          <Spin spinning={loading}>
            <DetailList columns={driverColumns} dataSource={driverDetail} />
          </Spin>
        </Panel>
        <Panel header={<h3>计费信息</h3>} key="d">
          <Spin spinning={loading}>
            <Row>
              <Col span={12}>
                <FormItem label="计费规则" {...billingProps}>{billingText}</FormItem>
              </Col>
            </Row>
          </Spin>
        </Panel>
        <Panel header={<h3>分润比例</h3>} key="e">
          <Spin spinning={loading}>
            <Row>
              <Col span={12}>
                <FormItem label="司机分润比例" {...billingProps}>{profitToTaxi || 0}%</FormItem>
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
