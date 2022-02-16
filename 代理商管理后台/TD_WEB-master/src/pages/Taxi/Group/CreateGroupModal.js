/**
 * 添加编辑代理商/商户
 */
import React from 'react';
import PropTypes from 'prop-types';
import { Modal, Spin } from 'antd';
import { connect } from 'react-redux';
import { push } from '@/store/router-helper';
import { ADD } from '@/utils/constants';
import { processBillingRules } from '@/utils';
import { action as taxiActions } from './store';
import { GroupForm } from './GroupForm';

import './style.less';

function getAddress(fields, dataIndex, dataPrefix) {
  const data = fields[dataIndex];
  if (data && data.length > 0) {
    fields[`${dataPrefix}Province`] = data[0];
    fields[`${dataPrefix}City`] = data[1];
    fields[`${dataPrefix}Area`] = data[2];
  } else {
    fields[`${dataPrefix}Province`] = '';
    fields[`${dataPrefix}City`] = '';
    fields[`${dataPrefix}Area`] = '';
  }
  delete fields[dataIndex];
}

class CreateGroupModal extends React.PureComponent {
  state = {
    hasStores: false,
    groupName: '分组',
  }

  handleOk = () => {
    const { form } = this.agentForm.props;
    form.validateFieldsAndScroll((errors, fields) => {
      if (errors) {
        return;
      }
      const { dispatch, taxiConfig: { pledge, time }, editType } = this.props;
      getAddress(fields, 'afterAddress', 'aftersale');
      getAddress(fields, 'preAddress', 'presale');
      fields.salesId = fields.salesId || '';
      fields.service = processBillingRules([{ price: fields.price, time }]);
      fields.pledge = pledge;
      fields.deposit = fields.deposit ? fields.deposit * 100 : 0;
      this.setState({
        groupName: fields.groupName,
      });
      dispatch(taxiActions.saveGroupInfo(fields, editType));
    });
  };

  handleCancel = () => {
    this.props.dispatch(taxiActions.toggleAddGroupModal(false));
    this.setState({
      groupName: '分组',
    });
  }

  onTypeChange = (agentType) => {
    this.props.dispatch(taxiActions.toggleAddGroupModal(true, agentType, this.props.editType));
  }

  onChainChange = (mchId) => {
    this.setState({
      selectedChainId: mchId,
    });
    this.props.dispatch(taxiActions.queryParentProfit(mchId));
  }

  closeModal = () => {
    this.props.dispatch(taxiActions.closeModalAndRefresh());
    this.setState({
      groupName: '分组',
    });
  }

  onOk = () => {
    this.closeModal();
    this.props.dispatch(push('/taxi/device/addToGroup'));
  }

  render() {
    const {
      visible,
      accountVisible,
      editType,
      detailData,
      addGroup = {},
      updateAgent,
      selfInfo,
      allUsers,
      profile,
      taxiConfig,
    } = this.props;
    let loading = false;
    if (detailData.result) {
      loading = detailData.loading;
    }

    const modalOpts = {
      title: `${editType === ADD ? '添加' : '编辑'}分组`,
      visible,
      className: 'group-modal',
      width: 800,
      style: {
        top: 20,
      },
      onOk: () => this.handleOk(),
      onCancel: this.handleCancel,
      destroyOnClose: true,
      confirmLoading: addGroup.loading || updateAgent.loading,
      cancelButtonProps: {
        disabled: addGroup.loading || updateAgent.loading,
      },
      maskClosable: false,
    };
    const accountModalOpts = {
      title: '新建分组成功',
      visible: accountVisible,
      // visible: true,
      maskClosable: false,
      okText: '添加设备',
      cancelText: '暂不绑定',
      closable: false,
      onCancel: this.closeModal,
      onOk: this.onOk,
    };
    let userList = allUsers.result || [];
    const { roleType } = profile;
    if (roleType > 1) { // 非管理员,管理业务员只能选自己
      userList = [{
        userId: profile.userId,
        roleType,
        name: profile.name,
      }];
    }
    const subProfit = selfInfo.totalPercent;
    return (
      <div>
        <Modal {...modalOpts}>
          <Spin spinning={loading}>
            <GroupForm
              groupData={detailData.result}
              taxiConfig={taxiConfig}
              totalProfit={subProfit}
              editType={editType}
              userList={userList}
              wrappedComponentRef={inst => { this.agentForm = inst; }}
            />
          </Spin>
        </Modal>
        <Modal {...accountModalOpts}>
          <div>
            <div>{this.state.groupName} 创建成功，需要将出租车专用设备添加至分组，才可以将设备分发至出租车司机。</div>
          </div>
        </Modal>
      </div>
    );
  }
}

CreateGroupModal.propTypes = {
  dispatch: PropTypes.func.isRequired,
  visible: PropTypes.bool.isRequired,
  accountVisible: PropTypes.bool.isRequired,
  addGroup: PropTypes.object.isRequired,
  updateAgent: PropTypes.object.isRequired,
  agentType: PropTypes.string,
  editType: PropTypes.string,
  detailData: PropTypes.object,
  addChainStoresResult: PropTypes.object,
  addedStoresList: PropTypes.array,
  parentAgentData: PropTypes.object,
  taxiConfig: PropTypes.object.isRequired,
  selfInfo: PropTypes.object.isRequired,
  allUsers: PropTypes.object.isRequired,
  profile: PropTypes.object.isRequired,
};

CreateGroupModal.defaultProps = {
  agentType: undefined,
  editType: undefined,
  detailData: undefined,
  addChainStoresResult: {},
  addedStoresList: [],
  parentAgentData: null,
};

const Container = connect(({
  taxiGroup: {
    editModalVisible,
    accountVisible,
    addGroup,
    updateAgent,
    editType,
    detailData,
    selfInfo,
    taxiConfig,
  },
  personnel: {
    allUsers,
  },
  global: {
    profile,
  },
}) => ({
  visible: editModalVisible,
  accountVisible,
  updateAgent,
  addGroup,
  editType,
  detailData,
  selfInfo,
  allUsers,
  profile,
  taxiConfig,
}))(CreateGroupModal);

export { Container as CreateGroupModal };
