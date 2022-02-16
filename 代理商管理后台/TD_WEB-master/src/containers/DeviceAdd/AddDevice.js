import React from 'react';
import PropTypes from 'prop-types';
import { Steps, Button, Tabs, Form } from 'antd';
import { connect } from 'react-redux';

import { action as deviceActions } from '../../pages/Device/store';

import { DeviceInput } from '../../components/DeviceInput';
import { BindAgent } from '../../components/BindAgent/BindAgent';
import { BindBilling } from '../../components/BindBilling/BindBilling';
import { Card } from '../../components/Card';
import { processBillingRules } from '../../utils';
import { ResultModal } from '../../components/Device/ResultModal';
import { ADD } from '../../utils/constants';

import './style.less';

const { Step } = Steps;
const { TabPane } = Tabs;

const steps = [{
  title: '选择设备号',
  desc: '',
}, {
  title: '绑定代理商／商户',
  desc: '（可跳过）',

}, {
  title: '设置计费规则',
  desc: '（可跳过）',
}];

class AddDevice extends React.PureComponent {
  state = {
    current: 0,
    ids: '',
  }
  next() {
    if (this.state.current === 1) {
      this.props.form.validateFields(['agent', 'biz'], (err) => {
        if (err) return;
        const current = this.state.current + 1;
        this.setState({ current });
      });
    } else {
      const ids = this.deviceInput.getIds();
      if (ids && ids.length > 0) {
        const current = this.state.current + 1;
        this.setState({ current });
      }
    }
  }

  prev() {
    const current = this.state.current - 1;
    this.setState({ current });
  }
  handleAddDevice = () => {
    const { form, dispatch } = this.props;
    const ids = this.deviceInput.getIds();
    switch (this.state.current) {
      case 0: {
        if (ids && ids.length > 0) {
          dispatch(deviceActions.addDeviceByIds({
            deviceSN: ids,
            stepSubmit: 0,
          }));
        }
        break;
      }
      case 1: {
        form.validateFields(['agentType', 'agent', 'biz'], (err, values) => {
          if (err) return;
          const mchUserId = values.agentType === 1 ? values.agent : values.biz;
          const data = {
            deviceSN: ids,
            stepSubmit: 1,
            mchUserId,
          };
          dispatch(deviceActions.addDeviceByIds(data));
        });
        break;
      }
      case 2: {
        this.handleAddComplete();
      }
      // no default
    }
  }
  handleAddComplete = () => {
    const { form, dispatch } = this.props;
    const deviceSN = this.deviceInput.getIds();
    // const rules = this.bindBilling.getDeviceRules();
    form.validateFieldsAndScroll((err, values) => {
      if (err) return;
      const mchUserId = values.agentType === 1 ? values.agent : values.biz;
      const service = processBillingRules(values.service);
      const pledge = values.pledge.toString();
      const data = {
        deviceSN,
        stepSubmit: 2,
        mchUserId,
        pledge,
        service,
      };
      dispatch(deviceActions.addDeviceByIds(data));
    });
  }
  render() {
    const { current } = this.state;
    const { form, dispatch, addResultVisible, addDevice, queryAgent } = this.props;
    return (<div className="add-device-wrap">
      <Steps current={current}>
        {steps.map(step => <Step key={step.title} title={step.title} description={step.desc} />)}
      </Steps>
      <Tabs activeKey={current.toString()} tabBarStyle={{ display: 'none' }}>
        <TabPane tab="0" key="0">
          <DeviceInput ref={instance => { this.deviceInput = instance; }} />
        </TabPane>
        <TabPane tab="1" key="1">
          <Card>
            <BindAgent form={form} queryAgent={queryAgent} />
          </Card>
        </TabPane>
        <TabPane tab="2" key="2">
          <Card>
            <BindBilling form={form} />
          </Card>
        </TabPane>
      </Tabs>
      <div className="steps-action">
        { current > 0 && <Button style={{ marginLeft: 8 }} onClick={() => this.prev()}>上一步</Button>}
        { current < steps.length - 1 && <Button type="primary" onClick={() => this.next()}>下一步</Button>}
        { current === steps.length - 1 ?
          <Button type="primary" onClick={this.handleAddComplete}>完成</Button>
          :
          <a onClick={this.handleAddDevice}>跳过其他，立即新增</a>
        }
      </div>
      { addDevice.result && <ResultModal type={ADD} dispatch={dispatch} visible={addResultVisible} result={addDevice.result} />}
    </div>);
  }
}

AddDevice.propTypes = {
  form: PropTypes.object.isRequired,
  dispatch: PropTypes.func.isRequired,
  addDevice: PropTypes.object.isRequired,
  queryAgent: PropTypes.object.isRequired,
  addResultVisible: PropTypes.bool.isRequired,
};

const AddDeviceForm = Form.create()(AddDevice);

const Container = connect(({ device: { queryAgent, addDevice, addResultVisible } }) => ({
  addDevice,
  addResultVisible,
  queryAgent,
}))(AddDeviceForm);

export { Container as AddDevice };
