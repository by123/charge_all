import React from 'react';
import { connect } from 'react-redux';
import { message, Form } from 'antd';
import PropTypes from 'prop-types';
import { BindBilling } from '../../components/BindBilling/BindBilling';
import { DeviceSelect } from '../../containers/DeviceSelect';
import { SaveBtn } from '../../components/SaveBtn';
import { ResultModal } from '../../components/Device/ResultModal';
import { Card } from '../../components/Card';
import { push } from '../../store/router-helper';
import { action as deviceActions } from './store';
import { isEditDeviceSuccess, processBillingRules, processBillingRulesWithPre, formatDecimal } from '../../utils';
import { EDIT } from '../../utils/constants';

class EditBillingPage extends React.Component {
  componentDidMount() {
    const { profile: { mchId }, dispatch } = this.props;
    dispatch(deviceActions.queryAgent({ mchId, qryType: 1 }));
  }

  componentWillUnmount() {
    this.props.dispatch(deviceActions.removeQueryAgent());
  }

  handleSubmit = () => {
    const ids = this.deviceSelect.getWrappedInstance().selectDevice();
    const isEditAll = this.deviceSelect.getWrappedInstance().checkIsEditAll();
    const { dispatch } = this.props;
    if (!ids) return;
    this.props.form.validateFieldsAndScroll((err, values) => {
      if (!err) {
        const serviceType = values.serviceType;
        if (serviceType === '2' || serviceType === 2) {
          values.service.prepaid = formatDecimal(values.service.prepaid, 0);
          values.service.maxMoney = formatDecimal(values.service.maxMoney, 0);
          values.service.minMoney = formatDecimal(values.service.minMoney, 0);
          values.service.price = formatDecimal(values.service.price, 0);
          values.service.minMinutes = formatDecimal(values.service.minMinutes, 0);
          values.service.stepMinutes = formatDecimal(values.service.stepMinutes, 0);
        }
        console.log(values);
        console.log('触发1');
        console.log(serviceType);
        const service = (serviceType === '1' || serviceType === 1) ? processBillingRules(values.service) : processBillingRulesWithPre(values.service);
        const pledge = values.pledge.toString();
        dispatch(deviceActions.editDevice({
          deviceSN: ids,
          pledge,
          service,
          serviceType,
          changeDefaultPriceRule: isEditAll ? 0 : 1,
        }, (_, getState) => {
          const { editDevice } = getState().device;
          const { success } = editDevice.result;
          if (isEditDeviceSuccess(editDevice.result)) {
            message.success('批量编辑计费规则成功');
          } else {
            dispatch(deviceActions.toggleDeviceResultModal(true)); // 显示添加设备结果
          }
          if (success.length > 0) {
            // 只要有一个提交成功，跳转列表
            dispatch(push('/device'));
          }
        }));
      }
    });
  }

  render() {
    const { dispatch, editDevice, form, deviceResultVisible } = this.props;
    const saveProps = {
      onOk: this.handleSubmit,
      onCancel: () => dispatch(push('/device')),
      okText: '保存',
      cancelText: '返回设备列表',
      confirmLoading: editDevice.loading,
    };
    return (<div className="edit-billing-page">
      <div className="content-header">
        <h2>设置计费规则</h2>
      </div>
      <DeviceSelect type="billing" multiple={!!true} ref={inst => { this.deviceSelect = inst; }} />
      <Card title="第二步：编辑计费规则">
        <BindBilling form={form} />
      </Card>
      <SaveBtn {...saveProps} />
      <ResultModal type={EDIT} dispatch={dispatch} visible={deviceResultVisible} result={editDevice.result} />
    </div>);
  }
}

EditBillingPage.propTypes = {
  profile: PropTypes.object.isRequired,
  dispatch: PropTypes.func.isRequired,
  form: PropTypes.object.isRequired,
  editDevice: PropTypes.object.isRequired,
  deviceResultVisible: PropTypes.bool.isRequired,
};

const BindBillingForm = Form.create()(EditBillingPage);

export default connect(({ global: { profile }, device: { editDevice, deviceResultVisible } }) => ({
  editDevice,
  deviceResultVisible,
  profile,
}))(BindBillingForm);
