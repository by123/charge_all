import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { message, Form, Button } from 'antd';
import { DeviceSelect } from '../../containers/DeviceSelect';
import { action as deviceActions } from './store';
import { action as downloadAction } from '../DownloadModal/store';
import { DownloadModal } from '../DownloadModal';
import { SaveBtn } from '../../components/SaveBtn';
import { push, replace } from '../../store/router-helper';
import { DEVICE_RECALL } from '../../utils/constants';

class DeviceRecall extends React.Component {

  getParamsAndAction = (formData) => {
    let params = {};
    const actionList = {
      2: 'recallDeviceBySection',
      1: 'recallDeviceBySn',
      5: 'recallDeviceByFile',
    };
    let { result, current } = formData;
    const key = current;
    let fileData = null;
    switch (key) {
      case '2':
        params = { snList: result };
        break;
      case '1':
        params = { snList: result };
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
        const { action, params } = this.getParamsAndAction(Object.assign({}, selectedValue, values));
        this.props.dispatch(deviceActions[action](params, (_, getState) => {
          const { recallDeviceResult: { result } } = getState().active;
          message.success(result ? `${result}个设备返厂提交成功` : '设备返厂提交成功');
          dispatch(replace(`/initialize/deviceRecall?key=${Math.random()}`));
          this.toggleDownloadModal(true);
        }));
      });
    }
  }

  toggleDownloadModal = (visible) => {
    this.props.dispatch(downloadAction.toggleDownloadModal(visible, DEVICE_RECALL));
  }

  render() {
    const { dispatch, recallDeviceResult } = this.props;
    const saveProps = {
      onOk: this.handleSubmit,
      onCancel: () => dispatch(push('/device')),
      okText: '保存',
      cancelText: '返回设备列表',
      confirmLoading: recallDeviceResult.loading,
    };

    return (<div className="bind-agent-page">
      <div className="content-header">
        <h2>设备返厂管理</h2>
        <Button
          style={{ marginLeft: 30 }}
          className="g-btn-black"
          type="primary"
          onClick={() => this.toggleDownloadModal(true)}
        >
          返厂结果
        </Button>
      </div>
      <DeviceSelect
        multiple={!!true}
        type="recall"
        ref={inst => { this.deviceSelect = inst; }}
      />
      <SaveBtn {...saveProps} />
      <DownloadModal taskType={DEVICE_RECALL} title="返厂结果" />
    </div>);
  }
}

DeviceRecall.propTypes = {
  form: PropTypes.object.isRequired,
  dispatch: PropTypes.func.isRequired,
  recallDeviceResult: PropTypes.object.isRequired,
};

const DeviceRecall1 = (prop) => {
  const key = prop.location.query.key || 'deviceRecall';
  return <DeviceRecall {...prop} key={key} />;
};
const DeviceRecallForm = Form.create()(DeviceRecall1);

export default connect(({ active: {
  recallDeviceResult,
} }) => ({
  recallDeviceResult,
}))(DeviceRecallForm);
