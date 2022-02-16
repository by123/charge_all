import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Button, Drawer, message, Alert } from 'antd';
import { PageFilter } from '@/containers/PageFilter';
import { PageList } from '@/containers/PageList';
import { OperationLink } from '@/components/OperationLink';
import { deviceStatus, agentAccountColProps, agentAccountLabel } from '@/utils/enum';
import { mapObjectToRadios, dateFormat, getPriceFromService } from '@/utils';
// import { AddDeviceModal } from '@/containers/DeviceAdd/AddDeviceModal';
import { INDEX_WIDTH, ACTION_WIDTH } from '@/utils/constants';
import ErrorList from '@/containers/ErrorList';
import { BindAgentModal } from './BindAgentModal';
import { TransferDeviceModal } from './TransferDeviceModal';
import { UntieDeviceModal } from './UntieDeviceModal';
import { BindBillingModal } from './BindBillingModal';
import { EditDeviceModal } from './EditDeviceModal';
import { DeviceDetail } from './DeviceDetail';
import { NoGroupModal } from '../Group/NoGroupModal';
import { action as deviceActions } from './store';
import { action as personActions } from '../../Personnel/store';
import { action as groupActions } from '../Group/store';

class DevicePage extends React.Component {
  state = {
    visible: false,
    allMchAccount: [],
  }
  fetchList = () => {
    const { dispatch, location: { search } } = this.props;
    dispatch(deviceActions.fetchTaxiDeviceList(search));
  }
  componentDidMount() {
    this.fetchList();
    this.queryAgent();
    this.queryAllGroup();
    this.props.dispatch(groupActions.fetchSelfInfo());
    // this.props.dispatch(deviceActions.queryAgent({ mchId: this.props.mchId }));
    if (this.props.isAdmin) {
      this.props.dispatch(personActions.fetchAllUsers());
    }
  }
  componentDidUpdate({ location }) {
    if (!Object.is(this.props.location, location)) {
      this.fetchList();
    }
  }
  componentWillUnmount() {
    this.props.dispatch(deviceActions.removeQueryAgent());
    this.props.dispatch(deviceActions.selectedRow([], []));
  }
  onSelectChange = (selectedKeys, selectedRows) => {
    this.props.dispatch(deviceActions.selectedRow(selectedKeys, selectedRows));
  }
  openDetail = (id) => {
    this.props.dispatch(deviceActions.fetchDeviceDetail(id));
    this.setState({
      visible: true,
    });
  }
  closeDetail = () => {
    this.setState({
      visible: false,
    });
  }
  isSelected = () => {
    if (this.props.selectedKeys.length > 0) return true;
    message.info('请先选择列表条目');
    return false;
  }
  handleEditDevice = () => {
    this.isSelected() && this.props.dispatch(deviceActions.toggleEditDeviceModal(true));
  }
  handleBindAgent = () => {
    this.isSelected() && this.props.dispatch(deviceActions.toggleBindAgentModal(true));
  }
  handleEditBilling = () => {
    this.isSelected() && this.props.dispatch(deviceActions.toggleEditBillingModal(true));
  }
  handleUntieDevice = () => {
    this.isSelected() && this.props.dispatch(deviceActions.toggleUntieDeviceModal(true));
  }
  handleTransferDevice = () => {
    this.isSelected() && this.props.dispatch(deviceActions.toggleTransferDeviceModal(true));
  }
  editSingleDevice = (sn) => {
    this.props.dispatch(deviceActions.fetchDeviceDetail(sn));
    this.props.dispatch(deviceActions.toggleEditDeviceModal(true, sn));
  }
  renderAgentName = (list, type) => {
    if (type === 0) { // 商户
      const agent = list.find(item => item.mchType === 1) || {};
      return agent.mchName || '-';
    }

    // 代理商
    const agent = list.find(item => item.level === type && item.mchType === 0) || {};
    return agent.mchName || '-';
  }

  queryAgent = () => {
    const { mchId, dispatch } = this.props;
    dispatch(deviceActions.queryAgent({ mchId }));
  }

  onErrorListClose = () => {
    const { dispatch } = this.props;
    dispatch(deviceActions.toggleUntieDeviceModal(false));
    dispatch(deviceActions.toggleTransferDeviceModal(false));
    dispatch(deviceActions.refreshList());
  }

  onChangeSuccess = () => {
    this.props.dispatch(deviceActions.selectedRow([], []));
  }

