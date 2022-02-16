import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Button, Icon, Alert, Drawer } from 'antd';
import { PageFilter } from '@/containers/PageFilter';
import { PageList } from '@/containers/PageList';
import { OperationLink } from '@/components/OperationLink';
import { dateFormat, concatLabel, renderGroupPrice, checkIsSuperAdmin } from '@/utils';
import { INDEX_WIDTH, ACTION_WIDTH } from '@/utils/constants';
import { action as taxiActions } from './store';
import { action as personActions } from '../../Personnel/store';
import { action as deviceActions } from '../../Device/store';

import { CreateGroupModal } from './CreateGroupModal';
import { GroupDetail } from './GroupDetail';
import { NoGroupModal } from './NoGroupModal';

class GroupManage extends React.Component {
  state = {
    // selectedKeys: [],
    id: null,
    visible: false,
    mchType: null,
    allMchAccount: [],
  }
  fetchList = () => {
    const { dispatch, location: { search } } = this.props;
    dispatch(taxiActions.fetchGroupList(search));
  }
  componentDidMount() {
    this.props.dispatch(personActions.fetchAllUsers());
    this.fetchList();
    this.getTaxiConfig();
  }
  componentWillUnmount() {
    this.props.dispatch(taxiActions.selectedRow([], []));
    this.props.dispatch(deviceActions.removeQueryAgent());
  }
  componentDidUpdate({ location }) {
    if (!Object.is(this.props.location, location)) {
      this.fetchList();
    }
  }

  getTaxiConfig() {
    this.props.dispatch(taxiActions.getTaxiConfig());
  }

  onSelectChange = (selectedKeys, selectedRows) => {
    this.props.dispatch(taxiActions.selectedRow(selectedKeys, selectedRows));
  }

  openDetail = (id) => {
    this.props.dispatch(taxiActions.fetchGroupDetail(id));
    this.setState({
      visible: true,
    });
  }
  closeDetail = () => {
    this.setState({
      visible: false,
    });
  }
  render() {
    const {
      location: { search },
      dispatch,
      selectedKeys,
      allUsers,
      groupData: {
        loading = false,
        current = 1,
        total = 0,
        pageSize = 15,
        dataSource,
      },
    } = this.props;
    const userList = allUsers.result || [];
    let filterColumns = [
      { dataIndex: 'groupName', title: '分组名称' },
      { dataIndex: 'salesId', title: '关联业务员', type: 'select', list: userList, itemAlias: { value: 'userId', label: 'name' } },
    ];
    const filterProps = {
      search,
      columns: filterColumns,
    };
    const listProps = {
      loading,
      rowKey: 'groupId',
      rowSelection: {
        selectedRowKeys: selectedKeys,
        onChange: this.onSelectChange,
      },
      pagination: {
        current,
        total,
        pageSize,
      },
      columns: [
        { dataIndex: 'id', title: '序号', fixed: 'left', width: INDEX_WIDTH },
        { dataIndex: 'groupName', title: '分组名称' },
        { dataIndex: 'salesName', title: '关联业务员' },
        { dataIndex: 'deviceTotal', title: '设备数量' },
        { dataIndex: 'deviceTotalActive', title: '激活数量' },
        { dataIndex: 'taxiNum', title: '司机数量' },
        { dataIndex: 'profitPercentTaxi', title: '分润比例', render: text => concatLabel(text, '%') },
        { dataIndex: 'service', title: '默认价格', render: renderGroupPrice },
        { dataIndex: 'orderTotalnum', title: '订单数' },
        { dataIndex: 'orderTotalmoneyStr', title: '订单总金额' },
        { dataIndex: 'createTime', title: '账号创建日期', render: text => dateFormat(text) },
        {
          dataIndex: 'p',
          title: '操作',
          fixed: 'right',
          width: ACTION_WIDTH,
          render: (_, record) => {
            const options = [
              { text: '查看', action: () => { this.openDetail(record.groupId); } },
              { text: '编辑', action: () => { dispatch(taxiActions.showEditAgent(record.groupId)); } },
            ];
            return <OperationLink options={options} />;
          },
        },
      ],
      dataSource,
      scroll: { x: 1500 },
    };
    const drawerTitle = '分组详情';
    return (<div className="page-agent">
      <div className="content-header">
        <h2>分组管理</h2>
        <div className="operation">
          <Button
            className="g-btn-black"
            type="primary"
            onClick={() => dispatch(taxiActions.showAddGroup())}
          >
            <Icon type="plus" theme="outlined" />新建分组
          </Button>
        </div>
      </div>
      <PageFilter {...filterProps} />
      <div className="list-desc">
        <p>共搜索到 {total} 条数据</p>
        {selectedKeys.length > 0 && <Alert showIcon message={`已选择 ${selectedKeys.length} 项数据。`} />}
      </div>
      <PageList {...listProps} />
      <Drawer title={drawerTitle} width="80%" visible={this.state.visible} onClose={this.closeDetail}>
        <GroupDetail />
      </Drawer>
      {/* <EditAgentModal />
      <AddProfitModal /> */}
      <CreateGroupModal />
      <NoGroupModal />
    </div>);
  }
}

GroupManage.propTypes = {
  groupData: PropTypes.object,
  selectedKeys: PropTypes.array.isRequired,
  selfInfo: PropTypes.object,
  selectedAgents: PropTypes.array.isRequired,
  dispatch: PropTypes.func.isRequired,
  location: PropTypes.object.isRequired,
  allUsers: PropTypes.object.isRequired,
};

GroupManage.defaultProps = {
  groupData: {},
  selfInfo: {},
};


export default connect(({ global: { profile, authCode },
  personnel: { allUsers },
  taxiGroup: { groupData, selectedKeys, selfInfo, selectedAgents },
  device: { queryAgent } }) => ({
  groupData,
  selectedKeys,
  allUsers,
  selfInfo,
  isAdmin: profile.roleType <= 1,
  mchId: profile.mchId,
  isSuperAdmin: checkIsSuperAdmin(profile),
  queryAgent,
  selectedAgents,
  authCode,
}))(GroupManage);
