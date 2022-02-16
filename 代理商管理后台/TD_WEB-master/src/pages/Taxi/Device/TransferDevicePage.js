import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { message, Form, Alert } from 'antd';
import { DeviceSelect } from '@/containers/DeviceSelect';
import { action as globalActions } from '@/store/global';
import { SaveBtn } from '@/components/SaveBtn';
import { Card } from '@/components/Card';
import ErrorList from '@/containers/ErrorList';
import { BindGroup } from '@/components/BindGroup';
import { push } from '@/store/router-helper';
import { getFailDevice } from '@/utils';
import { UntieConfirmModal } from './UntieConfirmModal';
import { TransferConfirmModal } from './TransferConfirmModal';
import { action as deviceActions } from './store';
import { NoGroupModal } from '../Group/NoGroupModal';

class TransferDevicePage extends React.Component {
  constructor(props) {
    super(props);
    const category = props.location.pathname.indexOf('/untie') > -1 ? 'untie' : 'transfer';
    this.state = {
      category,
      targetGroup: '',
      total: 0,
      groupId: '',
    };
  }
  componentDidMount() {
    // this.props.dispatch(deviceActions.queryAgent({ mchId: this.props.profile.mchId }));
    this.props.dispatch(deviceActions.queryGroup({ mchId: this.props.profile.mchId }));
  }
  getParamsAndAction = (category, formData) => {
    let params = {};
    const actionList = {
      untie1: 'untieDeviceBySn',
      untie2: 'untieDeviceByRange',
      transfer4: 'transferDeviceByGroup',
      transfer1: 'addTaxiDeviceBySn',
      transfer2: 'addTaxiDeviceByRange',
    };
    let { result, current } = formData;
    const { groupId } = this.state;
    const key = category + current;
    switch (key) {
      case 'transfer4':
        params = { srcGroupId: result, dstGroupId: groupId };
        break;
      case 'transfer1':
        params = { lstSn: result, groupId };
        break;
      case 'transfer2':
        params = { deviceSn: result, groupId };
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
    this.props.dispatch(push('/taxi/device'));
  }

  handleSubmit = () => {
    const { category, groupId } = this.state;
    const { dispatch, form, isTransferConfirm, isUntieConfirm } = this.props;
    const selectedValue = this.deviceSelect.getWrappedInstance().getSelectedDevice();
    if (selectedValue.result) {
      this.getChoosedDeviceNum(selectedValue);
      form.validateFieldsAndScroll((err, values) => {
        if (err) return;
        if (!groupId && category === 'transfer') {
          message.error('请选择新分组');
          return;
        }
        if (category === 'untie' && !isUntieConfirm) {
          dispatch(deviceActions.toggleUntieConfirmModal(true));
          return;
        } else if (category === 'transfer' && !isTransferConfirm) {
          dispatch(deviceActions.toggleTransferConfirmModal(true));
          return;
        }
        const { action, params } = this.getParamsAndAction(category, Object.assign({}, selectedValue, values));
        this.props.dispatch(deviceActions[action](params, (_, getState) => {
          const { editDeviceResult: { result } } = getState().taxiDevice;
          if (selectedValue.current === '4') {
            message.success(`${result[0].deviceSn || 0}个设备${category === 'untie' ? '解绑' : '转移'}成功`);
            this.onErrorListClose();
            return;
          }
          if (Array.isArray(result) && result.length && getFailDevice(result).length) {
            dispatch(globalActions.toggleErrorList(true));
          } else if (result.length) {
            message.success(`${result.length}个设备${category === 'untie' ? '解绑' : '转移'}成功`);
            this.onErrorListClose();
          } else {
            message.success(`设备${category === 'untie' ? '解绑' : '转移'}成功`);
            this.onErrorListClose();
          }
        }));
      });
    }
  }
  getChoosedDeviceNum = (data) => {
    const { result, current } = data || {};
    let total = 0;
    if (current === '0' || current === '4') {
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

  saveTargetGroup = (value, elem) => {
    if (!value || !elem) return;
    const { props: { children } } = elem || {};
    this.setState({
      targetGroup: `${children} ${value}`,
    });
  }

  handleSelectNewGroup = (groupId, elem) => {
    this.setState({
      groupId,
    });
    this.saveTargetGroup(groupId, elem);
  }

  render() {
    const { dispatch, form, editDeviceResult, groupList } = this.props;
    const { category } = this.state;
    const prefix = category === 'transfer' ? '更换分组' : '解绑';
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
    const diviceSelectCategory = category === 'untie' ? 'taxiUntie' : 'taxiTransfer';
    return (<div className="bind-agent-page">
      <div className="content-header">
        <h2>设备{prefix}</h2>
      </div>
      {category === 'untie' && (<Alert
        style={{ maxWidth: 920, margin: '0 auto' }}
        type="info"
        showIcon
        message=" 1，仅当出租车司机将设备退货时，才需将设备解绑；2，解绑将恢复成未激活状态，设备将无法使用，请谨慎操作"
      />)}
      {category === 'transfer' && (<Alert
        style={{ maxWidth: 920, margin: '0 auto' }}
        type="info"
        showIcon
        message=" 将设备更换至新分组后，设备价格将使用新分组的定价和分润比例；"
      />)}
      <DeviceSelect multiple={!!true} form={form} type={diviceSelectCategory} groupList={groupList} ref={inst => { this.deviceSelect = inst; }} />
      {category === 'transfer' && <Card title="第二步：选择新分组">
        <BindGroup groupList={groupList} onChange={this.handleSelectNewGroup} />
      </Card>}
      <SaveBtn {...saveProps} />
      <UntieConfirmModal onConfirm={this.handleSubmit} total={this.state.total} />
      <TransferConfirmModal onConfirm={this.handleSubmit} target={this.state.targetGroup} total={this.state.total} />
      <ErrorList dataSource={deviceResult} onClose={this.onErrorListClose} />
      <NoGroupModal />
    </div>);
  }
}

TransferDevicePage.propTypes = {
  form: PropTypes.object.isRequired,
  dispatch: PropTypes.func.isRequired,
  location: PropTypes.shape({
    pathname: PropTypes.string.isRequired,
  }).isRequired,
  profile: PropTypes.shape({
    mchId: PropTypes.string.isRequired,
  }).isRequired,
  isTransferConfirm: PropTypes.bool.isRequired,
  isUntieConfirm: PropTypes.bool.isRequired,
  editDeviceResult: PropTypes.object.isRequired,
  groupList: PropTypes.object.isRequired,
  queryDeviceByMchId: PropTypes.object.isRequired,
};

const TransferDevicePage1 = (prop) => <TransferDevicePage {...prop} key={prop.location.pathname} />;
const TransferDeviceForm = Form.create()(TransferDevicePage1);

export default connect(({ global: { profile },
  taxiDevice: { groupList, editDevice, editDeviceResult, isUntieConfirm, isTransferConfirm },
  device: { queryDeviceByMchId },
}) => ({
  editDevice,
  editDeviceResult,
  profile,
  isUntieConfirm,
  isTransferConfirm,
  groupList,
  queryDeviceByMchId,
}))(TransferDeviceForm);
