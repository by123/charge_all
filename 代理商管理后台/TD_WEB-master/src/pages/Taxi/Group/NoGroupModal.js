/**
 * 添加编辑代理商/商户
 */
import React from 'react';
import PropTypes from 'prop-types';
import { Modal, Button } from 'antd';
import { connect } from 'react-redux';
import { push } from '@/store/router-helper';
import { action as taxiGroupActions } from './store';
import { action as taxiDeviceActions } from '../Device/store';

import './style.less';

class NoGroupModal extends React.PureComponent {
  componentDidMount() {
    const { profile, dispatch, isHasGroupChecked, hasGroup } = this.props;
    const isPlatform = profile.mchType === 2 && profile.roleType <= 1;
    if (isPlatform) return;
    if (!isHasGroupChecked) {
      dispatch(taxiDeviceActions.queryGroup({ mchId: profile.mchId }, (_, getState) => {
        const { taxiDevice: { hasGroup: _hasGroup, isHasGroupChecked: _isHasGroupChecked } } = getState();
        if (!_hasGroup && _isHasGroupChecked) {
          dispatch(taxiGroupActions.toggleNoGroupModal(true));
        }
      }));
    }
    if (isHasGroupChecked && !hasGroup) {
      dispatch(taxiGroupActions.toggleNoGroupModal(true));
    }
  }

  handleOk = () => {
    const { dispatch } = this.props;
    dispatch(push('/taxi/group/groupManage'));
    dispatch(taxiGroupActions.toggleNoGroupModal(false));
    dispatch(taxiGroupActions.showAddGroup(true));
  };

  closeModal = () => {
    this.props.dispatch(taxiGroupActions.toggleNoGroupModal(false));
  }

  render() {
    const {
      visible,
    } = this.props;
    const modalOpts = {
      title: '开启出租车业务',
      visible,
      closable: false,
      className: 'group-text-modal',
      width: 700,
      destroyOnClose: true,
      maskClosable: false,
      onClose: this.closeModal,
      footer: null,
      zIndex: 999,
    };

    return (
      <div>
        <Modal {...modalOpts}>
          <div className="text-list">
            <div className="text-item">
              <div>1、什么是出租车业务</div>
              <div>是指在出租车铺设充电设备，供乘客使用。</div>
            </div>
            <div className="text-item">
              <div>2、出租车业务的开展流程</div>
              <div>第一步：创建分组</div>
              <div>可创建多个分组，不同的组设置不同的充电计费规则、司机分润比例等</div>
            </div>
            <div className="text-item">
              <div>第二步：添加设备至分组</div>
              <div>设备最终使用时，将按照所在分组的设备计费规则、分润比例等进行计费、分润</div>
            </div>
            <div className="text-item">
              <div>第三步：出售设备给司机</div>
              <div>司机通过扫描设备二维码，注册账户并激活设备。激活完成后，乘客就可以使用了。</div>
            </div>
          </div>
          <div className="text-btn">
            <Button type="primary" onClick={this.handleOk}>创建分组</Button>
          </div>
        </Modal>
      </div>
    );
  }
}

NoGroupModal.propTypes = {
  dispatch: PropTypes.func.isRequired,
  visible: PropTypes.bool.isRequired,
  profile: PropTypes.object.isRequired,
  groupList: PropTypes.object.isRequired,
  isHasGroupChecked: PropTypes.bool.isRequired,
  hasGroup: PropTypes.bool,
};

NoGroupModal.defaultProps = {
  hasGroup: true,
};

const Container = connect(({
  taxiGroup: {
    noGroupModalVisible,
  },
  taxiDevice: {
    groupList,
    isHasGroupChecked,
    hasGroup,
  },
  global: {
    profile,
  },
}) => ({
  visible: noGroupModalVisible,
  profile,
  groupList,
  isHasGroupChecked,
  hasGroup,
}))(NoGroupModal);

export { Container as NoGroupModal };