  queryAllGroup = () => {
    const { mchId, dispatch } = this.props;
    dispatch(deviceActions.queryGroup({ mchId }));
  }
  render() {
    const {
      location: { search },
      allUsers,
      groupList,
      isAdmin,
      deviceList: {
        loading = false,
        current = 1,
        total = 0,
        pageSize = 15,
        dataSource,
      },
      selectedKeys,
      queryAgent,
      editDeviceResult,
    } = this.props;
    const userList = allUsers.result || [];
    const allGroupList = groupList.result || [];
    const agentList = queryAgent.result || [];
    const formatedDeviceStatus = { ...deviceStatus };
    delete formatedDeviceStatus['0'];
    let filterColumns = [
      { dataIndex: 'sn', title: '设备编码', placeholder: '输入设备编号' },
      { dataIndex: 'state', title: '投放状态', type: 'select', list: mapObjectToRadios(formatedDeviceStatus) },
      { dataIndex: 'date', title: '激活时间', type: 'dateArea', startKey: 'startTime', endKey: 'endTime' },
      { dataIndex: 'groupId', title: '所属分组', type: 'select', list: allGroupList, itemAlias: { value: 'groupId', label: 'groupName' } },
      { dataIndex: 'driverPhone', title: '司机手机号' },
    ];
    if (isAdmin) {
      filterColumns.splice(3, 1);
      filterColumns.splice(4, 0, { dataIndex: 'userId', title: '关联业务员', type: 'select', list: userList, itemAlias: { value: 'userId', label: 'name' } });
    }
    filterColumns.push({
      dataIndex: 'mchUserId',
      title: '代理商账号',
      type: 'select',
      colProps: agentAccountColProps,
      list: agentList,
      width: 300,
      itemAlias: { value: 'superUser', label: agentAccountLabel },
    });
    // }
    const filterProps = {
      search,
      columns: filterColumns,
      onChangeSuccess: this.onChangeSuccess,
    };
    const listProps = {
      loading,
      rowKey: 'deviceSn',
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
        { dataIndex: 'deviceSn', title: '设备编码', fixed: 'left', width: 140 },
        { dataIndex: 'deviceState', title: '状态', render: (text) => deviceStatus[text] },
        { dataIndex: 'activeTime', title: '激活时间', render: text => dateFormat(text) },
        {
          title: '代理层级',
          children: [
            { dataIndex: 'mchList', key: 'agent1', width: 120, title: '省代', render: list => this.renderAgentName(list, 1) },
            { dataIndex: 'mchList', key: 'agent2', width: 120, title: '市代', render: list => this.renderAgentName(list, 2) },
            { dataIndex: 'mchList', key: 'agent3', width: 120, title: '区／县代', render: list => this.renderAgentName(list, 3) },
            { dataIndex: 'mchList', key: 'agent4', width: 120, title: '连锁门店', render: list => this.renderAgentName(list, 4) },
            { dataIndex: 'mchList', key: 'biz', width: 120, title: '出租车司机', render: list => this.renderAgentName(list, 0) },
          ],
        },
        { dataIndex: 'groupName', title: '所属分组' },
        { dataIndex: 'driverPhone', title: '司机手机号' },
        { dataIndex: 'devicePrice', title: '设备价格', render: text => getPriceFromService(text) },
        { dataIndex: 'profitPercent', title: '分润比例', render: text => (text ? `${text}%` : '') },
        { dataIndex: 'count', title: '订单数' },
        { dataIndex: 'totalAmountYuan', title: '订单总金额' },
        {
          dataIndex: 'k',
          title: '操作',
          fixed: 'right',
          width: ACTION_WIDTH,
          render: (_, record) => {
            const options = [
              { text: '查看', action: () => { this.openDetail(record.deviceSn); } },
            ];
            record.deviceState === 2 && (options.push({
              text: '编辑', action: () => { this.editSingleDevice(record.deviceSn); },
            }));
            return <OperationLink options={options} />;
          },
        },
      ],
      dataSource,
      scroll: { x: 1600 },
    };
    const deviceResult = editDeviceResult.result || [];
    return (<div className="page-device">
      <div className="content-header">
        <h2>出租车设备</h2>
      </div>
      <PageFilter {...filterProps} />
      <div className="list-operation">
        <Button onClick={this.handleBindAgent}>批量加入分组</Button>
        <Button onClick={this.handleUntieDevice}>批量解绑设备</Button>
        <Button onClick={this.handleTransferDevice}>批量更换分组</Button>
      </div>
      <div className="list-desc">
        <p>共搜索到 {total} 个设备</p>
        {selectedKeys.length > 0 && <Alert showIcon message={`已选择 ${selectedKeys.length} 项数据。`} />}
      </div>
      <PageList {...listProps} />
      <EditDeviceModal />
      <BindAgentModal />
      <BindBillingModal />
      <UntieDeviceModal />
      <TransferDeviceModal />
      <Drawer title="设备详情" width="80%" visible={this.state.visible} onClose={this.closeDetail}>
        <DeviceDetail />
      </Drawer>
      {/* <ResultModal type={EDIT} dispatch={dispatch} visible={deviceResultVisible} result={editDevice.result} /> */}
      <ErrorList dataSource={deviceResult} onClose={this.onErrorListClose} />
      <NoGroupModal />
    </div>);
  }
}

DevicePage.propTypes = {
  dispatch: PropTypes.func.isRequired,
  deviceList: PropTypes.object.isRequired,
  selectedKeys: PropTypes.array.isRequired,
  isAdmin: PropTypes.bool.isRequired,
  editDeviceResult: PropTypes.object.isRequired,
  location: PropTypes.object.isRequired,
  mchId: PropTypes.string.isRequired,
  allUsers: PropTypes.object.isRequired,
  groupList: PropTypes.object.isRequired,
  queryAgent: PropTypes.object.isRequired,
};

export default connect(({ global: { profile }, personnel: { allUsers }, taxiDevice: {
  queryAgent,
  deviceList,
  selectedKeys,
  editDevice,
  deviceResultVisible,
  editDeviceResult,
  groupList,
} }) => ({
  deviceList,
  selectedKeys,
  allUsers,
  editDevice,
  deviceResultVisible,
  queryAgent,
  isAdmin: profile.roleType <= 1,
  mchId: profile.mchId,
  editDeviceResult,
  groupList,
}))(DevicePage);
