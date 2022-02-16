import React, { Component } from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import { message } from 'antd';
import { PageFilter } from '../../containers/PageFilter';
import { PageList } from '../../containers/PageList';
import { AddBankModal } from '../../containers/AccountAddBank/AddBankModal';
import { OperationLink } from '../../components/OperationLink';
import { DeleteConfirmModal } from '../../components/DeleteConfirmModal';
import { action as applyActions } from './store';
import { action as accountActions } from '../Account/store';
import { INDEX_WIDTH, ACTION_WIDTH, EDIT } from '../../utils/constants';
import { formatAgentType, mapObjectToRadios, checkIsSuperAdmin } from '../../utils';
import { accountState, bankAccountType } from '../../utils/enum';
import './style.less';

class WithdrawalManage extends Component {
  state = {
    selectedData: {},
  }
  componentDidMount = () => {
    this.getWithdrawalList();
  }

  getWithdrawalList = () => {
    const { location: { search } } = this.props;
    this.props.dispatch(applyActions.getWithdrawalManageList(search));
  }

  componentDidUpdate({ location }) {
    if (!Object.is(this.props.location, location)) {
      this.getWithdrawalList();
    }
  }

  openEditModal(data) {
    this.setState({
      selectedData: data,
    });
    this.props.dispatch(accountActions.toggleAddBankModal(true, EDIT, data));
  }

  toggleDeleteModal = (visible, record = {}) => {
    this.props.dispatch(applyActions.toggleDeleteModal(visible));
    this.setState({
      selectedData: record,
    });
  }

  handleDelete = () => {
    const { selectedData } = this.state;
    this.props.dispatch(applyActions.deleteWechatWithdrawal({
      id: selectedData.id,
    }, () => {
      this.getWithdrawalList();
      message.success('微信提现删除成功');
      this.toggleDeleteModal(false);
    }));
  }


  render() {
    const {
      location: { search },
      withdrawalManageList: {
        current = 1,
        total = 0,
        pageSize = 15,
        dataSource,
      } = {},
      isSuperAdmin,
      deleteWechatWithdrawalResult,
      visible,
    } = this.props;
    const { selectedData = {} } = this.state;
    const filterProps = {
      search,
      columns: [
        { dataIndex: 'mchId', title: '代理商编号' },
        { dataIndex: 'mchName', title: '代理商名称' },
        { dataIndex: 'contactUser', title: '代理人姓名' },
        { dataIndex: 'isPublic', title: '账户类型', type: 'select', list: mapObjectToRadios(bankAccountType) },
        {
          dataIndex: 'mchId1',
          title: '代理商账号',
          type: 'agentFilter',
          isFull: true,
          changeOnSelect: true,
          childUseable: true,
          width: 250,
        },
      ],
    };
    //审核状态列表
    const listProps = {
      rowKey: 'id',
      pagination: {
        current,
        total,
        pageSize,
      },
      dataSource,
      columns: [
        { dataIndex: 'id', title: '编号', fixed: 'left', width: INDEX_WIDTH },
        { dataIndex: 'mchId', title: '代理商编号' },
        { dataIndex: 'mchType', title: '代理商类型', render: (text, record) => formatAgentType(text, record.level) },
        { dataIndex: 'mchName', title: '代理商名称' },
        { dataIndex: 'isPublic', title: '账户类型', render: text => bankAccountType[text] },
        { dataIndex: 'bankName', title: '开户行' },
        { dataIndex: 'bankId', title: '银行卡号' },
        { dataIndex: 'accountState', title: '提现状态', render: text => accountState[text] },
        {
          dataIndex: 'b',
          title: '操作',
          fixed: 'right',
          width: ACTION_WIDTH,
          render: (_, record) => {
            let options = [
              { text: '编辑', action: () => { this.openEditModal(record); } },
            ];
            if (isSuperAdmin && record.isPublic === 2) {
              options.push({ text: '删除', action: () => { this.toggleDeleteModal(true, record); } });
            }
            return <OperationLink options={options} />;
          },
        },
      ],
    };

    let confirmColumns = [];
    if (selectedData) {
      confirmColumns = [
        { name: '代理商名称', value: selectedData.mchName },
        { name: '代理商编号', value: selectedData.mchId },
        { name: '账户类型', value: bankAccountType[selectedData.isPublic] },
      ];
    }

    return (<div>
      <div className="page-financeCenter">
        <div className="content-header">
          <h2>提现管理</h2>
        </div>
        <PageFilter {...filterProps} />
        <div className="list-desc">
          <p>共搜索到 {total} 条记录</p>
        </div>
        <PageList {...listProps} />
      </div>
      <AddBankModal />
      <DeleteConfirmModal
        onOk={this.handleDelete}
        onCancel={() => this.toggleDeleteModal(false)}
        loading={deleteWechatWithdrawalResult.loading}
        visible={visible}
        confirmColumns={confirmColumns}
      />
    </div>
    );
  }
}

WithdrawalManage.propTypes = {
  location: PropTypes.object.isRequired,
  dispatch: PropTypes.func.isRequired,
  withdrawalManageList: PropTypes.object.isRequired,
  isSuperAdmin: PropTypes.bool.isRequired,
  deleteWechatWithdrawalResult: PropTypes.object.isRequired,
};

WithdrawalManage.defaultProps = {
  deleteWechatWithdrawalResult: {},
};

export default connect(({ financeCenter: {
  withdrawalManageList,
  deleteWechatWithdrawalResult,
  deleteModalVisible,
}, global: { profile } }) => ({
  withdrawalManageList,
  deleteWechatWithdrawalResult,
  visible: deleteModalVisible,
  isSuperAdmin: checkIsSuperAdmin(profile, 4),
}))(WithdrawalManage);
