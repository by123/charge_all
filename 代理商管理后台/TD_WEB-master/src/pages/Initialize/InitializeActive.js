import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { Form, message, Input } from 'antd';
import { connect } from 'react-redux';
import { SaveBtn } from '../../components/SaveBtn';
import { Card } from '../../components/Card/index';
import { RangeInput } from '../../components/DeviceInput/RangeInput';
import { BindAgent } from '../../components/BindAgent/BindAgent';
import { action as deviceActions } from '../Device/store';
import { action as initDeviceActions } from './store';
import { push } from '../../store/router-helper';
import './style.less';

const FormItem = Form.Item;
const TextArea = Input.TextArea;

const formItemLayout = {
  labelCol: {
    span: 9,
  },
  wrapperCol: {
    span: 14,
  },
};

class InitializeActive extends Component {
  componentDidMount() {
    this.props.dispatch(deviceActions.queryAgent({ mchId: this.props.profile.mchId }));
  }

  handleSubmit = () => {
    const { dispatch, form } = this.props;
    const ids = this.rangeInput.getIds('initDevice');
    if (ids) {
      form.validateFieldsAndScroll((err, values) => {
        if (err) return;
        const { agentType, agent, biz, ...otherProps } = values;
        const mchId = agentType === 1 ? agent : biz;
        const pwdType = agentType;
        dispatch(initDeviceActions.initDevice({
          mchId,
          pwdType,
          snList: ids,
          ...otherProps,
        }, (_, getState) => {
          if (getState().active.initDevice) {
            message.success('已提交');
            setTimeout(() => {
              dispatch(push('/initialize'));
            }, 1000);
          } else {
            message.error('激活设备失败');
          }
        }));
      });
    }
  }
  render() {
    const { form, queryAgent, dispatch } = this.props;
    const saveProps = {
      onOk: this.handleSubmit,
      okText: '新增设备出厂',
      cancelText: '返回设备出厂列表',
      onCancel: () => dispatch(push('/initialize')),
    };

    return (
      <div className="page-initialize">
        <div className="content-header"><h2>新增设备出厂</h2></div>
        <Card title="第一步：选择设备起止编号">
          <RangeInput wrappedComponentRef={instance => { this.rangeInput = instance; }} />
        </Card>
        <Card title="第二步：分配至代理商／商户">
          <BindAgent form={form} queryAgent={queryAgent} />
        </Card>
        <Card title="第三步：其他信息（非必填）">
          <Form style={{ width: 500, marginTop: 20 }}>
            <FormItem label="快递信息" {...formItemLayout}>
              {form.getFieldDecorator('expressInfo')(
                <Input placeholder="请填写快递名称，快递单号" />
              )}
            </FormItem>
            <FormItem label="其他备注" {...formItemLayout}>
              {form.getFieldDecorator('remarks')(
                <TextArea placeholder="备注信息" />
              )}
            </FormItem>
          </Form>
        </Card>
        <div className="btn-wrapper">
          <SaveBtn {...saveProps} />
        </div>
      </div>
    );
  }
}

InitializeActive.propTypes = {
  form: PropTypes.object.isRequired,
  queryAgent: PropTypes.object.isRequired,
  dispatch: PropTypes.func.isRequired,
  profile: PropTypes.object.isRequired,
};

const InitializeActiveForm = Form.create()(InitializeActive);

export default connect(({ global: { profile }, device: { queryAgent, editDevice, deviceResultVisible }, active: { initDevice } }) => ({
  editDevice,
  deviceResultVisible,
  queryAgent,
  profile,
  initDevice,
}))(InitializeActiveForm);
