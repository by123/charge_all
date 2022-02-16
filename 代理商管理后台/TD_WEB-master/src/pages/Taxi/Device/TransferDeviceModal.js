import React from 'react';
import PropTypes from 'prop-types';
import { Modal, message, Form, Card } from 'antd';
import { connect } from 'react-redux';
import { action as globalActions } from '@/store/global';
import { getFailDevice } from '@/utils';
import { BindGroup } from '@/components/BindGroup';
import { action as deviceActions } from './store';


class TransferDeviceModal extends React.PureComponent {
  state = {
    groupId: '',
  }
  handleSubmit = () => {
    const { ids, dispatch, form } = this.props;
    const { groupId } = this.state;
    if (!groupId) {
      message('请选择新分组');
      return;
    }
    form.validateFieldsAndScroll((err) => {
      if (err) return;
      dispatch(deviceActions.addTaxiDeviceBySn({
        lstSn: ids,
        groupId,
      }, (_, getState) => {
        const { editDeviceResult: { result } } = getState().device;
        if (Array.isArray(result) && result.length && getFailDevice(result).length) {
          dispatch(globalActions.toggleErrorList(true));
        } else {
          message.success('设备更换分组成功');
          dispatch(deviceActions.toggleTransferDeviceModal(false));
          dispatch(deviceActions.refreshList());
        }
      }));
    });
  }
  onChange = (groupId) => {
    this.setState({
      groupId,
    });
  }
  render() {
    const {
      visible,
      dispatch,
      ids,
      editDeviceResult,
      groupList,
    } = this.props;
    const modalOpts = {
      title: '批量更换分组',
      visible,
      width: 630,
      okText: '更换分组',
      onOk: this.handleSubmit,
      onCancel: () => dispatch(deviceActions.toggleTransferDeviceModal(false)),
      destroyOnClose: true,
      confirmLoading: editDeviceResult.loading,
      cancelButtonProps: {
        disabled: editDeviceResult.loading,
      },
      maskClosable: false,
    };
    return (
      <div>
        <Modal {...modalOpts}>
          <p>已选择{ids.length}个设备</p>
          <div className="g-selected-area">{ids.join(',')}</div>
          <Card title="选择新分组">
            <BindGroup groupList={groupList} onChange={this.onChange} />
          </Card>
        </Modal>
      </div>
    );
  }
}

TransferDeviceModal.propTypes = {
  dispatch: PropTypes.func.isRequired,
  form: PropTypes.object.isRequired,
  editDeviceResult: PropTypes.object.isRequired,
  visible: PropTypes.bool.isRequired,
  ids: PropTypes.array,
  groupList: PropTypes.object.isRequired,
};

TransferDeviceModal.defaultProps = {
  ids: [],
};

const TransferDeviceForm = Form.create()(TransferDeviceModal);
const Container = connect(({ taxiDevice: { editDeviceResult, groupList, selectedKeys, transferDeviceVisible } }) => ({
  visible: transferDeviceVisible,
  ids: selectedKeys,
  editDeviceResult,
  groupList,
}))(TransferDeviceForm);

export { Container as TransferDeviceModal };
