import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { message, Form, Alert, Input } from 'antd';
import { DeviceSelect } from '../../containers/DeviceSelect';
import { UntieConfirmModal } from './UntieConfirmModal';
import { TransferConfirmModal } from './TransferConfirmModal';
import { action as deviceActions } from './store';
import { action as globalActions } from '../../store/global';
import { SaveBtn } from '../../components/SaveBtn';
import { Card } from '../../components/Card';
import ErrorList from '../../containers/ErrorList';
import BizSelect from '../../containers/BizSelect';
import { push } from '../../store/router-helper';
import { getFailDevice } from '../../utils';

const FormItem = Form.Item;
const formItemLayout = {
  wrapperCol: {
    xs: {
      span: 20,
    },
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

class TransferDevicePage extends React.Component {
  constructor(props) {
    super(props);
    const category = props.location.pathname.indexOf('/device/untie') > -1 ? 'untie' : 'transfer';
    this.state = {
      category,
      targetBusiness: '',
      total: 0,
    };
  }
  componentDidMount() {
    this.props.dispatch(deviceActions.queryAgent({ mchId: this.props.profile.mchId }));
  }
  getParamsAndAction = (category, formData) => {
    let params = {};
    const actionList = {
      untie0: 'untieDeviceByBusiness',
      untie1: 'untieDeviceBySn',
      untie2: 'untieDeviceByRange',
      transfer0: 'transferDeviceByBusiness',
      transfer1: 'transferDeviceBySn',
      transfer2: 'transferDeviceByRange',
    };
    let { result, current, destMchId } = formData;
    const key = category + current;
    if (Array.isArray(destMchId)) {
      destMchId = destMchId[destMchId.length - 1];
    }
    switch (key) {
      case 'transfer0':
        params = { sourceMchId: result, destMchId };
        break;
      case 'transfer1':
        params = { deviceSnLst: result, destMchId };
        break;
      case 'transfer2':
        params = { deviceSn: result, destMchId };
        break;
      case 'untie0':
        params = { mchId: result };
        break;
      case 'untie1':
        params = { deviceSnLst: result };
        break;
      case 'untie2':
        params = { deviceSn: result };
        break;
      default:
        break;
    }
    return {
      action: actionList[key],
      params,
    };
  }
  onErrorListClose = () => {
    this.props.dispatch(push('/device'));
  }

  handleSubmit = () => {
    const { category } = this.state;
    const { dispatch, form, isTransferConfirm, isUntieConfirm } = this.props;
    const selectedValue = this.deviceSelect.getWrappedInstance().getSelectedDevice();
    if (selectedValue.result) {
      this.getChoosedDeviceNum(selectedValue);
      form.validateFieldsAndScroll((err, values) => {
        if (err) return;
        if (category === 'untie' && !isUntieConfirm) {
          dispatch(deviceActions.toggleUntieConfirmModal(true));
          return;
        } else if (category === 'transfer' && !isTransferConfirm) {
          dispatch(deviceActions.toggleTransferConfirmModal(true));
          return;
        }
        const { action, params } = this.getParamsAndAction(category, Object.assign({}, selectedValue, values));
        this.props.dispatch(deviceActions[action](params, (_, getState) => {
          const { editDeviceResult: { result } } = getState().device;
          if (Array.isArray(result) && result.length && getFailDevice(result).length) {
            dispatch(globalActions.toggleErrorList(true));
          } else if (result.count) {
            message.success(`${result.count}个设备${category === 'untie' ? '解绑' : '转移'}成功`);
            dispatch(push('/device'));
          } else {
            message.success(`设备${category === 'untie' ? '解绑' : '转移'}成功`);
            dispatch(push('/device'));
          }
        }));
      });
    }
  }
  getChoosedDeviceNum = (data) => {
    const { result, current } = data || {};
    let total = 0;
    if (current === '0') {
      const ids = this.props.queryDeviceByMchId.result || {};
      total = ids.total || 0;
    } else if (current === '1') {
      total = result.length;
    } else if (current === '2') {
      total = this.getRangeTotal(result);
    }
    this.setState({
      total,
    });
    return total;
  }

  getRangeTotal = (arr) => {
    if (!Array.isArray(arr)) throw new TypeError('range must be array ');
    let total = 0;
    arr.forEach(range => {
      let count = range[1].substr(-10, 10) - range[0].substr(-10, 10) + 1;
      total += count;
    });
    return total;
  }

  saveTargetBusiness = (value, elem) => {
    if (!value || !elem || !Array.isArray(elem)) return;
    const { label, value: mchId } = elem[0] || {};
    this.setState({
      targetBusiness: `${label} ${mchId}`,
    });
    return value;
  }

  onChangeAgent = (value, targetOption) => {
    if (!value || !targetOption) return;
    const { label, value: mchId } = targetOption[targetOption.length - 1];
    this.props.form.setFieldsValue({ destMchId: value });
    this.setState({
      targetBusiness: `${label} ${mchId}`,
    });
  }

  render() {
    const { dispatch, form: { getFieldDecorator }, editDeviceResult } = this.props;
    const { category } = this.state;
    const prefix = category === 'transfer' ? '转移' : '解绑';
    // let agentList = queryAgent.result || [];
    // agentList = agentList.filter((agent) => {
    //   return agent.mchType === 1;
    // });
    const saveProps = {
      onOk: this.handleSubmit,
      onCancel: () => dispatch(push('/device')),
      okText: '保存',
      cancelText: '返回设备列表',
      confirmLoading: editDeviceResult.loading,
    };
    const deviceResult = editDeviceResult.result || [];
    return (<div className="bind-agent-page">
      <div className="content-header">
        <h2>设备{prefix}</h2>
      </div>
      {category === 'untie' && <Alert style={{ maxWidth: 920, margin: '0 auto' }} type="info" showIcon message="解绑将恢复成未绑定未激活状态，设备将无法使用，请谨慎操作" />}
      <DeviceSelect multiple={!!true} type={category} ref={inst => { this.deviceSelect = inst; }} />
      {category === 'transfer' && <Card title="第二步：选择新商户">
        {/* <BindAgent form={form} category={category} queryAgent={queryAgent} /> */}
        <Form>
          <div style={{ padding: 20 }}>
            <FormItem label="转移设备至" {...formItemLayout} hasFeedback={false}>
              {
                getFieldDecorator('destMchId', {
                  rules: [
                    { required: true, message: '请选择新商户' },
                  ],
                })(<Input hidden />)
              }
              <BizSelect
                // form={this.props.form}
                onChange={this.onChangeAgent}
              />
              {/* {getFieldDecorator('destMchId', {
              })()
              //   <Select
              //     allowClear
              //     placeholder="请选择新商户"
              //     style={{ width: 320 }}
              //   >
              //     {mapArrayToOptions(agentList, 'mchId', agentAccountLabel)}
              //   </Select>
              // )
              */}
            </FormItem>
          </div>
        </Form>
      </Card>}
      {category === 'transfer' && <div style={{ maxWidth: 920, margin: '10px auto 0' }}>转移后，设备将使用新商户的默认计费规则，可使用“编辑计费规则”调整</div>}
      <SaveBtn {...saveProps} />
      <UntieConfirmModal onConfirm={this.handleSubmit} total={this.state.total} />
      <TransferConfirmModal onConfirm={this.handleSubmit} target={this.state.targetBusiness} total={this.state.total} />
      <ErrorList dataSource={deviceResult} onClose={this.onErrorListClose} />
    </div>);
  }
}

TransferDevicePage.propTypes = {
  form: PropTypes.object.isRequired,
  queryAgent: PropTypes.object.isRequired,
  dispatch: PropTypes.func.isRequired,
  queryDeviceByMchId: PropTypes.object.isRequired,
  location: PropTypes.object.isRequired,
  profile: PropTypes.object.isRequired,
  isTransferConfirm: PropTypes.bool.isRequired,
  isUntieConfirm: PropTypes.bool.isRequired,
  editDeviceResult: PropTypes.object.isRequired,
};
const TransferDevicePage1 = (prop) => <TransferDevicePage {...prop} key={prop.location.pathname} />;
const TransferDeviceForm = Form.create()(TransferDevicePage1);

export default connect(({
  global: { profile },
  device: {
    queryAgent,
    editDevice,
    editDeviceResult,
    isUntieConfirm,
    isTransferConfirm,
    queryDeviceByMchId,
  } }) => ({
  editDevice,
  editDeviceResult,
  queryAgent,
  profile,
  isUntieConfirm,
  isTransferConfirm,
  queryDeviceByMchId,
}))(TransferDeviceForm);
