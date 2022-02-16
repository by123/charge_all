import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { message, Form } from 'antd';
import { DeviceSelect } from '@/containers/DeviceSelect';
import { BindGroup } from '@/components/BindGroup';
import { SaveBtn } from '@/components/SaveBtn';
import { Card } from '@/components/Card';
import { push } from '@/store/router-helper';
import ErrorList from '@/containers/ErrorList';
import { getFailDevice } from '@/utils';
import { action as globalActions } from '@/store/global';
import { action as deviceActions } from './store';
import { NoGroupModal } from '../Group/NoGroupModal';

class BindAgentPage extends React.Component {
  componentDidMount() {
    this.props.dispatch(deviceActions.queryGroup({ mchId: this.props.profile.mchId }));
  }
  handleSubmit = () => {
    const { dispatch, form } = this.props;
    const ids = this.deviceSelect.getWrappedInstance().getSelectedDevice();
    if (ids) {
      form.validateFieldsAndScroll((err, values) => {
        if (err) return;
        let groupId = values.groupId;
        const { current } = ids;
        let snKey = 'lstSn';
        let actionName = 'addTaxiDeviceBySn';

        if (current === '2') {
          snKey = 'deviceSn';
          actionName = 'addTaxiDeviceByRange';
        }
        this.props.dispatch(deviceActions[actionName]({
          [snKey]: ids.result,
          groupId,
        }, (_, getState) => {
          const { editDeviceResult: { result } } = getState().taxiDevice;
          if (Array.isArray(result) && result.length && getFailDevice(result).length) {
            dispatch(globalActions.toggleErrorList(true));
          } else if (Array.isArray(result) && result.length) {
            message.success(`${result.length || ''}${result.length ? '个' : ''}设备添加成功`);
            setTimeout(() => {
              dispatch(deviceActions.cleanErrorList());
              dispatch(push('/taxi/device'));
            }, 100);
          }
        }));
      });
    }
  }

  onErrorListClose = () => {
    this.props.dispatch(push('/taxi/device'));
  }

  render() {
    const { dispatch, editDeviceResult, form, groupList } = this.props;
    const title = '添加设备至分组';
    const step2Title = '选择分组';
    const saveProps = {
      onOk: this.handleSubmit,
      onCancel: () => dispatch(push('/taxi/device')),
      okText: '保存',
      cancelText: '返回设备列表',
      confirmLoading: editDeviceResult.loading,
    };
    const deviceResult = editDeviceResult.result || [];
    return (<div className="bind-agent-page">
      <div className="content-header">
        <h2>{title}</h2>
      </div>
      <DeviceSelect type="taxiAdd" ref={inst => { this.deviceSelect = inst; }} />
      <Card title={`第二步：${step2Title}`}>
        <BindGroup form={form} groupList={groupList} />
      </Card>
      <SaveBtn {...saveProps} />
      {/* <ResultModal type={EDIT} dispatch={dispatch} visible={deviceResultVisible} result={addToGroupResult.result} /> */}
      <ErrorList dataSource={deviceResult} onClose={this.onErrorListClose} />
      <NoGroupModal />
    </div>);
  }
}

BindAgentPage.propTypes = {
  form: PropTypes.object.isRequired,
  groupList: PropTypes.object.isRequired,
  dispatch: PropTypes.func.isRequired,
  profile: PropTypes.shape({
    mchId: PropTypes.string.isRequired,
  }).isRequired,
  editDeviceResult: PropTypes.object.isRequired,
  location: PropTypes.shape({
    pathname: PropTypes.string.isRequired,
  }).isRequired,
};

const BindAgentPage1 = (prop) => <BindAgentPage {...prop} key={prop.location.pathname} />;
const BindAgentForm = Form.create()(BindAgentPage1);

export default connect(({ global: { profile }, taxiDevice: { groupList, editDeviceResult, deviceResultVisible } }) => ({
  editDeviceResult,
  deviceResultVisible,
  groupList,
  profile,
}))(BindAgentForm);
