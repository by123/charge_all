import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { message, Form } from 'antd';
import { DeviceSelect } from '../../containers/DeviceSelect';
import { action as deviceActions } from './store';
import { BindAgent } from '../../components/BindAgent/BindAgent';
import { SaveBtn } from '../../components/SaveBtn';
import { Card } from '../../components/Card';
import { ResultModal } from '../../components/Device/ResultModal';
import { push } from '../../store/router-helper';
import { isEditDeviceSuccess } from '../../utils';
import { EDIT } from '../../utils/constants';

class BindAgentPage extends React.Component {
  constructor(props) {
    super(props);
    const category = props.location.pathname.indexOf('/device/bindBusiness') > -1 ? 'business' : 'agent';
    this.state = {
      category,
    };
  }
  componentDidMount() {
    this.props.dispatch(deviceActions.queryAgent({ mchId: this.props.profile.mchId }));
  }
  handleSubmit = () => {
    const { dispatch, form } = this.props;
    const { category } = this.state;
    const ids = this.deviceSelect.getWrappedInstance().selectDevice();
    if (ids) {
      form.validateFieldsAndScroll((err, values) => {
        if (err) return;
        let mchId = category === 'agent' ? values.agent : values.biz;
        // 多级选择器选中的值为数组，需要格式化
        mchId = this.formatMchId(mchId);
        this.props.dispatch(deviceActions.editDevice({
          deviceSN: ids,
          mchId,
        }, (_, getState) => {
          const { editDevice } = getState().device;
          const { success } = editDevice.result;
          if (isEditDeviceSuccess(editDevice.result)) {
            message.success(`批量绑定${category === 'agent' ? '代理商' : '商户'}成功`);
          } else {
            dispatch(deviceActions.toggleDeviceResultModal(true)); // 显示添加设备结果
          }
          if (success.length > 0) {
            // 只要有一个提交成功，跳转列表
            dispatch(push('/device'));
          }
        }));
      });
    }
  }

  // 格式化多级选择器选中的值
  formatMchId = (mchId) => {
    if (Array.isArray(mchId)) {
      mchId = mchId[mchId.length - 1];
    }
    return mchId;
  }

  render() {
    const { dispatch, editDevice, form, deviceResultVisible, queryAgent, childUseable } = this.props;
    const { category } = this.state;
    const title = category === 'agent' ? '绑定代理商' : '设备激活至商户';
    const step2Title = category === 'agent' ? '代理商设备绑定' : '商户设备激活';
    const saveProps = {
      onOk: this.handleSubmit,
      onCancel: () => dispatch(push('/device')),
      okText: '保存',
      cancelText: '返回设备列表',
      confirmLoading: editDevice.loading,
    };
    return (<div className="bind-agent-page">
      <div className="content-header">
        <h2>{title}</h2>
      </div>
      <DeviceSelect type="agent" ref={inst => { this.deviceSelect = inst; }} />
      <Card title={`第二步：${step2Title}`}>
        <BindAgent form={form} category={category} queryAgent={queryAgent} childUseable={childUseable} multiple={!!true} />
      </Card>
      <SaveBtn {...saveProps} />
      <ResultModal type={EDIT} dispatch={dispatch} visible={deviceResultVisible} result={editDevice.result} />
    </div>);
  }
}

BindAgentPage.propTypes = {
  form: PropTypes.object.isRequired,
  queryAgent: PropTypes.object.isRequired,
  dispatch: PropTypes.func.isRequired,

  profile: PropTypes.object.isRequired,
  editDevice: PropTypes.object.isRequired,
  deviceResultVisible: PropTypes.bool.isRequired,
  childUseable: PropTypes.bool.isRequired,
  location: PropTypes.object.isRequired,
};

const BindAgentPage1 = (prop) => <BindAgentPage {...prop} key={prop.location.pathname} />;
const BindAgentForm = Form.create()(BindAgentPage1);

export default connect(({ global: { profile, authCode }, device: { queryAgent, editDevice, deviceResultVisible } }) => ({
  editDevice,
  deviceResultVisible,
  queryAgent,
  profile,
  authCode,
  childUseable: authCode[2] === '1',
}))(BindAgentForm);
