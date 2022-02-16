import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { message, Form, Button } from 'antd';
import { DeviceSelect } from '../../containers/DeviceSelect';
import { action as deviceActions } from './store';
import { action as downloadAction } from '../DownloadModal/store';
import { DownloadModal } from '../DownloadModal';
import { SaveBtn } from '../../components/SaveBtn';
import { Card } from '../../components/Card';
import AgentFilter from '../../containers/AgentFilter';
import { push, replace } from '../../store/router-helper';
import { DEVICE_ALLOCATE } from '../../utils/constants';

const FormItem = Form.Item;
const formItemLayout = {
  wrapperCol: {
    xs: { span: 20 },
    sm: {
      span: 20,
    },
    xl: {
      span: 20,
    },
  },
  labelCol: {
    xs: {
      span: 4,
    },
    sm: {
      span: 4,
    },
    xl: {
      span: 4,
    },
  },
};

const styles = {
  card: { marginBottom: 0 },
};

class DeviceAllocate extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      targetBusiness: '',
    };
  }

  componentDidMount() {
    // this.props.dispatch(deviceActions.queryAgent({ mchId: this.props.profile.mchId }));
  }

  getParamsAndAction = (formData) => {
    let params = {};
    const actionList = {
      2: 'allocateDeviceBySection',
      1: 'allocateDeviceBySn',
      5: 'allocateDeviceByFile',
    };
    let { result, current, mchId } = formData;
    const key = current;
    let fileData = null;
    if (Array.isArray(mchId)) {
      mchId = mchId[mchId.length - 1];
    }
    switch (key) {
      case '2':
        params = { snList: result, mchId };
        break;
      case '1':
        params = { snList: result, mchId };
        break;
      case '5':
        fileData = new FormData();
        fileData.append('file', result[0].originFileObj);
        params = fileData;
        break;
      default:
        break;
    }
    return {
      action: actionList[key],
      params,
    };
  }

  handleSubmit = () => {
    const { dispatch, form } = this.props;
    const selectedValue = this.deviceSelect.getWrappedInstance().getSelectedDevice();
    if (selectedValue.result) {
      form.validateFieldsAndScroll((err, values) => {
        if (err) return;
        if (!values.mchId || !values.mchId.length) {
          message.error('请选择代理商账户');
          return;
        }
        const { action, params } = this.getParamsAndAction(Object.assign({}, selectedValue, values));
        this.props.dispatch(deviceActions[action](params, (_, getState) => {
          const { allocateDeviceResult: { result } } = getState().active;
          message.success(result ? `${result}个设备调拨提交成功` : '申请设备调拨提交成功');
          dispatch(replace(`/initialize/deviceAllocate?key=${Math.random()}`));
          form.resetFields();
          this.toggleDownloadModal(true);
        }, values.mchId[0]));
      });
    }
  }

  toggleDownloadModal = (visible) => {
    this.props.dispatch(downloadAction.toggleDownloadModal(visible, DEVICE_ALLOCATE));
  }

  render() {
    const { dispatch, form, allocateDeviceResult } = this.props;
    const saveProps = {
      onOk: this.handleSubmit,
      onCancel: () => dispatch(push('/device')),
      okText: '保存',
      cancelText: '返回设备列表',
      confirmLoading: allocateDeviceResult.loading,
    };
    const agentOptions = {
      dataIndex: 'mchId',
      title: '代理商账户',
      changeOnSelect: true,
      childUseable: true,
      width: 250,
    };
    return (<div className="bind-agent-page">
      <div className="content-header">
        <h2>设备调拨</h2>
        <Button
          style={{ marginLeft: 30 }}
          className="g-btn-black"
          type="primary"
          onClick={() => this.toggleDownloadModal(true)}
        >
          调拨结果
        </Button>
      </div>
      <DeviceSelect multiple={!!true} type="allocate" ref={inst => { this.deviceSelect = inst; }} />
      <Card title="第二步：选择调拨至账号">
        <Form>
          <div style={{ padding: 20 }}>
            <FormItem label="代理商账户" {...formItemLayout} style={styles.card}>
              <AgentFilter
                column={agentOptions}
                form={form}
              />
            </FormItem>
          </div>
        </Form>
      </Card>
      <SaveBtn {...saveProps} />
      <DownloadModal taskType={DEVICE_ALLOCATE} title="调拨结果" />
    </div>);
  }
}

DeviceAllocate.propTypes = {
  form: PropTypes.object.isRequired,
  dispatch: PropTypes.func.isRequired,
  location: PropTypes.object.isRequired,
  allocateDeviceResult: PropTypes.object.isRequired,
};

const DeviceAllocate1 = (prop) => {
  const key = prop.location.query.key || 'deviceAllocate';
  return <DeviceAllocate {...prop} key={key} />;
};

const DeviceAllocateForm = Form.create()(DeviceAllocate1);

export default connect(({ global: { profile }, active: {
  allocateDeviceResult,
  editDeviceResult,
} }) => ({
  allocateDeviceResult,
  editDeviceResult,
  profile,
}))(DeviceAllocateForm);
