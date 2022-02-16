/**
 * 批量绑定商户或者代理商弹窗
 */

import React from 'react';
import PropTypes from 'prop-types';
import { Modal, message, Form } from 'antd';
import { connect } from 'react-redux';
import { getFailDevice } from '@/utils';
import { Card } from '@/components/Card';
import { action as globalActions } from '@/store/global';
import { BindGroup } from '@/components/BindGroup';
import { action as deviceActions } from './store';

class BindAgentModal extends React.PureComponent {
  state = {
    groupId: '',
  }
  handleSubmit = () => {
    const { ids, dispatch, form } = this.props;
    const { groupId } = this.state;

    form.validateFieldsAndScroll((err) => {
      if (err) return;
      dispatch(deviceActions.addTaxiDeviceBySn({
        lstSn: ids,
        groupId,
      }, (_, getState) => {
        const { editDeviceResult: { result } } = getState().taxiDevice;

        if (Array.isArray(result) && result.length && getFailDevice(result).length) {
          dispatch(globalActions.toggleErrorList(true));
        } else {
          message.success(`${result.count || ''}${result.count ? '个' : ''}设备添加成功`);
          // 只要有一个提交成功，关闭表单窗口，刷新列表
          dispatch(deviceActions.toggleBindAgentModal(false));
          dispatch(deviceActions.cleanErrorList());
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
      groupList,
    } = this.props;
    const modalOpts = {
      title: '批量添加设备到分组',
      visible,
      width: 630,
      onOk: this.handleSubmit,
      onCancel: () => dispatch(deviceActions.toggleBindAgentModal(false)),
      destroyOnClose: true,
      confirmLoading: groupList.loading,
      cancelButtonProps: {
        disabled: groupList.loading,
      },
      maskClosable: false,
    };
    return (
      <div>
        <Modal {...modalOpts}>
          <p>已选择设备总数：{ids.length}个</p>
          <div className="g-selected-area">{ids.join(',')}</div>
          <Card title="添加设备至分组">
            <BindGroup groupList={groupList} onChange={this.onChange} />
          </Card>
        </Modal>
      </div>
    );
  }
}

BindAgentModal.propTypes = {
  form: PropTypes.object.isRequired,
  groupList: PropTypes.object.isRequired,
  dispatch: PropTypes.func.isRequired,
  visible: PropTypes.bool.isRequired,
  ids: PropTypes.array,
  editDeviceResult: PropTypes.object,
};

BindAgentModal.defaultProps = {
  ids: [],
  editDeviceResult: {},
};

const BindAgentForm = Form.create()(BindAgentModal);
const Container = connect(({ taxiDevice: { groupList, editDeviceResult, editDevice, bindAgentVisible, selectedKeys } }) => ({
  visible: bindAgentVisible,
  ids: selectedKeys,
  editDevice,
  groupList,
  editDeviceResult,
}))(BindAgentForm);

export { Container as BindAgentModal };
