import React from 'react';
import PropTypes from 'prop-types';
import { Modal, Alert } from 'antd';
import { action as deviceActions } from '../../pages/Device/store';
import { ADD } from '../../utils/constants';

export class ResultModal extends React.PureComponent {
  handleCancel = () => {
    this.props.dispatch(deviceActions.toggleDeviceResultModal(false));
  }
  isEmpty = (result) => {
    let isEmpty = true;
    for (let key in result) {
      if (result[key] && result[key].length) isEmpty = false;
    }
    return isEmpty;
  }
  render() {
    const {
      visible,
      result,
      type,
    } = this.props;
    const {
      activeSn,
      notExistSn,
      otherMchSn,
      noFirstMch,
      success,
      unknownSn,
      taxiSn = [],
    } = result;
    const isEmpty = this.isEmpty(result);
    const modalOpts = {
      title: '提示',
      visible: visible && !isEmpty,
      footer: null,
      onCancel: this.handleCancel,
      destroyOnClose: true,
      maskClosable: false,
    };
    const typeText = type === ADD ? '新增' : '编辑';
    const renderReason = (errIds, reason) => {
      if (errIds.length === 0) return null;
      return (<div>
        <Alert showIcon type="error" message={`以下${errIds.length}个设备提交失败，原因：${reason}`} />
        <div className="g-selected-area">{errIds.join(',')}</div>
      </div>);
    };
    return (
      <div>
        <Modal {...modalOpts}>
          {success.length > 0 && <Alert showIcon type="success" message={`已成功${typeText}${success.length}个设备`} />}
          {renderReason(activeSn, '设备已激活，无法进行重新绑定')}
          {renderReason(otherMchSn, '仅设备上级才可操作，本账号无权限编辑')}
          {renderReason(noFirstMch, '此设备不属于本账号省级代理商')}
          {renderReason(notExistSn, '设备不存在，请重新输入')}
          {renderReason(unknownSn, '未知原因')}
          {renderReason(taxiSn, '出租车设备不能绑定到普通商户')}
        </Modal>
      </div>
    );
  }
}

ResultModal.propTypes = {
  dispatch: PropTypes.func.isRequired,
  visible: PropTypes.bool.isRequired,
  result: PropTypes.object,
  type: PropTypes.string.isRequired,
};

ResultModal.defaultProps = {
  result: {
    activeSn: [],
    notExistSn: [],
    otherMchSn: [],
    success: [],
    unknownSn: [],
    noFirstMch: [],
  },
};
